import 'package:fluent_ui/fluent_ui.dart';

import '../services/translations/translations_helper.dart';

class JackboxUtilityTitleWithIcon extends StatefulWidget {
  JackboxUtilityTitleWithIcon({Key? key}) : super(key: key);

  @override
  State<JackboxUtilityTitleWithIcon> createState() => _JackboxUtilityTitleWithIconState();
}

class _JackboxUtilityTitleWithIconState extends State<JackboxUtilityTitleWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child:Image.asset(
                  "assets/logo.png",
                  height: 100,
                )),
      Text(TranslationsHelper().appLocalizations!.jackbox_utility,
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }
}