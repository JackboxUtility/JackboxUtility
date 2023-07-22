import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

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
        title: Text("Custom server"),
        content: SizedBox(
            height: 120,
            child: Column(children: [
              Text(
                  "Paste a direct link to the info.json file of the server you want to add"),
              SizedBox(height: 20),
              TextBox(
                controller: input,
              ),
            ])),
        actions: [
          Button(
              child: Text("Cancel"),
              onPressed: !isLoading
                  ? () {
                      Navigator.pop(context);
                    }
                  : null),
          Button(
            child: Text("Add"),
            onPressed: !isLoading
                ? () async {
                    setState(() {
                      isLoading = true;
                    });
                    PatchServer? recoveredServer =
                        await APIService().recoverServerFromLink(input.text);
                    if (recoveredServer == null) {
                      InfoBarService.showError(
                          context, "Failed to recover server from link");
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
        title: Text("Custom server"),
        content: SizedBox(
            height: 300,
            child: Column(children: [
              InfoBar(title: Text("If someone asked you to add a link there, it's likely a scam. Do not continue If you don't trust the owner of this server."), severity:InfoBarSeverity.warning ),
              SizedBox(height: 20),
              Text(
                  "Do you want to add this server to your list ?"),
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
              child: Text("Cancel"),
              onPressed: !isLoading
                  ? () {
                Navigator.pop(context);
              }
                  : null),
          Button(
            child: Text("Add"),
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
