import 'package:flutter/foundation.dart';

/// Represents the current game-list state that is kept in sync between the
/// desktop UI and any connected phone browsers.
class MobileRemoteState {
  final String searchText;

  // Each entry: {filterType: "FAMILY_FRIENDLY", activated: false, selected: "FAMILY_FRIENDLY_AVAILABLE"}
  final List<Map<String, dynamic>> filters;

  // Each entry: {type: "minPlayers"|"maxPlaytime", activated: false, selected: 10}
  final List<Map<String, dynamic>> intFilters;

  const MobileRemoteState({
    this.searchText = '',
    this.filters = const [],
    this.intFilters = const [],
  });

  MobileRemoteState copyWith({
    String? searchText,
    List<Map<String, dynamic>>? filters,
    List<Map<String, dynamic>>? intFilters,
  }) {
    return MobileRemoteState(
      searchText: searchText ?? this.searchText,
      filters: filters ?? this.filters,
      intFilters: intFilters ?? this.intFilters,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': 'state',
        'search': searchText,
        'filters': filters,
        'intFilters': intFilters,
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
    );
  }
}

/// Notifies the desktop UI whenever the phone sends a state update.
class MobileRemoteStateNotifier extends ValueNotifier<MobileRemoteState> {
  MobileRemoteStateNotifier() : super(const MobileRemoteState());
}
