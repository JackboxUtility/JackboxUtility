import 'package:jackbox_patcher/model/misc/filter_enum.dart';
import 'package:jackbox_patcher/model/misc/sort_order.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Filter = ({bool activated, FilterValue selected, FilterType type});
typedef IntFilter = ({bool activated, int selected, String type});

class UserGameList {
  final SharedPreferences preferences;

  UserGameList({required this.preferences});

  int patchesAvailable() {
    int totalPatchesAvailable = 0;
    UserData().packs.forEach((element) {
      if (element.owned) {
        UserJackboxPackPatch? packPatch = element.getInstalledPackPatch();
        if (packPatch != null){
          if (packPatch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED) {
            totalPatchesAvailable++;
          }
        }else{
          if (element.patches.length>=1){
            totalPatchesAvailable++;
          }
        }
      }
    });
    return totalPatchesAvailable;
  }

  loadFilters(List<Filter> filters) {
    for (int i = 0; i < filters.length; i++) {
      bool filterActivated = preferences
              .getBool("filter_" + filters[i].type.toString() + "_activated") ??
          false;
      List<FilterValue> filterValuesFound = FilterValue.values
          .where((element) =>
              element.name ==
                  preferences.getString(
                      "filter_" + filters[i].type.toString() + "_selected") &&
              element.type == filters[i].type)
          .toList();
      late FilterValue filterSelected;
      if (filterValuesFound.length == 1) {
        filterSelected = filterValuesFound[0];
      } else {
        filterSelected = filters[i].selected;
      }
      filters[i] = (
        activated: filterActivated,
        selected: filterSelected,
        type: filters[i].type
      );
    }
  }

  loadIntFilters(List<IntFilter> intFilters) {
    for (int i = 0; i < intFilters.length; i++) {
      bool filterActivated = preferences.getBool(
              "filter_" + intFilters[i].type.toString() + "_activated") ??
          false;
      int filterSelected = preferences.getInt(
              "filter_" + intFilters[i].type.toString() + "_selected") ??
          intFilters[i].selected;
      intFilters[i] = (
        activated: filterActivated,
        selected: filterSelected,
        type: intFilters[i].type
      );
    }
  }

  saveFilter(Filter filter) {
    preferences.setBool(
        "filter_" + filter.type.toString() + "_activated", filter.activated);
    preferences.setString(
        "filter_" + filter.type.toString() + "_selected", filter.selected.name);
  }

  saveIntFilter(IntFilter intFilter) {
    preferences.setBool("filter_" + intFilter.type.toString() + "_activated",
        intFilter.activated);
    preferences.setInt("filter_" + intFilter.type.toString() + "_selected",
        intFilter.selected);
  }

  saveFilters(List<Filter> filters) {
    filters.forEach((element) {
      preferences.setBool("filter_" + element.type.toString() + "_activated",
          element.activated);
      preferences.setString("filter_" + element.type.toString() + "_selected",
          element.selected.name);
    });
  }

  saveIntFilters(List<IntFilter> intFilters) {
    intFilters.forEach((element) {
      preferences.setBool("filter_" + element.type.toString() + "_activated",
          element.activated);
      preferences.setInt(
          "filter_" + element.type.toString() + "_selected", element.selected);
    });
  }

  SortOrder loadSort() {
    List<SortOrder> sortsFound = SortOrder.values
        .where(
            (element) => element.name == preferences.getString("sort_selected"))
        .toList();
    late SortOrder sortSelected;
    if (sortsFound.length == 1) {
      sortSelected = sortsFound[0];
    } else {
      sortSelected = SortOrder.PACK;
    }
    return sortSelected;
  }

  saveSort(SortOrder sort) {
    preferences.setString("sort_selected", sort.name);
  }
}
