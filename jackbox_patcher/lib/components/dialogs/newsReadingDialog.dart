import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/news.dart';
import '../../services/api/api_service.dart';

class NewsReadingDialog extends StatefulWidget {
  NewsReadingDialog({Key? key, required this.news}) : super(key: key);

  final News news;

  @override
  State<NewsReadingDialog> createState() => _NewsReadingDialogState();
}

class _NewsReadingDialogState extends State<NewsReadingDialog> {
  @override
  Widget build(BuildContext context) {
    return  ContentDialog(
                          title: Text(widget.news.title),
                          content: Markdown(
                              data: widget.news.content,
                              onTapLink: (text, href, title) =>
                                  launchUrl(Uri.parse(href!))),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child:
                                    Text(AppLocalizations.of(context)!.close))
                          ]);
  }

  
}
