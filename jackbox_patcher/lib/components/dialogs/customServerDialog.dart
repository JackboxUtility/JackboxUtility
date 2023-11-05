import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../../services/error/error.dart';
import '../../services/user/userdata.dart';

class CustomServerDialog extends StatefulWidget {
  CustomServerDialog({Key? key}) : super(key: key);

  @override
  State<CustomServerDialog> createState() => _CustomServerDialogState();
}

class _CustomServerDialogState extends State<CustomServerDialog> {
  int progression = 0;
  String serverLink = "";
  bool isLoading = false;
  TextEditingController input = TextEditingController();
  PatchServer? selectedServer;

  @override
  Widget build(BuildContext context) {
    switch (progression) {
      case 0:
        return buildInputContentDialog();
      case 1:
        return buildConfirmContentDialog();
    }
    return Container();
  }

  Widget buildInputContentDialog() {
    return ContentDialog(
        title: Text(TranslationsHelper().appLocalizations!.custom_server_title),
        content: SizedBox(
            height: 120,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  TranslationsHelper()
                      .appLocalizations!
                      .custom_server_explanation),
              SizedBox(height: 20),
              TextBox(
                placeholder: TranslationsHelper()
                    .appLocalizations!
                    .custom_server_link,
                controller: input,
              ),
            ])),
        actions: [
          Button(
              child: Text(TranslationsHelper().appLocalizations!.cancel),
              onPressed: !isLoading
                  ? () {
                      Navigator.pop(context);
                    }
                  : null),
          Button(
            child: Text(TranslationsHelper().appLocalizations!.confirm),
            onPressed: !isLoading
                ? () async {
                    setState(() {
                      isLoading = true;
                    });
                    PatchServer? recoveredServer =
                        await APIService().recoverServerFromLink(input.text);
                    if (recoveredServer == null) {
                      InfoBarService.showError(
                          context, TranslationsHelper().appLocalizations!.custom_server_error);
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    } else {
                      setState(() {
                        isLoading = false;
                        selectedServer = recoveredServer;
                        progression = 1;
                      });
                    }
                  }
                : null,
          ),
        ]);
  }

  Widget buildConfirmContentDialog(){
    return ContentDialog(
        title: Text(TranslationsHelper().appLocalizations!.custom_server_title),
        content: SizedBox(
            height: 300,
            child: Column(children: [
              InfoBar(title: Text(TranslationsHelper().appLocalizations!.custom_server_warning), severity:InfoBarSeverity.warning ),
              SizedBox(height: 20),
              Text(
                  TranslationsHelper()
                      .appLocalizations!
                      .custom_server_add_question),
              SizedBox(height: 20),SizedBox(
        height: 75,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IntrinsicWidth(
                      child: CachedNetworkImage(
                    imageUrl: selectedServer!.image,
                    fit: BoxFit.contain,
                  )))
            ]))),
              Text(selectedServer!.name, style: FluentTheme.of(context).typography.title),
            ])),
        actions: [
          Button(
              child: Text(TranslationsHelper().appLocalizations!.cancel),
              onPressed: !isLoading
                  ? () {
                Navigator.pop(context);
              }
                  : null),
          Button(
            child: Text(TranslationsHelper().appLocalizations!.confirm),
            onPressed: !isLoading
                ? () async {
              setState(() {
                isLoading = true;
              });
              UserData().setSelectedServer(selectedServer!.infoUrl);
              Navigator.pop(context);
              Navigator.pop(context);
            }
                : null,
          ),
        ]);
  }
}
