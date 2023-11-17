import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';

abstract class InstallablePatch {
  Future<void> downloadPatch(String patchUri,
      void Function(String, String, double) callback, CancelToken cancelToken);
  UserJackboxPack getPack();
}
