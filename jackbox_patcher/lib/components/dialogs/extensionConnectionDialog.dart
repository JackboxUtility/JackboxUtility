import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/services/internal_api/Extension.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';

class ExtensionConnectionDialog extends StatefulWidget {
  ExtensionConnectionDialog(
      {Key? key, required this.extension, required this.scopes})
      : super(key: key);

  final Extension extension;
  final List<RestApiScopes> scopes;

  @override
  State<ExtensionConnectionDialog> createState() =>
      _ExtensionConnectionDialogState();
}

class _ExtensionConnectionDialogState extends State<ExtensionConnectionDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Extension connection"),
      content: SizedBox(
        width: 400,
        height: 200,
        child: ListView(
          children: [
            Text(widget.extension.name,
                style: FluentTheme.of(context).typography.subtitle),
            Text(
              "wants to connect to Jackbox Utility with these permissions :",
              style: FluentTheme.of(context).typography.body,
            ),
            SizedBox(height: 20),
            for (var scope in widget.scopes)
              Row(
                children: [
                  Icon(FluentIcons.checkbox_composite, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scope.name,
                          style: FluentTheme.of(context).typography.subtitle),
                      Text(scope.description,
                          style: FluentTheme.of(context)
                              .typography
                              .body!
                              .copyWith(color: Colors.grey[50]))
                    ],
                  ))
                ],
              )
          ],
        ),
      ),
      actions: [
        Button(
          child: Text("Refuse"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        Button(
          child: Text("Accept"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
