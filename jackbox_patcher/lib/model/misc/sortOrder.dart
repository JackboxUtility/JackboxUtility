enum SortOrder {
  PACK,
  NAME,
  STARS;
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
      default:
        return 'Unknown';
    }
  }
}