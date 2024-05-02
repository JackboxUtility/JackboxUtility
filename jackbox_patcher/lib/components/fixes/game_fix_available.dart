import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

class GameFixAvailableComponent extends StatefulWidget {
  GameFixAvailableComponent({Key? key, required this.fix, this.button}) : super(key: key);

  final UserJackboxPackPatch fix;
  final Widget? button;

  @override
  State<GameFixAvailableComponent> createState() =>
      _GameFixAvailableComponentState();
}

class _GameFixAvailableComponentState extends State<GameFixAvailableComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
          border: Border.all(color: Colors.orange, width: 1.0),
          color: Colors.orange,
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.screwdriverWrench,
              color: Colors.white,
              size: 12,
            ),
            SizedBox(
              width: 4,
            ),
            Text(TranslationsHelper().appLocalizations!.fix),
          ],
        ),
        padding: EdgeInsets.all(4),
      ),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0)),
            border: Border.all(color: Colors.orange, width: 1.0),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0)),
              child: Acrylic(
                  blurAmount: 1,
                  tintAlpha: 1,
                  tint: const Color.fromARGB(255, 48, 48, 48),
                  child: SizedBox(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.fix.patch.name,
                                    style: FluentTheme.of(context)
                                        .typography
                                        .subtitle),
                                Text(widget.fix.patch.smallDescription),
                                widget.button!=null?const SizedBox(height: 10):SizedBox.shrink(),
                                widget.button!=null?widget.button!:SizedBox.shrink()
                              ]))))))
    ]);
  }
}
