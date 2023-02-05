import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';

import '../services/api/api_service.dart';

class AssetCarousselWidget extends StatefulWidget {
  AssetCarousselWidget({Key? key, required this.images}) : super(key: key);

  final List<String> images;
  @override
  State<AssetCarousselWidget> createState() => _AssetCarousselWidgetState();
}

class _AssetCarousselWidgetState extends State<AssetCarousselWidget> {
  bool moveButtonVisible = false;
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicWidth(
            child: IntrinsicHeight(
                child: GestureDetector(
                    child: MouseRegion(
                        onEnter: (a) => setState(() {
                              moveButtonVisible = true;
                            }),
                        onExit: (a) => setState(() {
                              moveButtonVisible = false;
                            }),
                        child: Stack(children: [
                          CachedNetworkImage(
                            imageUrl: APIService()
                                .assetLink(widget.images[imageIndex]),
                            fit: BoxFit.fitWidth,
                          ),
                          moveButtonVisible
                              ? Center(
                                  child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () =>  setState(() {
                                              imageIndex = (imageIndex - 1) %
                                                  (widget.images.length);
                                            }),
                                        child: Icon(
                                            FluentIcons.chevron_left_small)),
                                    Expanded(child: SizedBox()),
                                    GestureDetector(
                                        onTap: () => setState(() {
                                              imageIndex = (imageIndex + 1) %
                                                  (widget.images.length);
                                            }),
                                        child: Icon(
                                            FluentIcons.chevron_right_small)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ))
                              : Container()
                        ]))))));
  }
}
