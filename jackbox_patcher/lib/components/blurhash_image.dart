import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jackbox_patcher/model/misc/url_blur_hash.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';

class BlurHashImage extends StatefulWidget {
  const BlurHashImage(
      {Key? key, required this.url, this.fit, this.width, this.height})
      : super(key: key);

  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  State<BlurHashImage> createState() => _BlurHashImageState();
}

class _BlurHashImageState extends State<BlurHashImage> {
  UrlBlurHash? blurHash;
  bool blurHashRetrieved = false;
  String usedUrl = "";

  @override
  void initState() {
    _retrieveBlurHash();
    super.initState();
  }

  Future<void> _retrieveBlurHash() async {
    blurHash = APIService().getBlurHash(widget.url);
    if (blurHash != null && blurHash!.blurHash != null){
      blurHashRetrieved = true;
      setState(() {});
    }
  }

  int _getDecodingWidth() {
    if (widget.width != null) return widget.width!.toInt();
    if (widget.height != null) {
      return blurHash!.width * widget.height!.toInt() ~/ blurHash!.height;
    }
    return 32;
  }

  int _getDecodingHeight() {
    if (widget.height != null) return widget.height!.toInt();
    if (widget.width != null) {
      return blurHash!.height * widget.width!.toInt() ~/ blurHash!.width;
    }
    return 32;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url != usedUrl) {
      blurHashRetrieved = false;
      usedUrl = widget.url;
      _retrieveBlurHash();
    }
    return CachedNetworkImage(
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: const Duration(milliseconds: 400),
        imageUrl: APIService().assetLink(widget.url),
        width: widget.width,
        height: widget.height,
        memCacheHeight:
            widget.height != null ? (widget.height! * 2).toInt() : null,
        memCacheWidth:
            widget.width != null ? (widget.width! * 2).toInt() : null,
        fit: widget.fit,
        placeholder: (context, url) => SizedBox(
            width: widget.width,
            height: widget.height,
            child:  blurHash != null
                    ?AspectRatio(
                aspectRatio: blurHash!.width / blurHash!.height,
                child: BlurHash(
                        color: Colors.transparent,
                        hash: blurHash!.blurHash!,
                        imageFit: widget.fit ?? BoxFit.fill,
                        decodingWidth: _getDecodingWidth(),
                        decodingHeight: _getDecodingHeight())
    ): Container()));
  }
}
