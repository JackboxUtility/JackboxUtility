import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/automaticGameFinderDialog.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/automaticGameFinder/AutomaticGameFinder.dart';
import '../../services/error/error.dart';

class ParametersWidget extends StatefulWidget {
  ParametersWidget({Key? key, required this.originalPacks}) : super(key: key);

  final List<UserJackboxPack> originalPacks;
  @override
  State<ParametersWidget> createState() => _ParametersWidgetState();
}

class _ParametersWidgetState extends State<ParametersWidget> {
  UserJackboxPack? selectedPack;
  List<UserJackboxPack> packs = [];

  @override
  void initState() {
    packs.addAll(widget.originalPacks);
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
              SizedBox(
                height: 30,
              ),
              Row(children: [
                Text(AppLocalizations.of(context)!.owned_packs,
                    style: typography.titleLarge),
                Spacer(),
                FilledButton(
                    child: Text(AppLocalizations.of(context)!
                        .automatic_game_finder_button),
                    onPressed: () async {
                      await _launchAutomaticGameFinder(true);
                      packs = UserData().packs;
                      setState(() {});
                    })
              ]),
              SizedBox(
                height: 10,
              ),
              _showOwnedPack(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.add_pack),
                leading: Icon(FluentIcons.add),
                onPressed: () {
                  _showAddPackDialog();
                },
              ),
              SizedBox(
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
    bool? packSelected = await showDialog<bool>(
        context: context,
        builder: (context) => ContentDialog(
              title: Text(AppLocalizations.of(context)!.add_pack),
              content: SizedBox(
                  child: Row(children: [
                Expanded(
                  child: ComboBox<UserJackboxPack>(
                    value: selectedPack,
                    items: List.generate(
                        widget.originalPacks.length,
                        (index) => ComboBoxItem(
                              value: widget.originalPacks[index],
                              onTap: () {},
                              child:
                                  Text(widget.originalPacks[index].pack.name),
                            )),
                    onChanged: (pack) async {
                      await pack!.setOwned(true);
                      Navigator.pop(context, true);
                    },
                    placeholder:
                        Text(AppLocalizations.of(context)!.choose_pack),
                  ),
                )
              ])),
              actions: [
                TextButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      Navigator.pop(context, false);
                    })
              ],
            ));
    if (packSelected == true) {
      setState(() {});
    }
  }

  Widget _showOwnedPack() {
    return Column(
        children: List.generate(packs.where((element) => element.owned).length,
            (index) {
      return _buildOwnedPack(
          packs.where((element) => element.owned).toList()[index]);
    }));
  }

  Widget _buildOwnedPack(UserJackboxPack pack) {
    return PackInParametersWidget(
        pack: pack, reloadallPacks: _reloadAllPacks);
  }

  _reloadAllPacks() {
    packs = [];
    setState(() {});
    packs.addAll(UserData().packs);
    setState(() {});
  }
}

class PackInParametersWidget extends StatefulWidget {
  PackInParametersWidget(
      {Key? key,
      required this.pack,
      required this.reloadallPacks,
      })
      : super(key: key);

  UserJackboxPack pack;
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
        SizedBox(width: 10),
        Image.network(
          APIService().assetLink(widget.pack.pack.icon),
          height: 30,
          cacheHeight: 30,
        )
      ]),
      title: Text(widget.pack.pack.name),
      subtitle: Text(
          packStatus == "NOT_FOUND"
              ? AppLocalizations.of(context)!.path_not_found_small_description
              : (widget.pack.path != null && widget.pack.path != ""
                  ? widget.pack.path!
                  : AppLocalizations.of(context)!
                      .path_inexistant_small_description),
          style: TextStyle(
              color: packStatus == "NOT_FOUND"
                  ? Colors.red
                  : widget.pack.path != null && widget.pack.path != ""
                      ? Colors.white
                      : Colors.yellow)),
      trailing: Row(children: [
        IconButton(
          icon: const Icon(FluentIcons.edit),
          onPressed: () async {
            await _showModifyPackDialog();
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
                        SizedBox(
                          height: 6,
                        ),
                        TextBox(
                          controller: pathController,
                          onChanged: (value) {
                            widget.pack.setPath(value);
                          },
                        )
                      ])),
              actions: [
                TextButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                TextButton(
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
