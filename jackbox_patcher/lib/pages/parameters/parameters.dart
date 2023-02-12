import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

class ParametersRoute extends StatefulWidget {
  ParametersRoute({Key? key}) : super(key: key);

  @override
  State<ParametersRoute> createState() => _ParametersRouteState();
}

class _ParametersRouteState extends State<ParametersRoute> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    var packs = UserData().packs;
    return NavigationView(
        content: Column(children: [
      Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            GestureDetector(onTap: ()=>Navigator.pop(context), child: Icon(
              FluentIcons.chevron_left,
              size: 30,
            )),
            SizedBox(width: 16),
            Text("Paramètres", style: typography.display)
          ])),
      Expanded(
          child: ParametersWidget(
        packs: packs,
      ))
    ]));
  }
}

class ParametersWidget extends StatefulWidget {
  ParametersWidget({Key? key, required this.packs}) : super(key: key);

  final List<UserJackboxPack> packs;
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
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
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
              Text("Packs possédés", style: typography.titleLarge),
              SizedBox(
                height: 10,
              ),
              _showOwnedPack(),
              SizedBox(
                height: 10,
              ),
              FilledButton(
                  child: const Text('Ajouter un pack'),
                  onPressed: () {
                    _showAddPackDialog();
                  }),
            ]))
      ],
    );
  }

  _showAddPackDialog() async {
    bool? packSelected = await showDialog<bool>(
        context: context,
        builder: (context) => ContentDialog(
              title: const Text("Ajouter un pack"),
              content: SizedBox(
                  child: Row(children: [
                Expanded(
                  child: ComboBox<UserJackboxPack>(
                    value: selectedPack,
                    items: List.generate(
                        widget.packs.length,
                        (index) => ComboBoxItem(
                              value: widget.packs[index],
                              onTap: () {},
                              child: Text(widget.packs[index].pack.name),
                            )),
                    onChanged: (pack) async {
                      await pack!.setOwned(true);
                      Navigator.pop(context, true);
                    },
                    placeholder: const Text("Choisissez un pack"),
                  ),
                )
              ])),
              actions: [
                TextButton(
                    child: const Text("Annuler"),
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.packs.where((element) => element.owned).length,
        itemBuilder: (context, index) {
          return _buildOwnedPack(
              widget.packs.where((element) => element.owned).toList()[index]);
        });
  }

  Widget _buildOwnedPack(UserJackboxPack pack) {
    return PackInParametersWidget(
      pack: pack,
      reloadallPacks: () {
        setState(() {});
      },
    );
  }
}

class PackInParametersWidget extends StatefulWidget {
  PackInParametersWidget(
      {Key? key, required this.pack, required this.reloadallPacks})
      : super(key: key);

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
    packStatus = await widget.pack.getPathStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(packStatus);
    return ListTile(
      leading: packStatus == "NOT_FOUND"
          ? Icon(FluentIcons.warning, color: Colors.red)
          : packStatus == "INEXISTANT"
              ? Icon(FluentIcons.warning, color: Colors.yellow)
              : Icon(FluentIcons.check_mark, color: Colors.green),
      title: Text(widget.pack.pack.name),
      subtitle: Text(
          packStatus == "NOT_FOUND"
              ? "Le chemin vers le pack n'a pas été trouvé !"
              : (widget.pack.path != null && widget.pack.path != ""
                  ? widget.pack.path!
                  : "Aucun chemin renseigné"),
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
              title: const Text("Ajouter un pack"),
              content: SizedBox(
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Chemin du pack"),
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
                    child: const Text("Annuler"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                TextButton(
                    child: const Text("Valider"),
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
