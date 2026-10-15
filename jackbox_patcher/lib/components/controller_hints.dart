import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/l10n/app_localizations.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_service.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

/// Bar shown at the bottom of the app while the controller is in use, with
/// what its buttons do on the page in front
class ControllerHints extends StatefulWidget {
  const ControllerHints({super.key});

  @override
  State<ControllerHints> createState() => _ControllerHintsState();
}

class _ControllerHintsState extends State<ControllerHints> {
  /// Pages where X launches the focused game
  static const List<String> _quickLaunchPages = ["/searchMenu", "/search", "/patch"];

  @override
  void initState() {
    super.initState();
    GamepadService().routeObserver.routeChanges.addListener(_update);
    TranslationsHelper().localeChanges.addListener(_update);
  }

  @override
  void dispose() {
    GamepadService().routeObserver.routeChanges.removeListener(_update);
    TranslationsHelper().localeChanges.removeListener(_update);
    super.dispose();
  }

  void _update() {
    // The language can be changed while a page is built, so the bar is rebuilt after
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = TranslationsHelper().appLocalizations;
    if (appLocalizations == null) {
      return const SizedBox(height: 0);
    }
    String? page = GamepadService().routeObserver.currentRouteName;
    return Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 32, 32, 32),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Wrap(alignment: WrapAlignment.center, spacing: 24, runSpacing: 4, children: [
          _buildHint(["xbox_left_stick"], appLocalizations.controller_hint_move),
          _buildHint(["xbox_button_a"], appLocalizations.controller_hint_select),
          _buildHint(["xbox_button_b"], appLocalizations.controller_hint_back),
          if (_quickLaunchPages.contains(page)) _buildHint(["xbox_button_x"], appLocalizations.launch_game),
          if (page == "/game")
            _buildHint(["xbox_lb", "xbox_rb"], appLocalizations.controller_hint_switch_game, outlined: true),
          _buildHint(["xbox_right_stick"], appLocalizations.controller_hint_scroll),
          _buildHint(["xbox_lt", "xbox_rt"], appLocalizations.controller_hint_faster, outlined: true),
          _buildHint(["xbox_view"], appLocalizations.controller_hint_hide_buttons, outlined: true),
        ]));
  }

  /// [outlined] buttons are drawn in black only, they get the color of the text so they can be seen on a dark theme
  Widget _buildHint(List<String> buttons, String text, {bool outlined = false}) {
    TextStyle? style = FluentTheme.of(context).typography.body;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      for (String button in buttons)
        Padding(
            padding: const EdgeInsets.only(right: 4),
            child:
                Image.asset("assets/images/controller/$button.png", height: 22, color: outlined ? style?.color : null)),
      const SizedBox(width: 4),
      Text(text, style: style),
    ]);
  }
}
