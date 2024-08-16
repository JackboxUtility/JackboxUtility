import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/family_friendly.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/jackbox_game_info.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/moderation.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/stream_friendly.dart';

import '../../services/translations/translations_helper.dart';

typedef SpecialGameInfo = ({
  String name,
  IconData icon,
  String Function(JackboxGameInfo) subname,
  Color Function(JackboxGameInfo) color,
  String? Function(JackboxGameInfo) description,
  String tooltip
});

class SpecialGameAllInfoWidget extends StatelessWidget {
  const SpecialGameAllInfoWidget({Key? key, required JackboxGameInfo this.gameInfo}) : super(key: key);

  final JackboxGameInfo gameInfo;

  /// List of all special game info
  static List<SpecialGameInfo> allInfoList = [
    (
      name: TranslationsHelper().appLocalizations!.family_friendly,
      icon: FontAwesomeIcons.child,
      tooltip: TranslationsHelper().appLocalizations!.family_friendly_tooltip,
      subname: (JackboxGameInfo gI) {
        switch (gI.familyFriendly) {
          case GameInfoFamilyFriendly.OPTIONAL:
            return TranslationsHelper().appLocalizations!.optional;
          default:
            return "";
        }
      },
      color: (JackboxGameInfo gI) {
        switch (gI.familyFriendly) {
          case GameInfoFamilyFriendly.FAMILY_FRIENDLY:
            return Colors.green;
          case GameInfoFamilyFriendly.OPTIONAL:
            return Colors.green;
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
      icon: FontAwesomeIcons.userPlus,
      tooltip: TranslationsHelper().appLocalizations!.audience_tooltip,
      subname: (JackboxGameInfo gI) {
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
      name: TranslationsHelper().appLocalizations!.subtitles,
      icon: FontAwesomeIcons.closedCaptioning,
      tooltip: TranslationsHelper().appLocalizations!.subtitles_tooltip,
      subname: (JackboxGameInfo gI) {
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
    ),
    (
      name: TranslationsHelper().appLocalizations!.stream_friendly,
      icon: FluentIcons.screen_cast,
      tooltip: TranslationsHelper().appLocalizations!.stream_friendly_tooltip,
      subname: (JackboxGameInfo gI) {
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
      name: TranslationsHelper().appLocalizations!.moderation,
      icon: FontAwesomeIcons.userShield,
      tooltip: TranslationsHelper().appLocalizations!.moderation_tooltip,
      subname: (JackboxGameInfo gI) {
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
    )
  ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      crossAxisCount: 2,
      children: [
        for (SpecialGameInfo specialGameInfo in allInfoList)
          SpecialGameInfoWidget(
            specialGameInfo: specialGameInfo,
            gameInfo: gameInfo,
          )
      ],
    );
  }
}

class SpecialGameInfoWidget extends StatelessWidget {
  const SpecialGameInfoWidget(
      {Key? key, required SpecialGameInfo this.specialGameInfo, required JackboxGameInfo this.gameInfo})
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
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Tooltip(
                          style: const TooltipThemeData(
                              waitDuration: Duration(milliseconds: 500), showDuration: Duration(seconds: 0)),
                          message: specialGameInfo.tooltip,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(specialGameInfo.icon),
                              ),
                              SizedBox(width: 6),
                              Text(specialGameInfo.name),
                              SizedBox(width: 4),
                              Container(
                                  margin: EdgeInsets.only(top: 2),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), color: specialGameInfo.color(gameInfo))),
                              SizedBox(width: 6),
                              Text(specialGameInfo.subname(gameInfo)),
                            ],
                          )),
                      if (specialGameInfo.description(gameInfo) != null)
                        Padding(padding: const EdgeInsets.all(8.0), child: Text(specialGameInfo.description(gameInfo)!))
                    ])))));
  }
}
