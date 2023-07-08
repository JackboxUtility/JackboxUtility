enum SFX {
  CLICK,
  CLOSE_GAME_INFO_TAB,
  GAME_LAUNCHED,
  HOVER_OVER_BANNER,
  HOVER_OVER_STAR_OR_FILTER,
  OPEN_GAME_INFO_TAB,
  OPEN_GAME_LIST,
  SCROLL_BETWEEN_GAME_INFO_TABS,
  FILTER_UP,
  FILTER_DOWN;
}

extension SFXExtension on SFX {
  String get assetName {
    switch (this) {
      case SFX.CLICK:
        return "click.mp3";
      case SFX.CLOSE_GAME_INFO_TAB:
        return "close_game_info_tab.mp3";
      case SFX.GAME_LAUNCHED:
        return "game_launched.mp3";
      case SFX.HOVER_OVER_BANNER:
        return "hover_over_banner.mp3";
      case SFX.HOVER_OVER_STAR_OR_FILTER:
        return "hover_over_star_or_filter.mp3";
      case SFX.OPEN_GAME_INFO_TAB:
        return "open_game_info_tab.mp3";
      case SFX.OPEN_GAME_LIST:
        return "open_game_list.mp3";
      case SFX.SCROLL_BETWEEN_GAME_INFO_TABS:
        return "scroll_between_game_info_tabs.mp3";
      case SFX.FILTER_UP:
        return "filter_up.mp3";
      case SFX.FILTER_DOWN:
        return "filter_down.mp3";
    }
  }
}
