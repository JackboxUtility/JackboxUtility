import 'package:fluent_ui/fluent_ui.dart';

enum ButtonSettingStyle { INFORMATION, WARNING, DANGER }

class ButtonSetting extends StatefulWidget {
  ButtonSetting(
      {Key? key,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.onClick,
      required this.style})
      : super(key: key);

  final String title;
  final String description;
  final String buttonText;
  final Function() onClick;
  final ButtonSettingStyle style;

  @override
  State<ButtonSetting> createState() => _ButtonSettingState();
}

class _ButtonSettingState extends State<ButtonSetting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: FluentTheme.of(context).typography.bodyLarge),
            Text(widget.description,
                style: FluentTheme.of(context).typography.body),
          ],
        ),
        const Spacer(),
        FilledButton(
            style: ButtonStyle(
              backgroundColor: ButtonState.all(
                  widget.style == ButtonSettingStyle.DANGER
                      ? Color.fromRGBO(44, 44, 44, 1)
                      : Colors.green),
            ),
            child: Text(widget.buttonText,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () => {widget.onClick()}),
      ],
    );
  }
}
