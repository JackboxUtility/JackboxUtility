import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/model/patchsCategory.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../components/dialogs/downloadPatchDialog.dart';
import '../../model/usermodel/userjackboxgamepatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../model/usermodel/userjackboxpackpatch.dart';
import '../../services/api/api_service.dart';

class CategoryPackPatch extends StatefulWidget {
  CategoryPackPatch({Key? key, required this.category}) : super(key: key);

  final PatchCategory category;
  @override
  State<CategoryPackPatch> createState() => _CategoryPackPatchState();
}

class _CategoryPackPatchState extends State<CategoryPackPatch> {
  String buttonText = "";
  bool installButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    _getPatchStatus();
    return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Acrylic(
                shadowColor: Colors.black,
                blurAmount: 1,
                tintAlpha: 1,
                tint: Color.fromARGB(255, 48, 48, 48),
                child: Stack(children: [
                  FilledButton(
                      child: Text(buttonText),
                      onPressed: !installButtonDisabled
                          ? null
                          // ? () {
                          //     showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return DownloadPatchDialogComponent(
                          //               localPath: widget.pack.path!,
                          //               patch: widget.patch);
                          //         });
                          //   }
                          : null),
                  Container(
                      padding: EdgeInsets.only(bottom: 12, top: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.category.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 25)),
                                    Text(
                                      widget.category.smallDescription,
                                    ),
                                    SizedBox(height: 10),
                                    StaggeredGrid.count(
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        crossAxisCount: 3,
                                        children: List.generate(widget.category.getAvailablePatchs().length, (index) => PackInCategoryCard(data: widget.category.getAvailablePatchs()[index])))
                                  ]),
                            )),
                          ])),
                ]))));
  }

  void _getPatchStatus() {
    switch (widget.category.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = AppLocalizations.of(context)!.patch_unavailable;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_installed;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = AppLocalizations.of(context)!.patch_outdated;
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_not_installed;
        break;
      default:
    }
    setState(() {});
  }
}

class PackInCategoryCard extends StatefulWidget {
  PackInCategoryCard({Key? key, required this.data}) : super(key: key);

  final PackAvailablePatchs data;

  @override
  State<PackInCategoryCard> createState() => _PackInCategoryCardState();
}

class _PackInCategoryCardState extends State<PackInCategoryCard> {
  Color? backgroundColor;

  @override
  void initState() {
    _loadBackgroundColor();
    super.initState();
  }

  void _loadBackgroundColor() {
    PaletteGenerator.fromImageProvider(CachedNetworkImageProvider(
            APIService().assetLink(widget.data.pack.pack.background)))
        .then((value) {
      setState(() {
        backgroundColor = value.dominantColor?.color;
      });
    });
  }

  UserInstalledPatchStatus _installedStatus() {
    UserInstalledPatchStatus status = UserInstalledPatchStatus.NOT_INSTALLED;
    for (var patch in widget.data.packPatchs) {
      if (patch.getInstalledStatus() ==
          UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED &&
          status != UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED;
      }
    }

    for (var patch in widget.data.gamePatchs) {
      if (patch.getInstalledStatus() ==
          UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED &&
          status != UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED;
      }
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            margin: EdgeInsets.only(top: 30, left: 5),
            child: Container(
                width: 20,
                height: 20,
                decoration: new BoxDecoration(
                  color: _installedStatus().color,
                  shape: BoxShape.circle,
                ))),
        Container(
            height: 200,
            margin: EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: backgroundColor,
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 12),
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(children: [
                                    Image.network(
                                        APIService()
                                            .assetLink(widget.data.pack.pack
                                                .icon),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                    SizedBox(height: 10),
                                    Text(widget.data.pack.pack.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 25)),
                                    Expanded(child: SizedBox()),
                                  ]),
                                ))
                              ])),
                    ])))),
        Container(
            margin: EdgeInsets.only(top: 35, left: 10),
            child: Tooltip(
                child: Container(
                    width: 10,
                    height: 10,
                    decoration: new BoxDecoration(
                      color: _installedStatus().color,
                      shape: BoxShape.circle,
                    )),
                message: _installedStatus().info)),
      ],
    ));
  }
}
