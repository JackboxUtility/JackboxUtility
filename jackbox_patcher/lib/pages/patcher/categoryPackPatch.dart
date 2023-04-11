import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patchsCategory.dart';

class CategoryPackPatch extends StatefulWidget {
  CategoryPackPatch({Key? key, required this.category}) : super(key: key);

  final PatchCategory category;
  @override
  State<CategoryPackPatch> createState() => _CategoryPackPatchState();
}

class _CategoryPackPatchState extends State<CategoryPackPatch> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
