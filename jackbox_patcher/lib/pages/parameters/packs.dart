import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/resetPackDialog.dart';
import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../services/automaticGameFinder/AutomaticGameFinder.dart';
import '../../services/error/error.dart';

class ParametersPackRoute extends StatefulWidget {
  const ParametersPackRoute({Key? key}) : super(key: key);

  @override
  _ParametersPackRouteState createState() => _ParametersPackRouteState();
}

class _ParametersPackRouteState extends State<ParametersPackRoute> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return NavigationView(
        appBar: NavigationAppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              child: const Icon(FluentIcons.chevron_left),
              onTap: () => Navigator.pop(context),
            ),
            title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(FluentIcons.settings, size: 25)),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.settings,
                style: typography.title,
              )
            ])),
        content: const ParametersWidget());
  }
}

class ParametersWidget extends StatefulWidget {
  const ParametersWidget({Key? key}) : super(key: key);

  @override
  State<ParametersWidget> createState() => _ParametersWidgetState();
}

class _ParametersWidgetState extends State<ParametersWidget> {
  UserJackboxPack? selectedPack;

  @override
  void initState() {
    super.initState();
  }

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1200) {
      return (MediaQuery.of(context).size.width - 1080) / 2;
    } else {
      return 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;

    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
              horizontal: calculatePadding(),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 30,
              ),
              Row(children: [
                Text(AppLocalizations.of(context)!.owned_packs,
                    style: typography.titleLarge),
                const Spacer(),
                FilledButton(
                    child: Text(AppLocalizations.of(context)!
                        .automatic_game_finder_button),
                    onPressed: () async {
                      await _launchAutomaticGameFinder(true);
                      setState(() {});
                    })
              ]),
              const SizedBox(
                height: 10,
              ),
              _showOwnedPack(),
              if (UserData().packs.length !=
                  UserData().packs.where((element) => element.owned).length)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.add_pack),
                  leading: const Icon(FluentIcons.add),
                  onPressed: () {
                    _showAddPackDialog();
                  },
                ),
              const SizedBox(
                height: 30,
              ),
            ]))
      ],
    );
  }

  Future<void> _launchAutomaticGameFinder(bool showNotification) async {
    int gamesFound =
        await AutomaticGameFinderService.findGames(UserData().packs);
    if (showNotification) {
      InfoBarService.showInfo(
          context,
          AppLocalizations.of(context)!.automatic_game_finder_title,
          AppLocalizations.of(context)!
              .automatic_game_finder_finish(gamesFound));
    }
  }

  _showAddPackDialog() async {
    List<UserJackboxPack> notOwnedPacks =
        UserData().packs.where((element) => !element.owned).toList();
    UserJackboxPack? packSelected = await showDialog<UserJackboxPack?>(
        context: context,
        builder: (context) => ContentDialog(
              title: Text(AppLocalizations.of(context)!.add_pack),
              content: SizedBox(
                  child: Row(children: [
                Expanded(
                  child: ComboBox<UserJackboxPack>(
                    value: selectedPack,
                    items: List.generate(
                        notOwnedPacks.length,
                        (index) => ComboBoxItem(
                              value: notOwnedPacks[index],
                              onTap: () {},
                              child: Text(notOwnedPacks[index].pack.name),
                            )),
                    onChanged: (pack) async {
                      Navigator.pop(context, pack);
                    },
                    placeholder:
                        Text(AppLocalizations.of(context)!.choose_pack),
                  ),
                )
              ])),
              actions: [
                HyperlinkButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      Navigator.pop(context, null);
                    })
              ],
            ));
    if (packSelected != null) {
      setState(() {});
      String? path = await FilePicker.platform.getDirectoryPath(
          dialogTitle: AppLocalizations.of(context)!
              .select_game_location(packSelected.pack.name),
          lockParentWindow: true);
      if (path != null) {
        packSelected.setPath(path);
        setState(() {});
      }
    }
  }

  Widget _showOwnedPack() {
    return Column(
        children: List.generate(
            UserData().packs.where((element) => element.owned).length, (index) {
      return _buildOwnedPack(
          UserData().packs.where((element) => element.owned).toList()[index]);
    }));
  }

  Widget _buildOwnedPack(UserJackboxPack pack) {
    return PackInParametersWidget(pack: pack, reloadallPacks: _reloadAllPacks);
  }

  _reloadAllPacks() {
    setState(() {});
  }
}

class PackInParametersWidget extends StatefulWidget {
  PackInParametersWidget({
    Key? key,
    required this.pack,
    required this.reloadallPacks,
  }) : super(key: key);

