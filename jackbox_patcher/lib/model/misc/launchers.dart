enum LauncherType {
  STEAM,
  EPIC,
  UNKNOWN;

  static LauncherType fromName(String name){
    switch(name){
      case "steam":
        return LauncherType.STEAM;
      case "epic":
        return LauncherType.EPIC;
      default:
        return LauncherType.UNKNOWN;
    }
  }

  String toName(){
    switch(this){
      case LauncherType.STEAM:
        return "steam";
      case LauncherType.EPIC:
        return "epic";
      default:
        return "unknown";
    }
  }
}
