class JackboxGameMinMaxInfo {
  final int min;
  final int max;

  JackboxGameMinMaxInfo({
    required this.min,
    required this.max,
  });

  factory JackboxGameMinMaxInfo.fromJson(Map<String, dynamic> json) {
    return JackboxGameMinMaxInfo(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "min": min,
      "max": max,
    };
  }
}
