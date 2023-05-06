class PatchServerConfigurations {
  Map<String, dynamic> configurations;

  PatchServerConfigurations({required this.configurations});

  factory PatchServerConfigurations.fromJson(Map<String, dynamic> json) {
    print(json);
    return PatchServerConfigurations(
        configurations: json != null
            ? (json as Map<String, dynamic>)
            : {});
  }

  dynamic getConfiguration(String type, String key) {
    if (configurations[type] != null) {
      return configurations[type][key];
    }
  }
}
