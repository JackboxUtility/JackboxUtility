import 'package:flutter/foundation.dart';

/// Represents the current game-list state that is kept in sync between the
/// desktop UI and any connected phone browsers.
class MobileRemoteState {
  final String searchText;

  // Each entry: {filterType: "FAMILY_FRIENDLY", activated: false, selected: "FAMILY_FRIENDLY_AVAILABLE"}
  final List<Map<String, dynamic>> filters;

  // Each entry: {type: "minPlayers"|"maxPlaytime", activated: false, selected: 10}
  final List<Map<String, dynamic>> intFilters;

  // Sort order: 'PACK' | 'NAME' | 'STARS' | 'PLAYERS_NUMBER'
  final String sortOrder;

  // Sort direction
  final bool sortAscending;

  // Whether to show all packs (including unowned) or only owned
  final bool showAllPacks;

  // Whether to show hidden games
  final bool showHidden;

  // Whether desktop cards should always show the stats overlay
  final bool alwaysCardOverlay;

  const MobileRemoteState({
    this.searchText = '',
    this.filters = const [],
    this.intFilters = const [],
    this.sortOrder = 'PACK',
    this.sortAscending = true,
    this.showAllPacks = false,
    this.showHidden = false,
    this.alwaysCardOverlay = false,
  });

  MobileRemoteState copyWith({
    String? searchText,
    List<Map<String, dynamic>>? filters,
    List<Map<String, dynamic>>? intFilters,
    String? sortOrder,
    bool? sortAscending,
    bool? showAllPacks,
    bool? showHidden,
    bool? alwaysCardOverlay,
  }) {
    return MobileRemoteState(
      searchText: searchText ?? this.searchText,
      filters: filters ?? this.filters,
      intFilters: intFilters ?? this.intFilters,
      sortOrder: sortOrder ?? this.sortOrder,
      sortAscending: sortAscending ?? this.sortAscending,
      showAllPacks: showAllPacks ?? this.showAllPacks,
      showHidden: showHidden ?? this.showHidden,
      alwaysCardOverlay: alwaysCardOverlay ?? this.alwaysCardOverlay,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': 'state',
        'search': searchText,
        'filters': filters,
        'intFilters': intFilters,
        'sortOrder': sortOrder,
        'sortAscending': sortAscending,
        'showAllPacks': showAllPacks,
        'showHidden': showHidden,
        'alwaysCardOverlay': alwaysCardOverlay,
      };

  factory MobileRemoteState.fromJson(Map<String, dynamic> json) {
    return MobileRemoteState(
      searchText: (json['search'] as String?) ?? '',
      filters: (json['filters'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      intFilters: (json['intFilters'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      sortOrder: (json['sortOrder'] as String?) ?? 'PACK',
      sortAscending: (json['sortAscending'] as bool?) ?? true,
      showAllPacks: (json['showAllPacks'] as bool?) ?? false,
      showHidden: (json['showHidden'] as bool?) ?? false,
      alwaysCardOverlay: (json['alwaysCardOverlay'] as bool?) ?? false,
    );
  }
}

/// Notifies the desktop UI whenever the phone sends a state update.
class MobileRemoteStateNotifier extends ValueNotifier<MobileRemoteState> {
  MobileRemoteStateNotifier() : super(const MobileRemoteState());
}
