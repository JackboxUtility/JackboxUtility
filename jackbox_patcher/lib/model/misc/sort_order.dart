import 'package:jackbox_patcher/services/translations/translations_helper.dart';

enum SortOrder {
  PACK,
  NAME,
  STARS, 
  PLAYERS_NUMBER;
}

extension SortOrderExtension on SortOrder {
  String get name {
    switch (this) {
      case SortOrder.PACK:
        return TranslationsHelper().appLocalizations!.pack;
      case SortOrder.NAME:
        return TranslationsHelper().appLocalizations!.name;
      case SortOrder.STARS:
        return TranslationsHelper().appLocalizations!.stars;
      case SortOrder.PLAYERS_NUMBER:
        return TranslationsHelper().appLocalizations!.players_number;
      default:
        return 'Unknown';
    }
  }
}