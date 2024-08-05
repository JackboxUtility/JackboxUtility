import 'package:fluent_ui/fluent_ui.dart';

class MediaKitRemoverDialog extends StatelessWidget {
  const MediaKitRemoverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: SizedBox(
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/gene.png', width: 100),
            const SizedBox(height: 20),
            const Text(
              'JackboxUtility needs to do some changes to its files to work properly. The changes will be done automatically and the app will restart.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text('It should take less than 10 seconds.'),
          ],
        ),
      ),
      actions: [
        HyperlinkButton(
          child: const Text('Restart'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
