enum SFX {
  CLICK_ON_STAR_OR_FILTER,
  CLOSE_GAME_INFO_TAB,
  GAME_LAUNCHED,
  HOVER_OVER_BANNER,
  HOVER_OVER_STAR_OR_FILTER,
  OPEN_GAME_INFO_TAB, 
  SCROLL_BETWEEN_GAME_INFO_TABS
}

extension SFXExtension on SFX {
  String get assetName {
    switch (this) {
      case SFX.CLICK_ON_STAR_OR_FILTER:
        return "click_on_star_or_filter.wav";
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
    }
  }
}