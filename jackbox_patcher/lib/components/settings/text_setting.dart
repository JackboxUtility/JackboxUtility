import 'package:fluent_ui/fluent_ui.dart';

class TextSetting extends StatefulWidget {
  TextSetting({
    Key? key,
    required this.title,
    required this.description,
    required this.value,
    required this.setter,
    required this.parentReload,
    this.placeholder = "",
  }) : super(key: key);

  final String title;
  final String description;
  final String? value;
  final Future<void> Function(String?) setter;
  final Function() parentReload;
  final String placeholder;

  @override
  State<TextSetting> createState() => _TextSettingState();
}

class _TextSettingState extends State<TextSetting> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveValue() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    String value = _controller.text.trim();
    await widget.setter(value.isEmpty ? null : value);
    widget.parentReload();

    setState(() {
      _isEditing = false;
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: FluentTheme.of(context).typography.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: FluentTheme.of(context).typography.body,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextBox(
                  controller: _controller,
                  placeholder: widget.placeholder,
                  onChanged: (value) {
                    if (!_isEditing) {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  onSubmitted: (_) => _saveValue(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: (_isEditing && !_isSaving) ? _saveValue : null,
                child: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: ProgressRing(),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
