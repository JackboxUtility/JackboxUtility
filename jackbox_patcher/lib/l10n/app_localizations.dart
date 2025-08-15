import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_be.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('be'),
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('nb'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('ta'),
    Locale('tr'),
    Locale('uk')
  ];

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @page_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get page_continue;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'quit'**
  String get quit;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @jackbox_utility.
  ///
  /// In en, this message translates to:
  /// **'Jackbox Utility'**
  String get jackbox_utility;

  /// No description provided for @launch_search_game.
  ///
  /// In en, this message translates to:
  /// **'Launch / Search Games'**
  String get launch_search_game;

  /// No description provided for @patch_a_game.
  ///
  /// In en, this message translates to:
  /// **'Patch Games'**
  String get patch_a_game;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @installing_a_patch.
  ///
  /// In en, this message translates to:
  /// **'Installing a Patch'**
  String get installing_a_patch;

  /// No description provided for @installing_a_patch_description.
  ///
  /// In en, this message translates to:
  /// **'You will install the patch. This action is irreversible.'**
  String get installing_a_patch_description;

  /// No description provided for @installing_a_patch_end.
  ///
  /// In en, this message translates to:
  /// **'Installation Complete'**
  String get installing_a_patch_end;

  /// No description provided for @can_close_popup.
  ///
  /// In en, this message translates to:
  /// **'You can close this pop-up'**
  String get can_close_popup;

  /// No description provided for @patch_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Patch Unavailable'**
  String get patch_unavailable;

  /// No description provided for @patch_installed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Patch installed} other {Patches installed}}'**
  String patch_installed(num count);

  /// No description provided for @patch_outdated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Update patch} other {Update patches}}'**
  String patch_outdated(num count);

  /// No description provided for @patch_not_installed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Install the patch} other {Install patches}}'**
  String patch_not_installed(num count);

  /// No description provided for @delete_version.
  ///
  /// In en, this message translates to:
  /// **'Version deletion'**
  String get delete_version;

  /// No description provided for @delete_version_description.
  ///
  /// In en, this message translates to:
  /// **'If you have reset your game, you can delete the installed version of this game. This will allow you to reinstall the patches.'**
  String get delete_version_description;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @patch_modification.
  ///
  /// In en, this message translates to:
  /// **'Patch modification'**
  String get patch_modification;

  /// No description provided for @patch_modification_description.
  ///
  /// In en, this message translates to:
  /// **'This patch changes the game in the following way:'**
  String get patch_modification_description;

  /// No description provided for @patch_modification_content_text.
  ///
  /// In en, this message translates to:
  /// **'Modification of the game\'s text content'**
  String get patch_modification_content_text;

  /// No description provided for @patch_modification_content_internal.
  ///
  /// In en, this message translates to:
  /// **'Modification of the internal files of the game (images, texts...)'**
  String get patch_modification_content_internal;

  /// No description provided for @patch_modification_content_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Modification of the game\'s subtitles'**
  String get patch_modification_content_subtitles;

  /// No description provided for @patch_modification_content_website.
  ///
  /// In en, this message translates to:
  /// **'Modification of the textual content of the jackbox client (only available on {website})'**
  String patch_modification_content_website(String website);

  /// No description provided for @patch_modification_content_audios.
  ///
  /// In en, this message translates to:
  /// **'Modification of the game\'s sound'**
  String get patch_modification_content_audios;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @authors.
  ///
  /// In en, this message translates to:
  /// **'Author(s)'**
  String get authors;

  /// No description provided for @small_information.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get small_information;

  /// No description provided for @more_informations.
  ///
  /// In en, this message translates to:
  /// **'More Information'**
  String get more_informations;

  /// No description provided for @launch_game.
  ///
  /// In en, this message translates to:
  /// **'Launch Game'**
  String get launch_game;

  /// No description provided for @launch_game_fast_launcher.
  ///
  /// In en, this message translates to:
  /// **'Launch Game (Fast Launcher)'**
  String get launch_game_fast_launcher;

  /// No description provided for @launch_game_fast_launcher_description.
  ///
  /// In en, this message translates to:
  /// **'Launches the game in fast launcher mode which allows you to skip the intro video of the pack and the choice of the game. Only available for some games.'**
  String get launch_game_fast_launcher_description;

  /// No description provided for @launch_pack.
  ///
  /// In en, this message translates to:
  /// **'Launch Game'**
  String get launch_pack;

  /// No description provided for @launch_pack_description.
  ///
  /// In en, this message translates to:
  /// **'Launches the Pack normally'**
  String get launch_pack_description;

  /// No description provided for @launch_informations.
  ///
  /// In en, this message translates to:
  /// **'Launch Information'**
  String get launch_informations;

  /// No description provided for @launching.
  ///
  /// In en, this message translates to:
  /// **'Launching…'**
  String get launching;

  /// No description provided for @launched.
  ///
  /// In en, this message translates to:
  /// **'Launched!'**
  String get launched;

  /// No description provided for @path_not_found.
  ///
  /// In en, this message translates to:
  /// **'Path Not Found'**
  String get path_not_found;

  /// No description provided for @path_not_found_small_description.
  ///
  /// In en, this message translates to:
  /// **'The path to the game was not found.'**
  String get path_not_found_small_description;

  /// No description provided for @path_not_found_description.
  ///
  /// In en, this message translates to:
  /// **'The path to the game was not found. Please check that the game is installed and that the path is correct.'**
  String get path_not_found_description;

  /// No description provided for @path_inexistant.
  ///
  /// In en, this message translates to:
  /// **'Path inexistant'**
  String get path_inexistant;

  /// No description provided for @path_inexistant_small_description.
  ///
  /// In en, this message translates to:
  /// **'You did not add the path to the pack.'**
  String get path_inexistant_small_description;

  /// No description provided for @path_inexistant_description.
  ///
  /// In en, this message translates to:
  /// **'You did not add the path to the pack. You can do it in the settings.'**
  String get path_inexistant_description;

  /// No description provided for @pack_path.
  ///
  /// In en, this message translates to:
  /// **'Game path'**
  String get pack_path;

  /// No description provided for @owned_packs.
  ///
  /// In en, this message translates to:
  /// **'Owned Games'**
  String get owned_packs;

  /// No description provided for @add_pack.
  ///
  /// In en, this message translates to:
  /// **'Add a Game'**
  String get add_pack;

  /// No description provided for @choose_pack.
  ///
  /// In en, this message translates to:
  /// **'Choose a Game'**
  String get choose_pack;

  /// No description provided for @game_type_coop.
  ///
  /// In en, this message translates to:
  /// **'Coop'**
  String get game_type_coop;

  /// No description provided for @game_type_coop_description.
  ///
  /// In en, this message translates to:
  /// **'In these games, players must work together to win.'**
  String get game_type_coop_description;

  /// No description provided for @game_type_versus.
  ///
  /// In en, this message translates to:
  /// **'Free For All'**
  String get game_type_versus;

  /// No description provided for @game_type_versus_description.
  ///
  /// In en, this message translates to:
  /// **'In these games, each player plays for himself and must beat the other players.'**
  String get game_type_versus_description;

  /// No description provided for @game_type_team.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get game_type_team;

  /// No description provided for @game_type_team_description.
  ///
  /// In en, this message translates to:
  /// **'In these games, players are divided into teams and must work together to win.'**
  String get game_type_team_description;

  /// No description provided for @game_translation_translated.
  ///
  /// In en, this message translates to:
  /// **'Officially Translated in {language}'**
  String game_translation_translated(String language);

  /// No description provided for @game_translation_translated_description.
  ///
  /// In en, this message translates to:
  /// **'These games are translated natively into {language}.'**
  String game_translation_translated_description(String language);

  /// No description provided for @game_translation_translated_description_en.
  ///
  /// In en, this message translates to:
  /// **'These games are translated in French, Italian, German and Spanish by Jackbox Games.'**
  String get game_translation_translated_description_en;

  /// No description provided for @game_translation_community_translated.
  ///
  /// In en, this message translates to:
  /// **'Translated by the Community'**
  String get game_translation_community_translated;

  /// No description provided for @game_translation_community_translated_description.
  ///
  /// In en, this message translates to:
  /// **'These games are translated by the community.'**
  String game_translation_community_translated_description(Object language);

  /// No description provided for @game_translation_not_available.
  ///
  /// In en, this message translates to:
  /// **'In English'**
  String get game_translation_not_available;

  /// No description provided for @game_translation_not_available_description.
  ///
  /// In en, this message translates to:
  /// **'These games are not translated into {language}.'**
  String game_translation_not_available_description(String language);

  /// No description provided for @game_translation_not_available_description_en.
  ///
  /// In en, this message translates to:
  /// **'These games are only available in English.'**
  String get game_translation_not_available_description_en;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get starting;

  /// No description provided for @extracting.
  ///
  /// In en, this message translates to:
  /// **'Extracting'**
  String get extracting;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'Finalizing'**
  String get finalizing;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknown_error;

  /// No description provided for @contact_error.
  ///
  /// In en, this message translates to:
  /// **'Contact Alexisl61 on Discord'**
  String get contact_error;

  /// No description provided for @game_patch_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Patch unavailable'**
  String get game_patch_unavailable;

  /// No description provided for @game_patch_available.
  ///
  /// In en, this message translates to:
  /// **'A patch is available'**
  String get game_patch_available;

  /// No description provided for @game_patch_installed.
  ///
  /// In en, this message translates to:
  /// **'The patch is up-to-date'**
  String get game_patch_installed;

  /// No description provided for @game_patch_outdated.
  ///
  /// In en, this message translates to:
  /// **'An update is available for this patch'**
  String get game_patch_outdated;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get players;

  /// No description provided for @search_game.
  ///
  /// In en, this message translates to:
  /// **'Search a Game'**
  String get search_game;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @all_games.
  ///
  /// In en, this message translates to:
  /// **'All Games'**
  String get all_games;

  /// No description provided for @all_games_description.
  ///
  /// In en, this message translates to:
  /// **'Find all Jackbox games in one place.'**
  String get all_games_description;

  /// No description provided for @search_by_pack.
  ///
  /// In en, this message translates to:
  /// **'Search by Pack'**
  String get search_by_pack;

  /// No description provided for @search_by_type.
  ///
  /// In en, this message translates to:
  /// **'Search by Type'**
  String get search_by_type;

  /// No description provided for @search_by_translation.
  ///
  /// In en, this message translates to:
  /// **'Search by Translation'**
  String get search_by_translation;

  /// No description provided for @search_by_tags.
  ///
  /// In en, this message translates to:
  /// **'Search by Tags'**
  String get search_by_tags;

  /// No description provided for @select_server_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select one of the available servers'**
  String get select_server_subtitle;

  /// No description provided for @select_server_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading servers…'**
  String get select_server_loading;

  /// No description provided for @select_server_button.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select_server_button;

  /// No description provided for @connected_to_server.
  ///
  /// In en, this message translates to:
  /// **'Connected to the server {server}'**
  String connected_to_server(String server);

  /// No description provided for @connected_to_server_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get connected_to_server_change;

  /// No description provided for @connection_to_server_failed.
  ///
  /// In en, this message translates to:
  /// **'Connection to the Server Failed'**
  String get connection_to_server_failed;

  /// No description provided for @connection_to_main_server_failed.
  ///
  /// In en, this message translates to:
  /// **'Error while retrieving available servers.'**
  String get connection_to_main_server_failed;

  /// No description provided for @quit_while_downloading_title.
  ///
  /// In en, this message translates to:
  /// **'Download in Progress'**
  String get quit_while_downloading_title;

  /// No description provided for @quit_while_downloading_description.
  ///
  /// In en, this message translates to:
  /// **'A download is in progress. Are you sure you want to quit now?'**
  String get quit_while_downloading_description;

  /// No description provided for @automatic_game_finder_title.
  ///
  /// In en, this message translates to:
  /// **'Automatic Game Finder'**
  String get automatic_game_finder_title;

  /// No description provided for @automatic_game_finder_description.
  ///
  /// In en, this message translates to:
  /// **'Jackbox Utility can detect installed games on this computer using Steam and Epic Games.\nDo you want to use this feature?'**
  String get automatic_game_finder_description;

  /// No description provided for @automatic_game_finder_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Retrieving games, please wait'**
  String get automatic_game_finder_in_progress;

  /// No description provided for @automatic_game_finder_finish.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No game found} one {1 game found} other {{count} games found}}'**
  String automatic_game_finder_finish(num count);

  /// No description provided for @automatic_server_finder_found.
  ///
  /// In en, this message translates to:
  /// **'Server Found'**
  String get automatic_server_finder_found;

  /// No description provided for @automatic_server_finder_found_description.
  ///
  /// In en, this message translates to:
  /// **'The server {server} has been chosen based on your language.'**
  String automatic_server_finder_found_description(String server);

  /// No description provided for @show_all_packs.
  ///
  /// In en, this message translates to:
  /// **'Show Unowned Games'**
  String get show_all_packs;

  /// No description provided for @show_owned_packs_only.
  ///
  /// In en, this message translates to:
  /// **'Show Owned Games Only'**
  String get show_owned_packs_only;

  /// No description provided for @all_patches.
  ///
  /// In en, this message translates to:
  /// **'All patches'**
  String get all_patches;

  /// No description provided for @error_happened.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred'**
  String get error_happened;

  /// No description provided for @jackbox_utility_description.
  ///
  /// In en, this message translates to:
  /// **'An open-source app to download patches and launch Jackbox games.'**
  String get jackbox_utility_description;

  /// No description provided for @server_information.
  ///
  /// In en, this message translates to:
  /// **'Server Information (Language)'**
  String get server_information;

  /// No description provided for @selected_server.
  ///
  /// In en, this message translates to:
  /// **'Selected Server'**
  String get selected_server;

  /// No description provided for @change_server.
  ///
  /// In en, this message translates to:
  /// **'Change Server'**
  String get change_server;

  /// No description provided for @app_information.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get app_information;

  /// No description provided for @automatic_game_finder_button.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect installed games'**
  String get automatic_game_finder_button;

  /// No description provided for @games_available.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No game available} one {1 game available} other {{count} games available}}'**
  String games_available(num count);

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @contributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;

  /// No description provided for @in_language.
  ///
  /// In en, this message translates to:
  /// **'In {language}'**
  String in_language(String language);

  /// No description provided for @in_language_description.
  ///
  /// In en, this message translates to:
  /// **'These games are available in {language} (natively or translated by the community.)'**
  String in_language_description(String language);

  /// No description provided for @game_community_dubbed.
  ///
  /// In en, this message translates to:
  /// **'Community Dubbed'**
  String get game_community_dubbed;

  /// No description provided for @game_community_dubbed_description.
  ///
  /// In en, this message translates to:
  /// **'These games are dubbed by the community.'**
  String get game_community_dubbed_description;

  /// No description provided for @game_dubbed.
  ///
  /// In en, this message translates to:
  /// **'Dubbed in {language}'**
  String game_dubbed(String language);

  /// No description provided for @game_dubbed_description.
  ///
  /// In en, this message translates to:
  /// **'These games are dubbed by the community or by Jackbox.'**
  String get game_dubbed_description;

  /// No description provided for @no_game_in_this_category_title.
  ///
  /// In en, this message translates to:
  /// **'No games in this category'**
  String get no_game_in_this_category_title;

  /// No description provided for @no_game_in_this_category_description.
  ///
  /// In en, this message translates to:
  /// **'There are no games in this category. Try adding more in the Settings section.'**
  String get no_game_in_this_category_description;

  /// No description provided for @select_game_location.
  ///
  /// In en, this message translates to:
  /// **'Select the location of {game}'**
  String select_game_location(String game);

  /// No description provided for @download_error.
  ///
  /// In en, this message translates to:
  /// **'Error while downloading'**
  String get download_error;

  /// No description provided for @download_error_description.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while downloading the game. Please verify your internet connection and try again.'**
  String get download_error_description;

  /// No description provided for @extracting_error.
  ///
  /// In en, this message translates to:
  /// **'Error while extracting'**
  String get extracting_error;

  /// No description provided for @extracting_error_description.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while extracting the game. Check if you have enough storage free and try again.'**
  String get extracting_error_description;

  /// No description provided for @game_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset Game'**
  String get game_reset;

  /// No description provided for @game_reset_description.
  ///
  /// In en, this message translates to:
  /// **'This will validate all the files of this game. If you installed any patch, it will be deleted from your game. Are you sure you want to continue?'**
  String get game_reset_description;

  /// No description provided for @small_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get small_description;

  /// No description provided for @patreon_subscribers.
  ///
  /// In en, this message translates to:
  /// **'Patreon Subscribers'**
  String get patreon_subscribers;

  /// No description provided for @audience.
  ///
  /// In en, this message translates to:
  /// **'Audience'**
  String get audience;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmation_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action}? This action cannot be undone.'**
  String confirmation_description(String action);

  /// No description provided for @fix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get fix;

  /// No description provided for @fixes_available.
  ///
  /// In en, this message translates to:
  /// **'YDKJ Vol. 6 Fix'**
  String get fixes_available;

  /// No description provided for @fixes_available_description.
  ///
  /// In en, this message translates to:
  /// **'You Don\'t Know Jack Vol. 6 The Lost Gold was detected as one of the installed games. This game normally doesn\'t work on Windows 10/11 and Linux. Would you like to download and install a patch that fixes it? You can always install it in its respective game info tab.'**
  String get fixes_available_description;

  /// No description provided for @filter_players_number.
  ///
  /// In en, this message translates to:
  /// **'Player Count'**
  String get filter_players_number;

  /// No description provided for @family_friendly.
  ///
  /// In en, this message translates to:
  /// **'Family-Friendly'**
  String get family_friendly;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @subtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// No description provided for @stream_friendly.
  ///
  /// In en, this message translates to:
  /// **'Stream-Friendly'**
  String get stream_friendly;

  /// No description provided for @moderation.
  ///
  /// In en, this message translates to:
  /// **'Moderation'**
  String get moderation;

  /// No description provided for @randomize_button_text.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Try Another One!'**
  String get randomize_button_text;

  /// No description provided for @feeling_lucky.
  ///
  /// In en, this message translates to:
  /// **'I\'m Feeling Lucky'**
  String get feeling_lucky;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by {type}'**
  String sort_by(String type);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @show_games_hidden.
  ///
  /// In en, this message translates to:
  /// **'Show Games You\'ve Hidden'**
  String get show_games_hidden;

  /// No description provided for @hide_games_hidden.
  ///
  /// In en, this message translates to:
  /// **'Hide Games You\'ve Hidden'**
  String get hide_games_hidden;

  /// No description provided for @max_playtime.
  ///
  /// In en, this message translates to:
  /// **'Max Playtime'**
  String get max_playtime;

  /// No description provided for @search_by_ranking.
  ///
  /// In en, this message translates to:
  /// **'Search by Ranking'**
  String get search_by_ranking;

  /// No description provided for @random_game.
  ///
  /// In en, this message translates to:
  /// **'Random Game'**
  String get random_game;

  /// No description provided for @personal_ranking.
  ///
  /// In en, this message translates to:
  /// **'Personal Ranking'**
  String get personal_ranking;

  /// No description provided for @ranked_by_stars.
  ///
  /// In en, this message translates to:
  /// **'Ranked by Stars'**
  String get ranked_by_stars;

  /// No description provided for @games_ranked_by_stars_from_personal_ranking.
  ///
  /// In en, this message translates to:
  /// **'Games ranked by stars from your personal ranking.'**
  String get games_ranked_by_stars_from_personal_ranking;

  /// No description provided for @unranked.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get unranked;

  /// No description provided for @app_behavior.
  ///
  /// In en, this message translates to:
  /// **'App Behavior'**
  String get app_behavior;

  /// No description provided for @settings_app_startup_category.
  ///
  /// In en, this message translates to:
  /// **'App Startup'**
  String get settings_app_startup_category;

  /// No description provided for @settings_app_startup_title.
  ///
  /// In en, this message translates to:
  /// **'Open Launcher on App Startup'**
  String get settings_app_startup_title;

  /// No description provided for @settings_app_startup_description.
  ///
  /// In en, this message translates to:
  /// **'Open the list of games when you open the app.'**
  String get settings_app_startup_description;

  /// No description provided for @settings_discord_rich_presence_category.
  ///
  /// In en, this message translates to:
  /// **'Discord Rich Presence Settings'**
  String get settings_discord_rich_presence_category;

  /// No description provided for @settings_discord_rich_presence_title.
  ///
  /// In en, this message translates to:
  /// **'Discord Rich Presence'**
  String get settings_discord_rich_presence_title;

  /// No description provided for @settings_discord_rich_presence_description.
  ///
  /// In en, this message translates to:
  /// **'Shows what you\'re playing on Discord. This will only work if you have Discord open.'**
  String get settings_discord_rich_presence_description;

  /// No description provided for @settings_discord_rich_presence_buttons_title.
  ///
  /// In en, this message translates to:
  /// **'Show Support Buttons'**
  String get settings_discord_rich_presence_buttons_title;

  /// No description provided for @settings_discord_rich_presence_buttons_description.
  ///
  /// In en, this message translates to:
  /// **'Shows link buttons to the GitHub and the Discord of the app on your Discord Rich Presence.'**
  String get settings_discord_rich_presence_buttons_description;

  /// No description provided for @settings_audio_category.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get settings_audio_category;

  /// No description provided for @settings_sfx_title.
  ///
  /// In en, this message translates to:
  /// **'Enable SFX'**
  String get settings_sfx_title;

  /// No description provided for @settings_sfx_description.
  ///
  /// In en, this message translates to:
  /// **'Enables sound effects in the app.'**
  String get settings_sfx_description;

  /// No description provided for @settings_app_saves_category.
  ///
  /// In en, this message translates to:
  /// **'App Saves'**
  String get settings_app_saves_category;

  /// No description provided for @settings_app_reset_stars_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Stars'**
  String get settings_app_reset_stars_title;

  /// No description provided for @settings_app_reset_stars_description.
  ///
  /// In en, this message translates to:
  /// **'Resets all the stars for each game.'**
  String get settings_app_reset_stars_description;

  /// No description provided for @settings_app_reset_stars_button_text.
  ///
  /// In en, this message translates to:
  /// **'Reset Stars'**
  String get settings_app_reset_stars_button_text;

  /// No description provided for @settings_app_reset_stars_action.
  ///
  /// In en, this message translates to:
  /// **'reset all the stars for each game'**
  String get settings_app_reset_stars_action;

  /// No description provided for @settings_app_reset_hidden_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Hidden Games'**
  String get settings_app_reset_hidden_title;

  /// No description provided for @settings_app_reset_hidden_description.
  ///
  /// In en, this message translates to:
  /// **'Resets all the hidden games to visible.'**
  String get settings_app_reset_hidden_description;

  /// No description provided for @settings_app_reset_hidden_button_text.
  ///
  /// In en, this message translates to:
  /// **'Reset Hidden Games'**
  String get settings_app_reset_hidden_button_text;

  /// No description provided for @settings_app_reset_hidden_action.
  ///
  /// In en, this message translates to:
  /// **'reset all the hidden games to visible'**
  String get settings_app_reset_hidden_action;

  /// No description provided for @rich_presence_application_start_details.
  ///
  /// In en, this message translates to:
  /// **'Just Started the App'**
  String get rich_presence_application_start_details;

  /// No description provided for @rich_presence_application_start_state.
  ///
  /// In en, this message translates to:
  /// **'In the Menu'**
  String get rich_presence_application_start_state;

  /// No description provided for @rich_presence_game_menu_details.
  ///
  /// In en, this message translates to:
  /// **'Choosing a Game'**
  String get rich_presence_game_menu_details;

  /// No description provided for @rich_presence_game_menu_state.
  ///
  /// In en, this message translates to:
  /// **'In the Games List'**
  String get rich_presence_game_menu_state;

  /// No description provided for @rich_presence_game_information_details.
  ///
  /// In en, this message translates to:
  /// **'Reading the Information of a Game'**
  String get rich_presence_game_information_details;

  /// No description provided for @rich_presence_game_information_state.
  ///
  /// In en, this message translates to:
  /// **'Choosing a Game'**
  String get rich_presence_game_information_state;

  /// No description provided for @rich_presence_patcher_details.
  ///
  /// In en, this message translates to:
  /// **'Patching a Game'**
  String get rich_presence_patcher_details;

  /// No description provided for @rich_presence_patcher_state.
  ///
  /// In en, this message translates to:
  /// **'In the Patch List'**
  String get rich_presence_patcher_state;

  /// No description provided for @rich_presence_settings_details.
  ///
  /// In en, this message translates to:
  /// **'Tweaking the App'**
  String get rich_presence_settings_details;

  /// No description provided for @rich_presence_settings_state.
  ///
  /// In en, this message translates to:
  /// **'In the Settings'**
  String get rich_presence_settings_state;

  /// No description provided for @rich_presence_in_game_details.
  ///
  /// In en, this message translates to:
  /// **'In-game'**
  String get rich_presence_in_game_details;

  /// No description provided for @open_launcher_on_startup_title_tip.
  ///
  /// In en, this message translates to:
  /// **'Open Launcher on Startup'**
  String get open_launcher_on_startup_title_tip;

  /// No description provided for @open_launcher_on_startup_description_tip.
  ///
  /// In en, this message translates to:
  /// **'The app can launch on this screen when you start it automatically. Do you want to activate this feature? (This can always be changed in the settings.)'**
  String get open_launcher_on_startup_description_tip;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @using_beta_version_text.
  ///
  /// In en, this message translates to:
  /// **'You are using the beta version of the app. If you encounter any issues, please report them on the Discord server or Github repository.'**
  String get using_beta_version_text;

  /// No description provided for @pack.
  ///
  /// In en, this message translates to:
  /// **'Pack'**
  String get pack;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @players_number.
  ///
  /// In en, this message translates to:
  /// **'Player Count'**
  String get players_number;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @installed_version.
  ///
  /// In en, this message translates to:
  /// **'Installed Version'**
  String get installed_version;

  /// No description provided for @filter_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get filter_available;

  /// No description provided for @filter_fully_playable.
  ///
  /// In en, this message translates to:
  /// **'Fully Playable'**
  String get filter_fully_playable;

  /// No description provided for @filter_midly_playable.
  ///
  /// In en, this message translates to:
  /// **'Mildly Playable'**
  String get filter_midly_playable;

  /// No description provided for @filter_playable.
  ///
  /// In en, this message translates to:
  /// **'Playable'**
  String get filter_playable;

  /// No description provided for @filter_full_moderation.
  ///
  /// In en, this message translates to:
  /// **'Full Moderation'**
  String get filter_full_moderation;

  /// No description provided for @filter_censoring.
  ///
  /// In en, this message translates to:
  /// **'Censoring'**
  String get filter_censoring;

  /// No description provided for @filter_moderation_censoring.
  ///
  /// In en, this message translates to:
  /// **'Mod. & Censoring'**
  String get filter_moderation_censoring;

  /// No description provided for @filter_dubbed.
  ///
  /// In en, this message translates to:
  /// **'Dubbed'**
  String get filter_dubbed;

  /// No description provided for @filter_translated.
  ///
  /// In en, this message translates to:
  /// **'Translated'**
  String get filter_translated;

  /// No description provided for @special_thanks.
  ///
  /// In en, this message translates to:
  /// **'Special Thanks'**
  String get special_thanks;

  /// No description provided for @stream_friendly_tooltip.
  ///
  /// In en, this message translates to:
  /// **'If you can play this game through a stream, that being in a streaming platform or sharing your screen through Discord, Zoom, Meet, etc.'**
  String get stream_friendly_tooltip;

  /// No description provided for @family_friendly_tooltip.
  ///
  /// In en, this message translates to:
  /// **'If this game can be played with all the family (children included.)'**
  String get family_friendly_tooltip;

  /// No description provided for @moderation_tooltip.
  ///
  /// In en, this message translates to:
  /// **'If this game has a moderation system (accepts, rejects or censors player input on-screen.)'**
  String get moderation_tooltip;

  /// No description provided for @audience_tooltip.
  ///
  /// In en, this message translates to:
  /// **'If this game accepts audience members (up to 10.000, unless mentioned otherwise) to play along after players have joined.'**
  String get audience_tooltip;

  /// No description provided for @subtitles_tooltip.
  ///
  /// In en, this message translates to:
  /// **'If this game has subtitles to be displayed on-screen.'**
  String get subtitles_tooltip;

  /// No description provided for @custom_server_title.
  ///
  /// In en, this message translates to:
  /// **'Custom Server'**
  String get custom_server_title;

  /// No description provided for @custom_server_description.
  ///
  /// In en, this message translates to:
  /// **'Use a link to connect to a custom server.'**
  String get custom_server_description;

  /// No description provided for @custom_server_explanation.
  ///
  /// In en, this message translates to:
  /// **'Use a link to the info.json file of a custom server to connect to it.'**
  String get custom_server_explanation;

  /// No description provided for @custom_server_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to recover server from link.'**
  String get custom_server_error;

  /// No description provided for @custom_server_warning.
  ///
  /// In en, this message translates to:
  /// **'If someone asked you to add a link there, it\'s likely a scam. Do not continue If you don\'t trust the owner of this server.'**
  String get custom_server_warning;

  /// No description provided for @custom_server_add_question.
  ///
  /// In en, this message translates to:
  /// **'Do you want to use this server?'**
  String get custom_server_add_question;

  /// No description provided for @custom_server_link.
  ///
  /// In en, this message translates to:
  /// **'Custom server link'**
  String get custom_server_link;

  /// No description provided for @loading_initialization_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize the app.'**
  String get loading_initialization_failed;

  /// No description provided for @loading_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to the server.'**
  String get loading_connection_failed;

  /// No description provided for @loading_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve your saves.'**
  String get loading_save_failed;

  /// No description provided for @loading_open_issue_discord.
  ///
  /// In en, this message translates to:
  /// **'Please open an issue on GitHub or report it on Discord.'**
  String get loading_open_issue_discord;

  /// No description provided for @loading_check_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get loading_check_internet_connection;

  /// No description provided for @loading_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get loading_try_again;

  /// No description provided for @settings_anonymous_data_title.
  ///
  /// In en, this message translates to:
  /// **'Anonymous data collection'**
  String get settings_anonymous_data_title;

  /// No description provided for @settings_anonymous_data_description.
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app by sending anonymous data about your usage of the app.'**
  String get settings_anonymous_data_description;

  /// No description provided for @privacy_info.
  ///
  /// In en, this message translates to:
  /// **'Privacy notice'**
  String get privacy_info;

  /// No description provided for @privacy_description.
  ///
  /// In en, this message translates to:
  /// **'This app is collecting anonymous statistics to improve the app. You can disable this in the settings.'**
  String get privacy_description;

  /// No description provided for @hidden_button_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Click to hide this game from the game list.'**
  String get hidden_button_tooltip;

  /// No description provided for @hidden_button_hidden_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Click to unhide this game from the game list.'**
  String get hidden_button_hidden_tooltip;

  /// No description provided for @patch_missing_before_launching_title.
  ///
  /// In en, this message translates to:
  /// **'Patch Missing'**
  String get patch_missing_before_launching_title;

  /// No description provided for @patch_missing_before_launching_description.
  ///
  /// In en, this message translates to:
  /// **'This game has a patch available. Do you want to install it before launching the game?'**
  String get patch_missing_before_launching_description;

  /// No description provided for @patch_missing_before_launching_install.
  ///
  /// In en, this message translates to:
  /// **'Install Patch'**
  String get patch_missing_before_launching_install;

  /// No description provided for @patch_missing_before_launching_launch.
  ///
  /// In en, this message translates to:
  /// **'Launch Game'**
  String get patch_missing_before_launching_launch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'be',
        'ca',
        'de',
        'en',
        'es',
        'fr',
        'nb',
        'pl',
        'pt',
        'ru',
        'ta',
        'tr',
        'uk'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'be':
      return AppLocalizationsBe();
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'nb':
      return AppLocalizationsNb();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'ta':
      return AppLocalizationsTa();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
