import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/blurhashimage.dart';


class AssetCarousselWidget extends StatefulWidget {
  const AssetCarousselWidget({Key? key, required this.images}) : super(key: key);

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
        child: SizedBox(
            width: double.maxFinite,
            child: AspectRatio(
                aspectRatio: 1.778,
                child: GestureDetector(
                    child: MouseRegion(
                        onEnter: (a) => setState(() {
                              moveButtonVisible = true;
                            }),
                        onExit: (a) => setState(() {
                              moveButtonVisible = false;
                            }),
                        child: Stack(children: [
                          BlurHashImage(
                            url: widget.images[imageIndex],
                            fit: BoxFit.fitWidth,
                          ),
                          moveButtonVisible
                              ? Center(
                                  child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () => setState(() {
                                              imageIndex = (imageIndex - 1) %
                                                  (widget.images.length);
                                            }),
                                        child: const Icon(
                                            FluentIcons.chevron_left_small)),
                                    const Expanded(child: SizedBox()),
                                    GestureDetector(
                                        onTap: () => setState(() {
                                              imageIndex = (imageIndex + 1) %
                                                  (widget.images.length);
                                            }),
                                        child: const Icon(
                                            FluentIcons.chevron_right_small)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ))
                              : Container()
                        ]))))));
  }
}
