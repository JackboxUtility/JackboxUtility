import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/familyfriendly.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/moderation.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/streamfriendly.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';

import '../../services/translations/translationsHelper.dart';

typedef SpecialGameInfo = ({
  String name,
  IconData icon,
  String Function(JackboxGameInfo) subname,
  Color Function(JackboxGameInfo) color,
  String? Function(JackboxGameInfo) description
});

class SpecialGameAllInfoWidget extends StatelessWidget {
  const SpecialGameAllInfoWidget(
      {Key? key, required JackboxGameInfo this.gameInfo})
      : super(key: key);

  final JackboxGameInfo gameInfo;

  /**
   * List of all special game info
   */
  static List<SpecialGameInfo> allInfoList = [
    (
      name: "Family Friendly",
      icon: FontAwesomeIcons.child,
      subname: (JackboxGameInfo gI){
        switch (gI.familyFriendly){
          case GameInfoFamilyFriendly.OPTIONAL:
            return "(Optional)";
          default:
            return "";
        }
      },
      color: (JackboxGameInfo gI) {
        switch (gI.familyFriendly) {
          case GameInfoFamilyFriendly.FAMILY_FRIENDLY:
            return Colors.green;
          case GameInfoFamilyFriendly.OPTIONAL:
            return Colors.orange;
          case GameInfoFamilyFriendly.NOT_FAMILY_FRIENDLY:
            return Colors.red;
          default:
            return Colors.red;
        }
      },
      description: (JackboxGameInfo gI) {
        return null;
      }
    ),
    (
      name: TranslationsHelper().appLocalizations!.audience,
      icon: FontAwesomeIcons.users,
      subname: (JackboxGameInfo gI){
        return "";
      },
      color: (JackboxGameInfo gI) {
        if (gI.audience) {
          return Colors.green;
        } else {
          return Colors.red;
        }
      },
      description: (JackboxGameInfo gI) {
        return gI.audienceDescription;
      }
    ),
    (
      name: "Stream friendly",
      icon: FontAwesomeIcons.twitch,
      subname: (JackboxGameInfo gI){
        return "";
      },
      color: (JackboxGameInfo gI) {
        switch (gI.streamFriendly) {
          case GameInfoStreamFriendly.PLAYABLE:
            return Colors.green;
          case GameInfoStreamFriendly.MIDLY_PLAYABLE:
            return Colors.orange;
          case GameInfoStreamFriendly.NOT_PLAYABLE:
            return Colors.red;
          default:
            return Colors.red;
        }
      },
      description: (JackboxGameInfo gI) {
        return gI.streamFriendlyDescription;
      }
    ),
    (
      name: "Moderation",
      icon: FontAwesomeIcons.userShield,
      subname: (JackboxGameInfo gI){
        return "";
      },
      color: (JackboxGameInfo gI) {
        switch (gI.moderation) {
          case GameInfoModeration.FULL_MODERATION:
            return Colors.green;
          case GameInfoModeration.CENSORING:
            return Colors.orange;
          case GameInfoModeration.NO_MODERATION:
            return Colors.red;
          default:
            return Colors.red;
        }
      },
      description: (JackboxGameInfo gI) {
        return gI.moderationDescription;
      }
    ), 
    (
      name: "Subtitles",
      icon: FontAwesomeIcons.closedCaptioning,
      subname: (JackboxGameInfo gI){
        return "";
      },
      color: (JackboxGameInfo gI) {
        if (gI.subtitles) {
          return Colors.green;
        } else {
          return Colors.red;
        }
      },
      description: (JackboxGameInfo gI) {
        return null;
      }
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (SpecialGameInfo specialGameInfo in allInfoList)
          SpecialGameInfoWidget(
            specialGameInfo: specialGameInfo,
            gameInfo: gameInfo,
          )
      ].expand((element) => [element, const SizedBox(height: 20)]).toList(),
    );
  }
}

class SpecialGameInfoWidget extends StatelessWidget {
  const SpecialGameInfoWidget(
      {Key? key,
      required SpecialGameInfo this.specialGameInfo,
      required JackboxGameInfo this.gameInfo})
      : super(key: key);

  final SpecialGameInfo specialGameInfo;
  final JackboxGameInfo gameInfo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(specialGameInfo.icon),
                          ),
                          SizedBox(width: 6),
                          Text(specialGameInfo.name+" "+specialGameInfo.subname(gameInfo)),
                          SizedBox(width: 6),
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: specialGameInfo.color(gameInfo)))
                        ],
                      ),
                      if (specialGameInfo.description(gameInfo) != null)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(specialGameInfo.description(gameInfo)!))
                    ])))));
  }
}
