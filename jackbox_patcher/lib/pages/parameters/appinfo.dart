import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoWidget extends StatefulWidget {
  AppInfoWidget({Key? key}) : super(key: key);

  @override
  State<AppInfoWidget> createState() => _AppInfoWidgetState();
}

class _AppInfoWidgetState extends State<AppInfoWidget> {
  String version = "";

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) => setState((() => version = value.version)));
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
    Typography typography = FluentTheme.of(context).typography;
    return Padding(
        padding:
            EdgeInsets.symmetric(vertical: 24, horizontal: calculatePadding()),
        child: Column(children: [
          Spacer(flex:2),
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset('assets/logo.png', height: 100)),
          Text(AppLocalizations.of(context)!.jackbox_utility,
              style: FluentTheme.of(context).typography.titleLarge),
          SizedBox(height:12),
          Text(
              "An open-source app to download patches and launch Jackbox games",
              style: FluentTheme.of(context).typography.body),
          SizedBox(height:12),
          Text(AppLocalizations.of(context)!.version+" " + version,
              style: FluentTheme.of(context).typography.body),
          SizedBox(height:12),
          Row( mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  child: Row(children:[FaIcon(FontAwesomeIcons.github), SizedBox(width: 10,), Text("GitHub")]),
                  onPressed: () async {
                    await launchUrl(Uri.parse("https://github.com/AlexisL61/JackboxUtility")); 
                  })]),
          Spacer(),
          Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Column(children: [

                Text("Authors"),
                TextButton(
                  child: Row(children:[FaIcon(FontAwesomeIcons.github), SizedBox(width: 10,), Text("AlexisL61")]),
                  onPressed: () async {
                    await launchUrl(Uri.parse("https://github.com/AlexisL61")); 
                  }), 
              ]),
              Spacer(),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("Contributors"),
                TextButton(
                  child: Row(children:[FaIcon(FontAwesomeIcons.github), SizedBox(width: 10,), Text("Akira896")]),
                  onPressed: () async {
                    await launchUrl(Uri.parse("https://github.com/AkiraArtuhaxis")); 
                  }), 
                TextButton(
                  child: Row(children:[FaIcon(FontAwesomeIcons.github), SizedBox(width: 10,), Text("Erizzle")]),
                  onPressed: () async {
                    await launchUrl(Uri.parse("https://github.com/DerErizzle")); 
                  })]), 
                  Spacer()]),
          Spacer(flex:2)
        ]));
  }
}
