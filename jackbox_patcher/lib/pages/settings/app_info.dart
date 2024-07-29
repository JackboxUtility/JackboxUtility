import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/translations/translations_helper.dart';

class AppInfoWidget extends StatefulWidget {
  const AppInfoWidget({Key? key}) : super(key: key);

  @override
  State<AppInfoWidget> createState() => _AppInfoWidgetState();
}

class _AppInfoWidgetState extends State<AppInfoWidget> {
  List<({String name, List<({String name, String? githubLink})> members})>
      contributorsList = [
    (
      name: TranslationsHelper().appLocalizations!.author,
      members: [(name: "AlexisL61", githubLink: "https://github.com/AlexisL61")]
    ),
    (
      name: TranslationsHelper().appLocalizations!.contributors,
      members: [
        (name: "Akira896", githubLink: "https://github.com/AkiraArtuhaxis"),
        (name: "Erizzle", githubLink: "https://github.com/DerErizzle"),
        (name: "dsty", githubLink: "https://github.com/MeDustyy")
      ]
    ),
    (
      name: TranslationsHelper().appLocalizations!.special_thanks,
      members: [
        (name: "VladGraund", githubLink: "https://github.com/VladGraund"),
        (name: "Forseti", githubLink: null),
        (name: "Piximator", githubLink: null),
        (name: "Charlie", githubLink: null)
      ]
    )
  ];

  String version = "";

  @override
  void initState() {
    PackageInfo.fromPlatform()
        .then((value) => setState((() => version = value.version)));
    // TODO: implement initState
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
    return Padding(
        padding:
            EdgeInsets.symmetric(vertical: 24, horizontal: calculatePadding()),
        child: Column(children: [
          const Spacer(flex: 2),
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset('assets/logo.png', height: 100)),
          Text(TranslationsHelper().appLocalizations!.jackbox_utility,
              style: FluentTheme.of(context).typography.title),
          const SizedBox(height: 12),
          Text(
              TranslationsHelper()
                  .appLocalizations!
                  .jackbox_utility_description,
              style: FluentTheme.of(context).typography.body),
          const SizedBox(height: 12),
          Text("${TranslationsHelper().appLocalizations!.version} $version",
              style: FluentTheme.of(context).typography.body),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            HyperlinkButton(
                child: const Row(children: [
                  FaIcon(FontAwesomeIcons.github),
                  SizedBox(
                    width: 10,
                  ),
                  Text("GitHub")
                ]),
                onPressed: () async {
                  await launchUrl(
                      Uri.parse(APP_LINKS["GITHUB"]!));
                }),
            const SizedBox(width: 12),
            HyperlinkButton(
                child: const Row(children: [
                  FaIcon(FontAwesomeIcons.discord),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Discord")
                ]),
                onPressed: () async {
                  await launchUrl(Uri.parse(APP_LINKS["DISCORD"]!));
                })
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            HyperlinkButton(
                 style: ButtonStyle(
                     border:
                         ButtonState.all(BorderSide(color: Colors.red.lighter))),
                child: Row(children: [
                  FaIcon(FontAwesomeIcons.heart, color: Colors.red.lighter),
                  SizedBox(
                    width: 10,
                  ),
                  Text(TranslationsHelper().appLocalizations!.donate,
                      style: TextStyle(color: Colors.red.lighter))
                ]),
                onPressed: () async {
                  await launchUrl(
                      Uri.parse("https://github.com/sponsors/AlexisL61"));
                }),
          ]),
          const Spacer(),
          _buildCollaborators(),
          const Spacer(flex: 2) 
        ]));
  }

  Widget _buildCollaborators() {
    List<Widget> children = [];

    for (var collaboratorType in contributorsList) {
      children.add(Spacer());
      List<Widget> currentColumnChildren = [];
      currentColumnChildren.add(SizedBox(
        width:180,
        child: Text(collaboratorType.name, textAlign: TextAlign.center,)));
      currentColumnChildren.add(SizedBox(height: 12));
      for (var member in collaboratorType.members) {
        currentColumnChildren.add(HyperlinkButton(
            child: Row(children: [
              member.githubLink != null
                  ? FaIcon(FontAwesomeIcons.github)
                  : SizedBox.shrink(),
              member.githubLink != null
                  ? SizedBox(
                      width: 10,
                    )
                  : SizedBox.shrink(),
              Text(member.name)
            ]),
            onPressed: member.githubLink != (null)
                ? () async {
                    await launchUrl(Uri.parse(member.githubLink!));
                  }
                : (){}));
      }
      children.add( Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: currentColumnChildren,
      ));
    }
    children.add(Spacer());
    return Row(children: children,mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,);
  }
}
