import 'package:fluent_ui/fluent_ui.dart';

class MediaKitRemoverDialog extends StatelessWidget {
  const MediaKitRemoverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/gene.png', width: 100),
          SizedBox(height: 20),
          Text('JackboxUtility needs to do some changes to its files to work properly. The changes will be done automatically and the app will restart.'),
          SizedBox(height: 10),
          Text('It should take less than 10 seconds.'),
        ],
      ),
      actions: [
        HyperlinkButton(
          child: Text('Restart'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}