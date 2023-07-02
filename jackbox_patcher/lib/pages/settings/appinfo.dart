import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/translations/translationsHelper.dart';

class AppInfoWidget extends StatefulWidget {
  const AppInfoWidget({Key? key}) : super(key: key);

  @override
  State<AppInfoWidget> createState() => _AppInfoWidgetState();
}

class _AppInfoWidgetState extends State<AppInfoWidget> {
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
                      Uri.parse("https://github.com/AlexisL61/JackboxUtility"));
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
                  await launchUrl(Uri.parse("https://discord.gg/cYdJkZwCk3"));
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
                  Text(TranslationsHelper().appLocalizations!.donate, style: TextStyle(color: Colors.red.lighter))
                ]),
                onPressed: () async {
                  await launchUrl(
                      Uri.parse("https://github.com/sponsors/AlexisL61"));
                }),
          ]),
          const Spacer(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Column(children: [
                  Text(TranslationsHelper().appLocalizations!.author),
                  HyperlinkButton(
                      child: const Row(children: [
                        FaIcon(FontAwesomeIcons.github),
                        SizedBox(
                          width: 10,
                        ),
                        Text("AlexisL61")
                      ]),
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse("https://github.com/AlexisL61"));
                      }),
                ]),
                const Spacer(),
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(TranslationsHelper().appLocalizations!.contributors),
                  HyperlinkButton(
                      child: const Row(children: [
                        FaIcon(FontAwesomeIcons.github),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Akira896")
                      ]),
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse("https://github.com/AkiraArtuhaxis"));
                      }),
                  HyperlinkButton(
                      child: const Row(children: [
                        FaIcon(FontAwesomeIcons.github),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Erizzle")
                      ]),
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse("https://github.com/DerErizzle"));
                      })
                ]),
                const Spacer()
              ]),
          const Spacer(flex: 2)
        ]));
  }
}
