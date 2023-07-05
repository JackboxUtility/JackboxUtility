import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/blurhashimage.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class AssetCarousselWidget extends StatefulWidget {
  const AssetCarousselWidget({Key? key, required this.images})
      : super(key: key);

  final List<String> images;
  @override
  State<AssetCarousselWidget> createState() => _AssetCarousselWidgetState();
}

class _AssetCarousselWidgetState extends State<AssetCarousselWidget> {
  bool moveButtonVisible = false;
  bool changingImage = false;
  int imageIndex = 0;
  TweenAnimationBuilder<double>? tweenAnimationBuilder;

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    startVideo();
    controlPlayerState();
    if (!UserData().settings.isAudioActivated) 
        player.setVolume(0);
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void controlPlayerState() {
    player.stream.completed.listen((bool ended) {
      if (ended) {
        setState(() {
          imageIndex = (imageIndex + 1) % widget.images.length;
        });
        startVideo();
        Future.delayed(
            const Duration(milliseconds: 1100),
            () => setState(() {
                  changingImage = false;
                }));
      }
    });
  }

  void startVideo() {
    if (isAVideo(widget.images[imageIndex])) {
      player.open(Media(APIService().assetLink(widget.images[imageIndex])));
      
      setState(() {
        changingImage = true;
      });
    } else {
      player.stop();
    }
  }

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
                          !isAVideo(widget.images[imageIndex])
                              ? BlurHashImage(
                                  url: widget.images[imageIndex],
                                  fit: BoxFit.fitWidth,
                                )
                              : Video(controller: controller),
                          tweenAnimationBuilder = TweenAnimationBuilder<double>(
                              onEnd: () {
                                if (!moveButtonVisible &&
                                    changingImage == false) {
                                  setState(() {
                                    imageIndex =
                                        (imageIndex + 1) % widget.images.length;
                                    changingImage = true;
                                  });
                                  startVideo();
                                  Future.delayed(
                                      const Duration(milliseconds: 1100),
                                      () => setState(() {
                                            changingImage = false;
                                          }));
                                }
                              },
                              tween: Tween<double>(
                                begin:
                                    moveButtonVisible || changingImage ? 1 : 0,
                                end: moveButtonVisible || changingImage ? 0 : 1,
                              ),
                              curve: Curves.easeOut,
                              duration: moveButtonVisible || changingImage
                                  ? const Duration(milliseconds: 1000)
                                  : const Duration(seconds: 6),
                              builder: (BuildContext context, double widthTween,
                                  Widget? child) {
                                return FractionallySizedBox(
                                    alignment: Alignment.bottomCenter,
                                    widthFactor: changingImage ? 1 : widthTween,
                                    heightFactor: 1,
                                    child: Column(
                                      children: [
                                        Spacer(),
                                        Container(
                                            height: 3,
                                            color: Colors.blue.withOpacity(
                                                changingImage
                                                    ? widthTween / 2
                                                    : 0.5)),
                                      ],
                                    ));
                              }),
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
                                              startVideo();
                                            }),
                                        child: const Icon(
                                            FluentIcons.chevron_left_small)),
                                    const Expanded(child: SizedBox()),
                                    GestureDetector(
                                        onTap: () => setState(() {
                                              imageIndex = (imageIndex + 1) %
                                                  (widget.images.length);
                                              startVideo();
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

  bool isAVideo(String url) => url.contains(".mp4");
}
