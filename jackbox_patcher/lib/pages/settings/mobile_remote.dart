import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/services/mobile_remote/mobile_remote_server.dart';

import '../../services/translations/translations_helper.dart';

class MobileRemoteSettingsWidget extends StatefulWidget {
  const MobileRemoteSettingsWidget({Key? key}) : super(key: key);

  @override
  State<MobileRemoteSettingsWidget> createState() =>
      _MobileRemoteSettingsWidgetState();
}

class _MobileRemoteSettingsWidgetState
    extends State<MobileRemoteSettingsWidget> {
  String? _lanIp;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _resolveIp();
  }

  Future<void> _resolveIp() async {
    final ip = await MobileRemoteServer.getLanIpAddress();
    if (mounted) {
      setState(() {
        _lanIp = ip;
        _loading = false;
      });
    }
  }

  double _calculatePadding(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 24, horizontal: _calculatePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phone Remote Control', style: typography.title),
          const SizedBox(height: 8),
          Text(
            'Open this address in your phone\'s browser while on the same Wi-Fi network to browse and launch games remotely.',
            style: typography.body,
          ),
          const SizedBox(height: 32),
          if (_loading)
            const ProgressRing()
          else if (_lanIp == null)
            InfoBar(
              title: const Text('No LAN IP found'),
              content: const Text(
                  'Make sure your device is connected to a Wi-Fi or Ethernet network.'),
              severity: InfoBarSeverity.warning,
            )
          else ...[
            Card(
              child: Row(
                children: [
                  const Icon(FluentIcons.cell_phone),
                  const SizedBox(width: 12),
                  SelectableText(
                    'http://$_lanIp:$MOBILE_REMOTE_PORT',
                    style: typography.subtitle,
                  ),
                  const Spacer(),
                  Tooltip(
                    message: 'Refresh IP',
                    child: IconButton(
                      icon: const Icon(FluentIcons.refresh),
                      onPressed: () {
                        setState(() {
                          _loading = true;
                          _lanIp = null;
                        });
                        _resolveIp();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InfoBar(
              title: const Text('Tip'),
              content: Text(
                  'The server listens on port $MOBILE_REMOTE_PORT. Make sure your firewall allows connections on this port if the phone cannot connect.'),
              severity: InfoBarSeverity.info,
            ),
          ],
          const SizedBox(height: 32),
          Text('Features', style: typography.bodyStrong),
          const SizedBox(height: 8),
          const _FeatureTile(
              icon: FontAwesomeIcons.magnifyingGlass, label: 'Browse & search all games'),
          const _FeatureTile(
              icon: FontAwesomeIcons.filter, label: 'Filters sync in real-time with the desktop'),
          const _FeatureTile(
              icon: FontAwesomeIcons.rocket, label: 'Launch games directly from your phone'),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 8),
          Text(label, style: FluentTheme.of(context).typography.body),
        ],
      ),
    );
  }
}
