import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/settings/booleanSetting.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

class DiscordRichPresenceSettings extends StatefulWidget {
  DiscordRichPresenceSettings({Key? key}) : super(key: key);

  @override
  State<DiscordRichPresenceSettings> createState() =>
      _DiscordRichPresenceSettingsState();
}

class _DiscordRichPresenceSettingsState
    extends State<DiscordRichPresenceSettings> {
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
            Text("Discord Rich Presence Settings",
                style: FluentTheme.of(context).typography.title),
            const SizedBox(height: 10),
            BooleanSetting(
                title: "Discord Rich Presence",
                description:
                    "Show what you're playing on Discord. This will only work if you have Discord open.",
                isChecked: UserData().settings.isDiscordRPCActivated,
                setter: UserData().settings.setDiscordRPC,
                parentReload: () => setState(() {}))
          ],
        ));
  }
}
