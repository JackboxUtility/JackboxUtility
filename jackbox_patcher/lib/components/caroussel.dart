import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/blurhash_image.dart';
import 'package:jackbox_patcher/services/video/video_service.dart';

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
  bool hasVideo = false;
  bool isVideoFullScreen = false;
  bool isVideoLoaded = false;
  TweenAnimationBuilder<double>? tweenAnimationBuilder;

  StreamSubscription<bool>? completedStream;
  StreamSubscription<bool>? bufferingStream;
  StreamSubscription<Duration>? positionStream;

  @override
  void initState() {
    super.initState();
    checkingIfHasVideo();

    startVideo().then((a) => controlPlayerState());
  }

  @override
  void dispose() {
    completedStream?.cancel();
    positionStream?.cancel();
    bufferingStream?.cancel();
    super.dispose();
  }

  void checkingIfHasVideo() {
    for (var i = 0; i < widget.images.length; i++) {
      if (isAVideo(widget.images[i])) {
        if (Platform.isLinux || Platform.isMacOS) {
          hasVideo = false;
          widget.images.removeAt(i);
          i--;
        } else {
          hasVideo = true;
          break;
        }
      }
    }
  }

  void controlPlayerState() {
  }

  Future<void> startVideo() async {
    
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
                              BlurHashImage(
                                      url: widget.images[imageIndex],
                                      fit: BoxFit.fitWidth,
                                    ),
                              tweenAnimationBuilder = TweenAnimationBuilder<
                                      double>(
                                  onEnd: () {
                                    if (!moveButtonVisible &&
                                        changingImage == false) {
                                      setState(() {
                                        imageIndex = (imageIndex + 1) %
                                            widget.images.length;
                                        changingImage = true;
                                      });
                                      startVideo();
                                      if (!isAVideo(
                                          widget.images[imageIndex])) {
                                        Future.delayed(
                                            const Duration(milliseconds: 1100),
                                            () => setState(() {
                                                  changingImage = false;
                                                }));
                                      }
                                    }
                                  },
                                  tween: Tween<double>(
                                    begin: moveButtonVisible || changingImage
                                        ? 1
                                        : 0,
                                    end: moveButtonVisible || changingImage
                                        ? 0
                                        : 1,
                                  ),
                                  curve: Curves.easeOut,
                                  duration: moveButtonVisible || changingImage
                                      ? const Duration(milliseconds: 1000)
                                      : const Duration(seconds: 6),
                                  builder: (BuildContext context,
                                      double widthTween, Widget? child) {
                                    return FractionallySizedBox(
                                        alignment: Alignment.bottomCenter,
                                        widthFactor:
                                            changingImage ? 1 : widthTween,
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
                                                  imageIndex = (imageIndex -
                                                          1) %
                                                      (widget.images.length);
                                                  changingImage = false;
                                                  startVideo();
                                                }),
                                            child: const Icon(FluentIcons
                                                .chevron_left_small)),
                                        Expanded(
                                            child: Column(
                                                  children: [
                                                    Expanded(
                                                      child:  GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  if (isAVideo(widget
                                                      .images[imageIndex])) {
                                                    VideoService.playPause();
                                                  }
                                                }, 
                                                child:Container(
                                                          width: double.maxFinite,
                                                          height: double.maxFinite ),
                                                    )),
                                                    SizedBox(height: 80,)
                                                  ],
                                                )),
                                        GestureDetector(
                                            onTap: () => setState(() {
                                                  imageIndex = (imageIndex +
                                                          1) %
                                                      (widget.images.length);
                                                  changingImage = false;
                                                  startVideo();
                                                }),
                                            child: const Icon(FluentIcons
                                                .chevron_right_small)),
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
