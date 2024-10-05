import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

Dio createDio([BaseOptions? baseOptions]) => DioForJackboxUtility(baseOptions);

/// Adapted version of [DioForNative] to for handling partial downloads
///
/// Differences to the regular version:
/// - File can be deleted on error or cancel independently
/// - Data can be overwritten or appended
/// - Timeout is only triggered if there is no data throughput
class DioForJackboxUtility extends DioForNative implements Dio {
  DioForJackboxUtility([BaseOptions? baseOptions]) {
    options = baseOptions ?? BaseOptions();
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  @override
  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      bool deleteOnCancel = true,
      bool appendData = false,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options}) async {
    options = DioMixin.checkOptions('GET', options);

    options.responseType = ResponseType.stream;
    Response<ResponseBody> response;
    try {
      response = await request<ResponseBody>(
        urlPath,
        data: data,
        // Disable fetch timeout because that triggers even though data is transferred
        options: options.copyWith(receiveTimeout: 0),
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? CancelToken(),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        if (e.response!.requestOptions.receiveDataWhenStatusError == true) {
          var res = await transformer.transformResponse(
            e.response!.requestOptions..responseType = ResponseType.json,
            e.response!.data as ResponseBody,
          );
          e.response!.data = res;
        } else {
          e.response!.data = null;
        }
      }
      rethrow;
    }

    response.headers = Headers.fromMap(response.data!.headers);

    File file;
    if (savePath is Function) {
      assert(savePath is String Function(Headers),
          'savePath callback type must be `String Function(HttpHeaders)`');

      response.headers
        ..add('redirects', response.redirects.length.toString())
        ..add('uri', response.realUri.toString());

      file = File(savePath(response.headers) as String);
    } else {
      file = File(savePath.toString());
    }

    file.createSync(recursive: true);

    RandomAccessFile raf = file.openSync(
        mode: appendData ? FileMode.writeOnlyAppend : FileMode.writeOnly);

    Completer<Response> completer = Completer();
    Timer? checker;
    int receivedOnLastCheck = 0;
    int received = 0;

    Stream<Uint8List> stream = response.data!.stream;
    // Pretend that the receive timeout was set, though it is handled outside of the fetch method
    RequestOptions requestOptions = response.requestOptions
        .copyWith(receiveTimeout: options.receiveTimeout);
    bool compressed = false;
    int total = 0;
    String? contentEncoding =
        response.headers.value(Headers.contentEncodingHeader);

    if (contentEncoding != null) {
      compressed = ['gzip', 'deflate', 'compress'].contains(contentEncoding);
    }
    if (lengthHeader == Headers.contentLengthHeader && compressed) {
      total = -1;
    } else {
      total = int.parse(response.headers.value(lengthHeader) ?? '-1');
    }

    late StreamSubscription<Uint8List> subscription;
    Future<void>? asyncWrite;
    bool closed = false;
    Future<void> close(bool delete) async {
      if (!closed) {
        closed = true;
        await asyncWrite;
        await raf.close();
        if (delete && file.existsSync()) {
          await file.delete();
        }
      }
    }

    subscription = stream.listen((data) async {
      subscription.pause();
      asyncWrite = raf.writeFrom(data).then((_) {
        received += data.length;

        onReceiveProgress?.call(received, total);

        if (cancelToken == null || !cancelToken.isCancelled) {
          subscription.resume();
        }
      }).catchError((err, StackTrace stackTrace) async {
        try {
          checker?.cancel();
          await subscription.cancel();
        } finally {
          completer.completeError(DioMixin.assureDioError(
            err,
            requestOptions,
          ));
        }
      });
    }, onDone: () async {
      try {
        checker?.cancel();
        await close(false);
        completer.complete(response);
      } catch (e) {
        completer.completeError(DioMixin.assureDioError(
          e,
          requestOptions,
        ));
      }
    }, onError: (e) async {
      try {
        checker?.cancel();
        await close(deleteOnError);
      } finally {
        completer.completeError(DioMixin.assureDioError(
          e,
          requestOptions,
        ));
      }
    }, cancelOnError: true);

    CancelToken forwarderCancelToken = CancelToken();
    cancelToken?.whenCancel.then((_) async {
      checker?.cancel();
      await subscription.cancel();
      await close(deleteOnCancel);
      // Complete returned future only after everything else is done to avoid issues
      // where file access is still blocked due to this callback being async
      forwarderCancelToken.cancel();
    });

    if (requestOptions.receiveTimeout > 0) {
      checker = Timer.periodic(
          Duration(milliseconds: requestOptions.receiveTimeout), (timer) async {
        int receivedRightNow = received;
        if (receivedOnLastCheck != receivedRightNow) {
          receivedOnLastCheck = receivedRightNow;
        } else {
          timer.cancel();
          await subscription.cancel();
          await close(deleteOnError);
          completer.completeError(DioError(
            requestOptions: requestOptions,
            error: 'Receiving data timeout[${requestOptions.receiveTimeout}ms]',
            type: DioErrorType.receiveTimeout,
          ));
        }
      });
    }

    return DioMixin.listenCancelForAsyncTask(
        forwarderCancelToken, completer.future);
  }

  @override
  Future<Response> downloadUri(Uri uri, savePath,
      {ProgressCallback? onReceiveProgress,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      bool deleteOnCancel = true,
      bool appendData = false,
      lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options}) {
    return download(uri.toString(), savePath,
        onReceiveProgress: onReceiveProgress,
        lengthHeader: lengthHeader,
        deleteOnError: deleteOnError,
        deleteOnCancel: deleteOnCancel,
        appendData: appendData,
        cancelToken: cancelToken,
        data: data,
        options: options);
  }
}
