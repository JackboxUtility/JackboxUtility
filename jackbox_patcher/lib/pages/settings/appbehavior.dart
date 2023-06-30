import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/confirmationDialog.dart';
import 'package:jackbox_patcher/components/settings/buttonSetting.dart';

import '../../components/settings/booleanSetting.dart';
import '../../components/settings/columnSetting.dart';
import '../../services/user/userdata.dart';

class AppBehaviorSettings extends StatefulWidget {
  AppBehaviorSettings({Key? key}) : super(key: key);

  @override
  State<AppBehaviorSettings> createState() => _AppBehaviorSettingsState();
}

class _AppBehaviorSettingsState extends State<AppBehaviorSettings> {
  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1200) {
      return (MediaQuery.of(context).size.width - 1080) / 2;
    } else {
      return 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: calculatePadding(),
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("App startup",
                style: FluentTheme.of(context).typography.title),
            const SizedBox(height: 10),
            BooleanSetting(
                title: "Open launcher on app startup",
                description: "Open the list of games when you open the app.",
                isChecked: UserData().settings.isOpenLauncherOnStartupActivated,
                setter: UserData().settings.setOpenLauncherOnStartup,
                parentReload: () => setState(() {})),
            const SizedBox(height: 30),
            Text("Discord Rich Presence Settings",
                style: FluentTheme.of(context).typography.title),
            const SizedBox(height: 10),
            BooleanSetting(
                title: "Discord Rich Presence",
                description:
                    "Show what you're playing on Discord. This will only work if you have Discord open.",
                isChecked: UserData().settings.isDiscordRPCActivated,
                setter: UserData().settings.setDiscordRPC,
                parentReload: () => setState(() {})),
            const SizedBox(height: 30),
            Text("App saves", style: FluentTheme.of(context).typography.title),
            const SizedBox(height: 10),
            ColumnSetting(color: Colors.red, children: [
              ButtonSetting(
                  title: "Reset stars",
                  description: "Reset every stars for each game",
                  buttonText: "Reset stars",
                  onClick: () {
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            toConfirm: "reset every stars for each game",
                            todoWhenConfirmed: () {
                              UserData().resetStars();
                              setState(() {});
                            }));
                    UserData().resetStars();
                    setState(() {});
                  },
                  style: ButtonSettingStyle.DANGER),
              Divider(
                  style: DividerThemeData(horizontalMargin: EdgeInsets.all(12)),
                  size: double.infinity),
              ButtonSetting(
                  title: "Reset hidden games",
                  description: "Reset every hidden games to visible",
                  buttonText: "Reset hidden games",
                  onClick: () {
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            toConfirm: "reset every hidden games to visible",
                            todoWhenConfirmed: () {
                              UserData().resetHiddenGames();
                              setState(() {});
                            }));
                  },
                  style: ButtonSettingStyle.DANGER)
            ])
          ],
        ));
  }
}
