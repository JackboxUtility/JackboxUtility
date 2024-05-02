import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';

abstract class InstallablePatch {
  Future<void> downloadPatch(String patchUri,
      void Function(String, String, double) callback, CancelToken cancelToken);
  UserJackboxPack getPack();
}
