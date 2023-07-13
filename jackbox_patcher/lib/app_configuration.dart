// This is the AppConfiguration
// If you want to tweak the app, you are in the good place !

const String MAIN_SERVER_BASE_URL =
    "https://raw.githubusercontent.com/AlexisL61/JackboxUtility";
const String MAIN_SERVER_FILE = "servers.json";
const Map<String, String> MAIN_SERVER_URL = {
  "RELEASE_SERVER_URL": "$MAIN_SERVER_BASE_URL/master/$MAIN_SERVER_FILE",
  "BETA_SERVER_URL": "$MAIN_SERVER_BASE_URL/dev/$MAIN_SERVER_FILE"
};

const Map<String, String> APP_LINKS = {
  "GITHUB": "https://github.com/AlexisL61/JackboxUtility",
  "DISCORD": "https://discord.gg/cYdJkZwCk3"
};

const List<String> APP_LANGUAGES = ["en", "fr", "de", "es", "uk", "be", "ru"];
const String DEFAULT_APP_LANGUAGE = "en";

const String LOGS_OUTPUT = "./logs.txt";
