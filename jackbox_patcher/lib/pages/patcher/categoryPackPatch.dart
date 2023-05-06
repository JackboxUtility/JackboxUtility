import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/components/blurhashimage.dart';
import 'package:jackbox_patcher/model/patchsCategory.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../components/dialogs/downloadPatchDialog.dart';
import '../../model/usermodel/userjackboxgamepatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../model/usermodel/userjackboxpackpatch.dart';
import '../../services/api/api_service.dart';

class CategoryPackPatch extends StatefulWidget {
  CategoryPackPatch(
      {Key? key,
      required this.category,
      required this.showAllPacks,
      required this.changeMenuView})
      : super(key: key);

  final PatchCategory category;
  final bool showAllPacks;
  final Function(String) changeMenuView;
  @override
  State<CategoryPackPatch> createState() => _CategoryPackPatchState();
}

class _CategoryPackPatchState extends State<CategoryPackPatch> {
  String buttonText = "";
  bool installButtonDisabled = false;
  List<dynamic> installablePatchs = [];
  List<String> installablePatchPaths = [];

  @override
  void initState() {
    _buildInstallableList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getPatchStatus();
    return Padding(padding: 
            EdgeInsets.all(12), child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
                       FilledButton(
                          child: Text(buttonText),
                          onPressed: !installButtonDisabled
                              ? () async {
                                  await showDialog(
                                    dismissWithEsc: false,
                                      context: context,
                                      builder: (context) {
                                        return DownloadPatchDialogComponent(
                                            localPaths: installablePatchPaths,
                                            patchs: installablePatchs);
                                      });
                                  setState(() {});
                                }
                              : null),
      SizedBox(height: 20), 
        Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: Colors.black,
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
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
                                            children: List.generate(
                                                widget.showAllPacks
                                                    ? widget.category
                                                        .getAvailablePatchs()
                                                        .length
                                                    : widget.category
                                                        .getAvailablePatchs()
                                                        .where((element) =>
                                                            element.pack.owned)
                                                        .length,
                                                (index) => PackInCategoryCard(
                                                    data: widget.showAllPacks
                                                        ? _sortAvailablePatchs()[
                                                            index]
                                                        : _sortAvailablePatchs()
                                                            .where((element) =>
                                                                element.pack.owned)
                                                            .toList()[index],
                                                    changeMenuView:
                                                        widget.changeMenuView)))
                                      ]),
                                )),
                              ])),
                    ])))),
        SizedBox(height: 20)
      ],)
    );
  }

  List<PackAvailablePatchs> _sortAvailablePatchs() {
    List<PackAvailablePatchs> availablePatchs =
        widget.category.getAvailablePatchs();
    availablePatchs.sort((a, b) {
      if (a.installedStatus().index > b.installedStatus().index) {
        return 1;
      } else if (a.installedStatus().index < b.installedStatus().index) {
        return -1;
      } else {
        return 0;
      }
    });
    return availablePatchs;
  }

  void _buildInstallableList() {
    installablePatchs = [];
    installablePatchPaths = [];
    widget.category.gamePatches.forEach((element) {
      if (element.getPack().owned &&
          element.getPack().path != null &&
          element.getInstalledStatus() != UserInstalledPatchStatus.INSTALLED) {
        installablePatchs.add(element);
        installablePatchPaths.add(element.getPack().path!);
      }
    });
    widget.category.packPatches.forEach((element) {
      if (element.getPack().owned &&
          element.getPack().path != null &&
          element.getInstalledStatus() != UserInstalledPatchStatus.INSTALLED) {
        installablePatchs.add(element);
        installablePatchPaths.add(element.getPack().path!);
      }
    });
  }

  void _getPatchStatus() {
    switch (widget.category.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = AppLocalizations.of(context)!.patch_unavailable;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = AppLocalizations.of(context)!
            .patch_installed(widget.category.packPatches.length);
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = AppLocalizations.of(context)!.patch_outdated(widget
            .category.packPatches
            .where((element) =>
                element.getInstalledStatus() ==
                UserInstalledPatchStatus.INSTALLED_OUTDATED)
            .length);
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_not_installed(widget
            .category.packPatches
            .where((element) =>
                element.getInstalledStatus() ==
                    UserInstalledPatchStatus.INSTALLED_OUTDATED ||
                element.getInstalledStatus() ==
                    UserInstalledPatchStatus.NOT_INSTALLED)
            .length);
        break;
      default:
    }
    setState(() {});
  }
}

