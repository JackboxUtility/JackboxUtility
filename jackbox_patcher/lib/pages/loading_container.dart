import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/components/title.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingContainer extends StatefulWidget {
  LoadingContainer(
      {Key? key,
      required this.step,
      required this.exceptionReceived,
      required this.exceptionMessage,
      required this.onTryAgainPressed,
      required this.onServerChangePressed})
      : super(key: key);

  final ({int step, double percent, double oldPercent}) step;
  final bool exceptionReceived;
  final String exceptionMessage;
  final Function() onTryAgainPressed;
  final Function() onServerChangePressed;
  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Spacer(),
            buildUpper(),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget buildUpper() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      JackboxUtilityTitleWithIcon(),
      const SizedBox(
        height: 30,
      ),
      // !widget.exceptionReceived
      //     ? LottieBuilder.asset("assets/lotties/QuiplashOutput.json",
      //         width: 200, height: 200)
      //     : Container(),
      // const SizedBox(
      //   height: 30,
      // ),
      buildTimeline(),
      const SizedBox(
        height: 30,
      ),
      widget.exceptionReceived ? buildError() : Container()
    ]);
  }

  Widget buildTimeline() {
    return SizedBox(
      width: 500,
      height: 39,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimelineStep(icon: FluentIcons.play_solid, step: 1),
          buildTimelineLine(step: 1),
          buildTimelineStep(icon: FluentIcons.network_tower, step: 2),
          buildTimelineLine(step: 2),
          buildTimelineStep(icon: FluentIcons.download, step: 3),
        ],
      ),
    );
  }

  Widget buildTimelineStep({IconData? icon, int? step}) {
    return SizedBox(
      width: 39,
      child: Stack(children: [
        TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 200),
            tween: Tween<double>(
              begin: widget.step.step < step! ? 0.0 : (widget.step.step > step ? 100 : widget.step.oldPercent),
              end: widget.step.step < step ? 0.0 : (widget.step.step > step ? 100 : widget.step.percent),
            ),
            builder: (context, double progress, w) {
              return widget.exceptionReceived && widget.step.step == step
                  ? ProgressRing(
                      strokeWidth: 3,
                      value: 100,
                      activeColor: Colors.red,
                    )
                  : ProgressRing(
                      strokeWidth: 3,
                      value: progress,
                      activeColor: Colors.white,
                    );
            }),
        Padding(
            padding: EdgeInsets.only(left: 9, top: 9),
            child: Icon(
              icon,
              color: Colors.white,
            ))
      ]),
    );
  }

  Widget buildTimelineLine({int? step}) {
    return Stack(children: [
      Container(
        width: 100,
        height: 3,
        color: Colors.grey,
      ),
      TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 150),
          tween: Tween<double>(
            begin: 0.0,
            end: widget.step.step > step! ? 100 : 0,
          ),
          builder: (context, double size, w) {
            return Container(
              width: size,
              height: 3,
              color: Colors.white,
            );
          })
    ]);
  }

  Widget buildError() {
    return Column(
      children: [
        buildErrorMessage(),
        const SizedBox(
          height: 20,
        ),
        FilledButton(
            child: Text("Try again", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              widget.onTryAgainPressed();
            }),
        const SizedBox(
          height: 10,
        ),
        widget.step.step == 2
            ? FilledButton(
                child: Text("Change server"),
                onPressed: () {
                  widget.onServerChangePressed();
                })
            : Container(),
        widget.step.step == 3 || widget.step.step == 1
            ? Row(
                children: [
                  FilledButton(
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.discord),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Discord"),
                        ],
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse(APP_LINKS["DISCORD"]!));
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  FilledButton(
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.github),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("GitHub"),
                        ],
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse(APP_LINKS["GITHUB"]!));
                      }),
                ],
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        widget.exceptionMessage != "" ? _buildExceptionMessage() : Container()
      ],
    );
  }

  Widget buildErrorMessage() {
    String mainMessage = "";
    String subMessage = "";

    switch (widget.step.step) {
      case 1:
        mainMessage = TranslationsHelper().appLocalizations!.loading_initialization_failed;
        subMessage = TranslationsHelper().appLocalizations!.loading_open_issue_discord;
        break;
      case 2:
        mainMessage = TranslationsHelper().appLocalizations!.loading_connection_failed;
        subMessage = TranslationsHelper().appLocalizations!.loading_check_internet_connection;
        break;
      case 3:
        mainMessage = TranslationsHelper().appLocalizations!.loading_save_failed;
        subMessage = TranslationsHelper().appLocalizations!.loading_open_issue_discord;
        break;
    }

    return Column(
      children: [
        Text(
          mainMessage,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          subMessage,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildExceptionMessage() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red, width: 1)),
        height: 100,
        child: SingleChildScrollView(
            child: SelectableText(widget.exceptionMessage, style: TextStyle(fontSize: 16, color: Colors.red.normal))));
  }
}
