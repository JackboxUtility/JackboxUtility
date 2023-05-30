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
        return 'Pack';
      case SortOrder.NAME:
        return 'Name';
      case SortOrder.STARS:
        return 'Stars';
      case SortOrder.PLAYERS_NUMBER:
        return 'Players number';
      default:
        return 'Unknown';
    }
  }
}