  final UserJackboxPack pack;
  final Function reloadallPacks;

  @override
  State<PackInParametersWidget> createState() => _PackInParametersWidgetState();
}

class _PackInParametersWidgetState extends State<PackInParametersWidget> {
  String packStatus = "FOUND";
  TextEditingController pathController = TextEditingController();

  @override
  void initState() {
    if (widget.pack.path != null) pathController.text = widget.pack.path!;
    _loadPackPathStatus();
    super.initState();
  }

  _loadPackPathStatus() async {
    String pathStatus = await widget.pack.getPathStatus();
    if (packStatus != pathStatus) {
      packStatus = pathStatus;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadPackPathStatus();
    return ListTile(
      leading: Row(children: [
        packStatus == "NOT_FOUND"
            ? Icon(FluentIcons.warning, color: Colors.red)
            : packStatus == "INEXISTANT"
                ? Icon(FluentIcons.warning, color: Colors.yellow)
                : Icon(FluentIcons.check_mark, color: Colors.green),
        const SizedBox(width: 10),
        CachedNetworkImage(
            imageUrl: APIService().assetLink(widget.pack.pack.icon),
            height: 30,
            memCacheHeight: 30,
            fit: BoxFit.fitHeight)
      ]),
      title: Text(widget.pack.pack.name),
      subtitle: packStatus == "NOT_FOUND"
          ? Text(AppLocalizations.of(context)!.path_not_found_small_description,
              style: TextStyle(color: Colors.red))
          : (widget.pack.path != null && widget.pack.path != "")
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: HyperlinkButton(
                    style: ButtonStyle(
                        padding: ButtonState.resolveWith(
                            (states) => const EdgeInsets.all(0)),
                        textStyle: ButtonState.resolveWith((states) =>
                            const TextStyle(fontWeight: FontWeight.normal))),
                    child: Text(
                      widget.pack.path!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      launchUrlString(
                          "file:///${widget.pack.path!.replaceAll("\\", "/")}");
                    },
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!
                      .path_inexistant_small_description,
                  style: TextStyle(color: Colors.yellow)),
      trailing: Row(children: [
        if (widget.pack.pack.launchersId != null &&
            widget.pack.pack.launchersId!.steam != null &&
            widget.pack.origin == LauncherType.STEAM)
          IconButton(
            icon: const Icon(FluentIcons.update_restore),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ResetPackDialog(
                      appId: widget.pack.pack.launchersId!.steam!));
            },
          ),
        IconButton(
          icon: const Icon(FluentIcons.folder_open),
          onPressed: () async {
            String? path = await FilePicker.platform.getDirectoryPath(
                dialogTitle: AppLocalizations.of(context)!
                    .select_game_location(widget.pack.pack.name),
                lockParentWindow: true);
            if (path != null) {
              pathController.text = path;
              widget.pack.setPath(path);
              setState(() {});
            }
          },
        ),
        IconButton(
          icon: const Icon(FluentIcons.delete),
          onPressed: () async {
            await widget.pack.setOwned(false);
            widget.reloadallPacks();
            setState(() {});
          },
        ),
      ]),
    );
  }

  _showModifyPackDialog() async {
    bool? pathChanged = await showDialog<bool>(
        context: context,
        builder: (context) => ContentDialog(
              title: Text(AppLocalizations.of(context)!.add_pack),
              content: SizedBox(
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.pack_path),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(children: [
                          Expanded(
                              child: TextBox(
                            controller: pathController,
                            onChanged: (value) {
                              widget.pack.setPath(value);
                            },
                          )),
                          IconButton(
                            icon: const Icon(FluentIcons.folder_open),
                            onPressed: () async {
                              String? path = await FilePicker.platform
                                  .getDirectoryPath(
                                      dialogTitle: AppLocalizations.of(context)!
                                          .select_game_location(
                                              widget.pack.pack.name),
                                      lockParentWindow: true);
                              JULogger().i(path);
                              if (path != null) {
                                pathController.text = path;
                                widget.pack.setPath(path);
                              }
                            },
                          ),
                        ])
                      ])),
              actions: [
                HyperlinkButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                HyperlinkButton(
                    child: Text(AppLocalizations.of(context)!.confirm),
                    onPressed: () {
                      Navigator.pop(context, true);
                    })
              ],
            ));
    if (pathChanged == true) {
      packStatus = await widget.pack.getPathStatus();
      setState(() {});
    }
  }
}
