import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

import '../../model/custom_server_component/countdown_server_component.dart';

class CountdownServerComponentWidget extends StatefulWidget {
  CountdownServerComponentWidget({Key? key, required this.component})
      : super(key: key);

  final CountdownServerComponent component;

  @override
  State<CountdownServerComponentWidget> createState() =>
      _CountdownServerComponentWidgetState();
}

class _CountdownServerComponentWidgetState
    extends State<CountdownServerComponentWidget> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(buildCountdown(), style: FluentTheme.of(context).typography.bodyLarge!),
    );
  }

  String buildCountdown() {
    Duration duration = DateTime.parse(widget.component.endTime).difference(DateTime.now());
    if (duration.isNegative) {
      return widget.component.endText;
    }
    // Build countdown into DD : HH : MM : SS

    var seconds = duration.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}');
    }
    tokens.add('${seconds}');

    tokens.forEach((element) {
      if (element.length == 1) {
        tokens[tokens.indexOf(element)] = '0${element}';
      }
    });
    return tokens.join(' : ');
  }
}
