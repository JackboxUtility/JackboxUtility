import 'package:fluent_ui/fluent_ui.dart';

import '../../model/misc/tip.dart';

class TipDialog extends StatefulWidget {
  TipDialog({Key? key, required this.tip}) : super(key: key);

  final Tip tip;
  @override
  State<TipDialog> createState() => _TipDialogState();
}

class _TipDialogState extends State<TipDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
        title: Text(widget.tip.title),
        content: Text(widget.tip.description),
        actions: [
          for (TipAnswer answer in widget.tip.answers)
            HyperlinkButton(
              onPressed: () {
                widget.tip.onTipAnswer(answer);
                Navigator.pop(context);
              },
              child: Text(answer.name),
            )
        ]);
  }
}
