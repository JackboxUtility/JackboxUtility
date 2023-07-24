import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/confirmationDialog.dart';
import 'package:jackbox_patcher/components/settings/buttonSetting.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

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
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: calculatePadding(),
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  TranslationsHelper()
                      .appLocalizations!
                      .app_behavior,
                  style: FluentTheme.of(context).typography.title),
              const SizedBox(height: 10),
              BooleanSetting(
                  title: TranslationsHelper()
                      .appLocalizations!
                      .settings_app_startup_title,
                  description: TranslationsHelper()
                      .appLocalizations!
                      .settings_app_startup_description,
                  isChecked:
                      UserData().settings.isOpenLauncherOnStartupActivated,
                  setter: UserData().settings.setOpenLauncherOnStartup,
                  parentReload: () => setState(() {})),
              const SizedBox(height: 10),
              BooleanSetting(
                  title:
                      TranslationsHelper().appLocalizations!.settings_sfx_title,
                  description: TranslationsHelper()
                      .appLocalizations!
                      .settings_sfx_description,
                  isChecked: UserData().settings.isAudioActivated,
                  setter: UserData().settings.setAudio,
                  parentReload: () => setState(() {})),
              // const SizedBox(height: 30),
              // Text(
              //     TranslationsHelper()
              //         .appLocalizations!
              //         .settings_discord_rich_presence_category,
              //     style: FluentTheme.of(context).typography.title),
              const SizedBox(height: 10),
              BooleanSetting(
                  title: TranslationsHelper()
                      .appLocalizations!
                      .settings_discord_rich_presence_title,
                  description: TranslationsHelper()
                      .appLocalizations!
                      .settings_discord_rich_presence_description,
                  isChecked: UserData().settings.isDiscordRPCActivated,
                  setter: UserData().settings.setDiscordRPC,
                  parentReload: () => setState(() {})),
              const SizedBox(height: 10),
              BooleanSetting(
                  title: TranslationsHelper()
                      .appLocalizations!
                      .settings_anonymous_data_title, 
                  description: TranslationsHelper()
                      .appLocalizations!
                      .settings_anonymous_data_description,
                  isChecked: UserData().settings.isAnonymousDataActivated,
                  setter: UserData().settings.setAnonymousData,
                  parentReload: () => setState(() {})),
              // const SizedBox(height: 10),
              // BooleanSetting(
              //     title: TranslationsHelper()
              //         .appLocalizations!
              //         .settings_discord_rich_presence_buttons_title,
              //     description: TranslationsHelper()
              //         .appLocalizations!
              //         .settings_discord_rich_presence_buttons_description,
              //     isChecked: UserData().settings.isDiscordRPCActivated &&
              //         UserData().settings.isDiscordRPCButtonsActivated,
              //     setter: (bool rpcBtn) async{
              //       await UserData().settings.setDiscordRPCButtons(rpcBtn);
              //       if (!rpcBtn){
              //         await UserData().settings.setDiscordRPC(false);
              //       }
              //     },
              //     parentReload: () => setState(() {})),
              const SizedBox(height: 30),
              Text(
                  TranslationsHelper()
                      .appLocalizations!
                      .settings_app_saves_category,
                  style: FluentTheme.of(context).typography.title),
              const SizedBox(height: 10),
              ColumnSetting(color: Colors.red, children: [
                ButtonSetting(
                    title: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_stars_title,
                    description: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_stars_description,
                    buttonText: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_stars_button_text,
                    onClick: () {
                      showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                              toConfirm: TranslationsHelper()
                                  .appLocalizations!
                                  .settings_app_reset_stars_action,
                              todoWhenConfirmed: () {
                                UserData().resetStars();
                                setState(() {});
                              }));
                      setState(() {});
                    },
                    style: ButtonSettingStyle.DANGER),
                Divider(
                    style:
                        DividerThemeData(horizontalMargin: EdgeInsets.all(12)),
                    size: double.infinity),
                ButtonSetting(
                    title: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_hidden_title,
                    description: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_hidden_description,
                    buttonText: TranslationsHelper()
                        .appLocalizations!
                        .settings_app_reset_hidden_button_text,
                    onClick: () {
                      showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                              toConfirm: TranslationsHelper()
                                  .appLocalizations!
                                  .settings_app_reset_hidden_action,
                              todoWhenConfirmed: () {
                                UserData().resetHiddenGames();
                                setState(() {});
                              }));
                    },
                    style: ButtonSettingStyle.DANGER)
              ])
            ],
          ),
        )
      ],
    );
  }
}
