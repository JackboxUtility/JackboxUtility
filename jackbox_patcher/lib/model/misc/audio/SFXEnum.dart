enum SFX {
  CLICK,
  CLOSE_GAME_INFO_TAB,
  GAME_LAUNCHED,
  HOVER_OVER_BANNER,
  HOVER_OVER_STAR_OR_FILTER,
  OPEN_GAME_INFO_TAB,
  SCROLL_BETWEEN_GAME_INFO_TABS,
  FILTER_UP,
  FILTER_DOWN;
}

extension SFXExtension on SFX {
  String get assetName {
    switch (this) {
      case SFX.CLICK:
        return "click.wav";
      case SFX.CLOSE_GAME_INFO_TAB:
        return "close_game_info_tab.wav";
      case SFX.GAME_LAUNCHED:
        return "game_launched.wav";
      case SFX.HOVER_OVER_BANNER:
        return "hover_over_banner.wav";
      case SFX.HOVER_OVER_STAR_OR_FILTER:
        return "hover_over_star_or_filter.wav";
      case SFX.OPEN_GAME_INFO_TAB:
        return "open_game_info_tab.wav";
      case SFX.SCROLL_BETWEEN_GAME_INFO_TABS:
        return "scroll_between_game_info_tabs.wav";
      case SFX.FILTER_UP:
        return "filter_up.wav";
      case SFX.FILTER_DOWN:
        return "filter_down.wav";
    }
  }
}
