import 'package:fluent_ui/fluent_ui.dart';

import '../../components/settings/booleanSetting.dart';
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
    return  Padding(
        padding: EdgeInsets.symmetric(
          horizontal: calculatePadding(),
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("App behavior",
                style: FluentTheme.of(context).typography.title),
            const SizedBox(height: 10),
            BooleanSetting(
                title: "Open launcher on app startup",
                description:
                    "Open the list of games when you open the app.",
                isChecked: UserData().settings.isOpenLauncherOnStartupActivated,
                setter: UserData().settings.setOpenLauncherOnStartup,
                parentReload: () => setState(() {}))
          ],
        ));
  }
}