class PackInCategoryCard extends StatefulWidget {
  PackInCategoryCard(
      {Key? key, required this.data, required this.changeMenuView})
      : super(key: key);

  final PackAvailablePatchs data;
  final Function(String) changeMenuView;

  @override
  State<PackInCategoryCard> createState() => _PackInCategoryCardState();
}

class _PackInCategoryCardState extends State<PackInCategoryCard> {
  Color? backgroundColor;

  @override
  void initState() {
    print(widget.data.pack.pack.name);
    print(widget.data.packPatchs.length);
    //_loadBackgroundColor();
    super.initState();
  }

  void _loadBackgroundColor() {
    PaletteGenerator.fromImageProvider(CachedNetworkImageProvider(
            APIService().assetLink(widget.data.pack.pack.icon)))
        .then((value) {
      setState(() {
        backgroundColor = value.dominantColor?.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () {
              widget.changeMenuView(widget.data.pack.pack.id);
            },
            child: Container(
                child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, left: 5),
                    child: Container(
                        width: 20,
                        height: 20,
                        decoration: new BoxDecoration(
                          color: widget.data.installedStatus().color,
                          shape: BoxShape.circle,
                        ))),
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                        //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: backgroundColor!=null?backgroundColor!.withOpacity(0.2): Colors.transparent, width: 1)),
                        height: 200,
                        child: Acrylic(
                            shadowColor: Color.fromARGB(255, 181, 181, 181),
                            blurAmount: 1,
                            tintAlpha: 1,
                            tint: Color.fromARGB(255, 45, 45, 45),
                            child: Stack(children: [
                              //_buildPackBackground(),
                              Container(
                                  padding: EdgeInsets.only(bottom: 12, top: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Column(children: [
                                            CachedNetworkImage(
                                                imageUrl: APIService().assetLink(widget.data.pack.pack.icon),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover),
                                            SizedBox(height: 10),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                            Text(
                                              widget.data.packPatchs.length >= 1
                                                  ? widget.data.packPatchs[0]
                                                      .patch.smallDescription
                                                  : widget.data.pack.pack
                                                      .description,
                                              textAlign: TextAlign.center,
                                            ),
                                            Expanded(
                                              child: SizedBox(),
                                            ),
                                          ]),
                                        ))
                                      ])),
                            ])))),
                if (widget.data.packPatchs.length > 0)
                  Container(
                      margin: EdgeInsets.only(top: 10, right: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(widget.data.packPatchs[0].patch.latestVersion)
                          ])),
                Container(
                    margin: EdgeInsets.only(top: 15, left: 10),
                    child: Tooltip(
                        child: Container(
                            width: 10,
                            height: 10,
                            decoration: new BoxDecoration(
                              color: widget.data.installedStatus().color,
                              shape: BoxShape.circle,
                            )),
                        message: widget.data.installedStatus().info)),
              ],
            ))));
  }

  Widget _buildPackBackground() {
    List<Widget> columnChildren = [];
    int totalGames = 0;
    for (var patch in widget.data.packPatchs) {
      totalGames += patch.patch.components.length;
    }
    totalGames += widget.data.gamePatchs.length;
    int lineNumber = sqrt(totalGames).ceil();

    List<List<String>> gamesImages = [];

    for (var line = 0; line < lineNumber; line++) {
      gamesImages.add([]);
    }

    int currentLine = 0;
    for (var patch in widget.data.packPatchs) {
      for (var game in patch.patch.components) {
        gamesImages[currentLine].add(game.getLinkedGame()!.background);
        currentLine++;
        if (currentLine >= lineNumber) {
          currentLine = 0;
        }
      }
    }

    double height = 180 / lineNumber - 20;

    gamesImages.forEach((element) {
      columnChildren.add(Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: element
                  .map((e) => Expanded(
                      child: Opacity(
                          opacity: 0.1,
                          child: Container(
                              margin: EdgeInsets.all(6),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                      imageUrl: APIService().assetLink(e),
                                      fit: BoxFit.contain))))))
                  .toList())));
    });
    return ClipRect(
        child: SizedBox(
            height: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: columnChildren)));
  }
}
