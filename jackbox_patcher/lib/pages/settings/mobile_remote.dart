import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/services/mobile_remote/mobile_remote_server.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

import '../../services/error/error.dart';
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
  bool _adminLockEnabled = false;
  String _adminPattern = '';
  List<int> _editingPatternIndexes = [];
  final TextEditingController _patternController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resolveIp();
    _loadAdminLockSettings();
  }

  @override
  void dispose() {
    _patternController.dispose();
    super.dispose();
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

  Future<void> _loadAdminLockSettings() async {
    _adminLockEnabled = UserData().settings.isPhoneAdminPatternEnabled;
    _adminPattern = UserData().settings.phoneAdminPattern;
    if (_adminPattern.isEmpty) {
      _adminPattern = await UserData().settings.regeneratePhoneAdminPattern();
    }
    _editingPatternIndexes = _patternIndexes(_adminPattern).take(4).toList();
    _patternController.text = _toHumanPattern(_adminPattern);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _setAdminLockEnabled(bool enabled) async {
    await UserData().settings.setPhoneAdminPatternEnabled(enabled);
    await MobileRemoteServer().restart();
    if (mounted) {
      setState(() {
        _adminLockEnabled = enabled;
      });
    }
  }

  Future<void> _regenerateAdminPattern() async {
    final pattern = await UserData().settings.regeneratePhoneAdminPattern();
    await MobileRemoteServer().restart();
    if (mounted) {
      setState(() {
        _adminPattern = pattern;
        _editingPatternIndexes = _patternIndexes(pattern).take(4).toList();
        _patternController.text = _toHumanPattern(_adminPattern);
      });
    }
  }

  String _toHumanPattern(String raw) {
    if (raw.isEmpty) return '';
    return raw
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .where((v) => v >= 0 && v < 25)
        .map((v) => (v + 1).toString())
        .join(',');
  }

  String? _toStoredPattern(String humanInput) {
    final parsed = humanInput
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
    if (parsed.length != 4) return null;
    final unique = parsed.toSet();
    if (unique.length != 4) return null;
    if (parsed.any((v) => v < 1 || v > 25)) return null;
    return parsed.map((v) => (v - 1).toString()).join(',');
  }

  Future<void> _saveCustomPattern() async {
    final stored = _toStoredPattern(_patternController.text);
    if (stored == null) {
      if (mounted) {
        InfoBarService.showError(
          context,
          'Invalid pattern. Enter exactly 4 unique numbers between 1 and 25, comma-separated.',
        );
      }
      return;
    }
    await UserData().settings.setPhoneAdminPattern(stored);
    await MobileRemoteServer().restart();
    if (mounted) {
      setState(() {
        _adminPattern = stored;
        _editingPatternIndexes = _patternIndexes(stored).take(4).toList();
        _patternController.text = _toHumanPattern(stored);
      });
      InfoBarService.showInfo(context, 'Pattern saved', 'Custom admin pattern updated.');
    }
  }

  Future<void> _clearPattern() async {
    await UserData().settings.setPhoneAdminPattern('');
    await UserData().settings.setPhoneAdminPatternEnabled(false);
    await MobileRemoteServer().restart();
    if (mounted) {
      setState(() {
        _adminPattern = '';
        _editingPatternIndexes = [];
        _adminLockEnabled = false;
        _patternController.clear();
      });
      InfoBarService.showInfo(context, 'Pattern cleared', 'Admin lock requirement has been disabled.');
    }
  }

  List<int> _patternIndexes(String pattern) {
    if (pattern.isEmpty) return const [];
    return pattern
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .where((v) => v >= 0 && v < 25)
        .toList();
  }

  void _toggleEditingPatternIndex(int index) {
    if (_editingPatternIndexes.contains(index)) {
      setState(() {
        _editingPatternIndexes.remove(index);
        _patternController.text =
            _editingPatternIndexes.map((v) => (v + 1).toString()).join(',');
      });
      return;
    }

    if (_editingPatternIndexes.length >= 4) {
      InfoBarService.showError(context, 'Only 4 cells can be selected. Deselect one first.');
      return;
    }

    setState(() {
      _editingPatternIndexes.add(index);
      _patternController.text =
          _editingPatternIndexes.map((v) => (v + 1).toString()).join(',');
    });
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
                    message: 'Copy Link',
                    child: IconButton(
                      icon: const Icon(FluentIcons.copy),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: 'http://$_lanIp:$MOBILE_REMOTE_PORT'),
                        );
                        if (mounted) {
                          InfoBarService.showInfo(context, 'Copied', 'Remote link copied to clipboard.');
                        }
                      },
                    ),
                  ),
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
          const SizedBox(height: 32),
          Text('Admin Lock Pattern (Insecure, 5x5)', style: typography.bodyStrong),
          const SizedBox(height: 8),
          const Text(
            'This is intentionally insecure and only meant to stop casual access. The pattern is sent to the phone client.',
          ),
          const SizedBox(height: 8),
          const Text('Set your own pattern using 4 unique numbers from 1 to 25 (left-to-right, top-to-bottom).'),
          const SizedBox(height: 10),
          ToggleSwitch(
            checked: _adminLockEnabled,
            content: const Text('Require admin pattern on phone remote'),
            onChanged: (enabled) async {
              await _setAdminLockEnabled(enabled);
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton(
                onPressed: () async {
                  await _regenerateAdminPattern();
                },
                child: const Text('Regenerate Pattern'),
              ),
              const SizedBox(width: 8),
              Button(
                onPressed: () async {
                  await _clearPattern();
                },
                child: const Text('Clear'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _editingPatternIndexes.isEmpty
                      ? 'No pattern generated yet.'
                      : 'Tap order: ${_editingPatternIndexes.map((i) => (i + 1).toString()).join(' -> ')}',
                  style: typography.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextBox(
                  controller: _patternController,
                  placeholder: 'Example: 1,7,13,25',
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  await _saveCustomPattern();
                },
                child: const Text('Save Pattern'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Tap cells below to build your pattern. Press Save Pattern to apply it.',
            style: typography.caption,
          ),
          const SizedBox(height: 8),
          _PatternEditorGrid(
            indexes: _editingPatternIndexes,
            onTap: _toggleEditingPatternIndex,
          ),
        ],
      ),
    );
  }
}

class _PatternEditorGrid extends StatelessWidget {
  final List<int> indexes;
  final void Function(int index) onTap;

  const _PatternEditorGrid({required this.indexes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final orderByIndex = <int, int>{};
    for (int i = 0; i < indexes.length; i++) {
      orderByIndex[indexes[i]] = i + 1;
    }

    return SizedBox(
      width: 360,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 25,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final order = orderByIndex[index];
            final on = order != null;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: on ? Colors.blue : Colors.grey),
                  color: on ? Colors.blue.withOpacity(0.25) : Colors.transparent,
                ),
                child: Text(
                  on ? '$order' : '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: on ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final FaIconData icon;
  final String label;

  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          FaIcon(icon, size: 14),
          const SizedBox(width: 8),
          Text(label, style: FluentTheme.of(context).typography.body),
        ],
      ),
    );
  }
}
