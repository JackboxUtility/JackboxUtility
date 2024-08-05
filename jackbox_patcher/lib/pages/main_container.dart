import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:jackbox_patcher/components/custom_server_component/custom_server_component_widget_factory.dart';
import 'package:jackbox_patcher/components/dialogs/leave_application_dialog.dart';
import 'package:jackbox_patcher/pages/loading_container.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/device/device.dart';
import 'package:jackbox_patcher/services/downloader/downloader_service.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';
import 'package:jackbox_patcher/services/user/initial_load.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:jackbox_patcher/services/windowManager/windows_manager_service.dart';
import 'package:window_manager/window_manager.dart';

import '../components/notifications_caroussel.dart';
import '../services/discord/discord_service.dart';
import '../services/launcher/launcher.dart';

class CloseWindowIntent extends Intent {
  const CloseWindowIntent();
}

class MainContainer extends StatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> with WindowListener {
  bool isFirstTimeOpening = true;
  bool _loaded = false;
  int loadingStep = 0;
  double loadingPercent = 0;
  double oldLoadingPercent = 0;
  bool loadingException = false;

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    TranslationsHelper().changeLocale(Locale("en"));
    APIService().internalCache.addListener(updateCustomServerComponent);
    _load(true);
  }

  @override
  void dispose() {
    APIService().internalCache.removeListener(updateCustomServerComponent);
    super.dispose();
  }

  void updateCustomServerComponent() {
    if (mounted) {
      setState(() {});
    }
  }

  void updateLoading({int? step, double? percent}) {
    if (step != null && percent != null) {
      oldLoadingPercent = loadingPercent;
      setState(() {
        loadingStep = step;
        loadingPercent = percent;
      });
    }
  }

  void tryAgain() {
    _load(true);
  }

  void serverChange() {
    UserData().setSelectedServer(null);
    _load(false);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
        content: Stack(
      children: [
        Image.asset("assets/images/background_pattern.png",
            scale: 1.5,
            repeat: ImageRepeat.repeat,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(1, 32, 32, 32).withOpacity(0.98),
        ),
        _loaded
            ? Column(children: [
                const Spacer(),
                _buildUpper(),
                _buildLower(),
                const Spacer(),
              ])
            : LoadingContainer(
                step: (
                  percent: loadingPercent,
                  step: loadingStep,
                  oldPercent: oldLoadingPercent
                ),
                exceptionReceived: loadingException,
                onTryAgainPressed: tryAgain,
                onServerChangePressed: serverChange,
              ),
        if (FlavorConfig.instance.name == "BETA")
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    TranslationsHelper()
                        .appLocalizations!
                        .using_beta_version_text,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  )))
      ],
    ));
  }

  Widget _buildUpper() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTitle(),
      const SizedBox(
        height: 30,
      ),
      _buildMenu(),
      const SizedBox(
        height: 30,
      ),
    ]);
  }

  Widget _buildMenu() {
    return Localizations.override(
        context: context,
        locale: const Locale('en'),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
            child: Column(children: [
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.green),
                          shape: ButtonState.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)))),
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/searchMenu");
                        DiscordService().launchMenuPresence();
                      },
                      child: SizedBox(
                          width: 300,
                          height: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FluentIcons.play_solid,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                    TranslationsHelper()
                                        .appLocalizations!
                                        .launch_search_game,
                                    style: const TextStyle(color: Colors.white))
                              ])))),
              const SizedBox(height: 10),
              !DeviceService.isWeb() &&
                      (APIService()
                              .cachedConfigurations
                              ?.getConfiguration("MAIN", "HIDE_PATCHER")) !=
                          true
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.blue),
                              shape: ButtonState.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)))),
                          onPressed: () async {
                            await Navigator.pushNamed(context, "/patch");
                            DiscordService().launchMenuPresence();
                            setState(() {});
                          },
                          child: SizedBox(
                              width: 300,
                              height: 20,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (UserData().gameList.patchesAvailable() >
                                        0)
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.red),
                                      ),
                                    if (UserData().gameList.patchesAvailable() >
                                        0)
                                      SizedBox(width: 10),
                                    const Icon(FluentIcons.download,
                                        color: Colors.white),
                                    const SizedBox(width: 10),
                                    Text(
                                        TranslationsHelper()
                                            .appLocalizations!
                                            .patch_a_game,
                                        style: const TextStyle(
                                            color: Colors.white))
                                  ]))))
                  : const SizedBox(height: 0),
              const SizedBox(height: 30),
              !DeviceService.isWeb()
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.grey),
                              shape: ButtonState.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)))),
                          onPressed: () async {
                            await Navigator.pushNamed(context, "/settings",
                                arguments: UserData().packs);
                            DiscordService().launchMenuPresence();
                            if (APIService().cachedSelectedServer != null) {
                              _loaded = false;
                              setState(() {});
                              _load(false);
                            }
                          },
                          child: SizedBox(
                              width: 300,
                              height: 20,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(FluentIcons.settings,
                                        color: Colors.white),
                                    const SizedBox(width: 10),
                                    Text(
                                        TranslationsHelper()
                                            .appLocalizations!
                                            .settings,
                                        style: const TextStyle(
                                            color: Colors.white))
                                  ]))))
                  : const SizedBox(height: 0),
              if (APIService().cachedServerMessage != null &&
                  APIService().cachedServerMessage!.menuComponent != null)
                Container(
                    margin: EdgeInsets.only(top: 50),
                    child: CustomServerComponentWidgetFactory(
                        component:
                            APIService().cachedServerMessage!.menuComponent!))
            ])));
  }

  Widget _buildConnectedServer() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(TranslationsHelper()
          .appLocalizations!
          .connected_to_server(APIService().cachedSelectedServer!.name)),
      const SizedBox(width: 10),
      GestureDetector(
        child: Text(
            TranslationsHelper().appLocalizations!.connected_to_server_change,
            style: const TextStyle(decoration: TextDecoration.underline)),
        onTap: () async {
          UserData().setSelectedServer(null);
          UserData().packs = [];
          APIService().resetCache();
        },
      )
    ]);
  }

  Widget _buildTitle() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
              APIService().assetLink(APIService().cachedSelectedServer!.image),
              height: 100)),
      Text(APIService().cachedSelectedServer!.name,
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }

  Widget _buildLower() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NotificationCaroussel(
        news: APIService().cachedNews,
      ),
    );
  }

  void _load(bool automaticallyChooseBestServer) async {
    loadingException = false;
    setState(() {});
    try {
      await InitialLoad.init(context, isFirstTimeOpening,
          automaticallyChooseBestServer, updateLoading);
      isFirstTimeOpening = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _loaded = true;
        });
      });
    } catch (e) {
      loadingException = true;
      setState(() {});
    }
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      bool shouldClose = DownloaderService.isDownloading
          ? await (showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return const LeaveApplicationDialog();
                  })) ==
              true
          : true;
      await Launcher.restoreOldLaunchers();

      await WindowManagerService.saveCurrentScreenSize();
      if (shouldClose) {
        windowManager.destroy();
      }
    }
  }
}
