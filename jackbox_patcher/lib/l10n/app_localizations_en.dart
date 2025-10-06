// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get page_continue => 'Continue';

  @override
  String get confirm => 'Confirm';

  @override
  String get quit => 'quit';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Launch / Search Games';

  @override
  String get patch_a_game => 'Patch Games';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get installing_a_patch => 'Installing a Patch';

  @override
  String get installing_a_patch_description =>
      'You will install the patch. This action is irreversible.';

  @override
  String get installing_a_patch_end => 'Installation Complete';

  @override
  String get thank_the_team_button => 'Thank the team';

  @override
  String get thank_the_team_description => 'Thank the team for the translation';

  @override
  String get can_close_popup => 'You can close this pop-up';

  @override
  String get patch_unavailable => 'Patch Unavailable';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Patches installed',
      one: 'Patch installed',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Update patches',
      one: 'Update patch',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Install patches',
      one: 'Install the patch',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Version deletion';

  @override
  String get delete_version_description =>
      'If you have reset your game, you can delete the installed version of this game. This will allow you to reinstall the patches.';

  @override
  String get description => 'Description';

  @override
  String get patch_modification => 'Patch modification';

  @override
  String get patch_modification_description =>
      'This patch changes the game in the following way:';

  @override
  String get patch_modification_content_text =>
      'Modification of the game\'s text content';

  @override
  String get patch_modification_content_internal =>
      'Modification of the internal files of the game (images, texts...)';

  @override
  String get patch_modification_content_subtitles =>
      'Modification of the game\'s subtitles';

  @override
  String patch_modification_content_website(String website) {
    return 'Modification of the textual content of the jackbox client (only available on $website)';
  }

  @override
  String get patch_modification_content_audios =>
      'Modification of the game\'s sound';

  @override
  String get version => 'Version';

  @override
  String get authors => 'Author(s)';

  @override
  String get small_information => 'Info';

  @override
  String get more_informations => 'More Information';

  @override
  String get launch_game => 'Launch Game';

  @override
  String get launch_game_fast_launcher => 'Launch Game (Fast Launcher)';

  @override
  String get launch_game_fast_launcher_description =>
      'Launches the game in fast launcher mode which allows you to skip the intro video of the pack and the choice of the game. Only available for some games.';

  @override
  String get launch_pack => 'Launch Game';

  @override
  String get launch_pack_description => 'Launches the Pack normally';

  @override
  String get launch_informations => 'Launch Information';

  @override
  String get launching => 'Launching…';

  @override
  String get launched => 'Launched!';

  @override
  String get path_not_found => 'Path Not Found';

  @override
  String get path_not_found_small_description =>
      'The path to the game was not found.';

  @override
  String get path_not_found_description =>
      'The path to the game was not found. Please check that the game is installed and that the path is correct.';

  @override
  String get path_inexistant => 'Path inexistant';

  @override
  String get path_inexistant_small_description =>
      'You did not add the path to the pack.';

  @override
  String get path_inexistant_description =>
      'You did not add the path to the pack. You can do it in the settings.';

  @override
  String get pack_path => 'Game path';

  @override
  String get owned_packs => 'Owned Games';

  @override
  String get add_pack => 'Add a Game';

  @override
  String get choose_pack => 'Choose a Game';

  @override
  String get game_type_coop => 'Coop';

  @override
  String get game_type_coop_description =>
      'In these games, players must work together to win.';

  @override
  String get game_type_versus => 'Free For All';

  @override
  String get game_type_versus_description =>
      'In these games, each player plays for himself and must beat the other players.';

  @override
  String get game_type_team => 'Teams';

  @override
  String get game_type_team_description =>
      'In these games, players are divided into teams and must work together to win.';

  @override
  String game_translation_translated(String language) {
    return 'Officially Translated in $language';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'These games are translated natively into $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'These games are translated in French, Italian, German and Spanish by Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Translated by the Community';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'These games are translated by the community.';
  }

  @override
  String get game_translation_not_available => 'In English';

  @override
  String game_translation_not_available_description(String language) {
    return 'These games are not translated into $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'These games are only available in English.';

  @override
  String get downloading => 'Downloading';

  @override
  String get starting => 'Starting';

  @override
  String get extracting => 'Extracting';

  @override
  String get finalizing => 'Finalizing';

  @override
  String get unknown_error => 'Unknown Error';

  @override
  String get contact_error => 'Contact Alexisl61 on Discord';

  @override
  String get game_patch_unavailable => 'Patch unavailable';

  @override
  String get game_patch_available => 'A patch is available';

  @override
  String get game_patch_installed => 'The patch is up-to-date';

  @override
  String get game_patch_outdated => 'An update is available for this patch';

  @override
  String get players => 'players';

  @override
  String get search_game => 'Search a Game';

  @override
  String get search => 'Search';

  @override
  String get all_games => 'All Games';

  @override
  String get all_games_description => 'Find all Jackbox games in one place.';

  @override
  String get search_by_pack => 'Search by Pack';

  @override
  String get search_by_type => 'Search by Type';

  @override
  String get search_by_translation => 'Search by Translation';

  @override
  String get search_by_tags => 'Search by Tags';

  @override
  String get select_server_subtitle => 'Select one of the available servers';

  @override
  String get select_server_loading => 'Loading servers…';

  @override
  String get select_server_button => 'Select';

  @override
  String connected_to_server(String server) {
    return 'Connected to the server $server';
  }

  @override
  String get connected_to_server_change => 'Change';

  @override
  String get connection_to_server_failed => 'Connection to the Server Failed';

  @override
  String get connection_to_main_server_failed =>
      'Error while retrieving available servers.';

  @override
  String get quit_while_downloading_title => 'Download in Progress';

  @override
  String get quit_while_downloading_description =>
      'A download is in progress. Are you sure you want to quit now?';

  @override
  String get automatic_game_finder_title => 'Automatic Game Finder';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility can detect installed games on this computer using Steam and Epic Games.\nDo you want to use this feature?';

  @override
  String get automatic_game_finder_in_progress =>
      'Retrieving games, please wait';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games found',
      one: '1 game found',
      zero: 'No game found',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Server Found';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'The server $server has been chosen based on your language.';
  }

  @override
  String get show_all_packs => 'Show Unowned Games';

  @override
  String get show_owned_packs_only => 'Show Owned Games Only';

  @override
  String get all_patches => 'All patches';

  @override
  String get error_happened => 'An error has occurred';

  @override
  String get jackbox_utility_description =>
      'An open-source app to download patches and launch Jackbox games.';

  @override
  String get server_information => 'Server Information (Language)';

  @override
  String get selected_server => 'Selected Server';

  @override
  String get change_server => 'Change Server';

  @override
  String get app_information => 'App Information';

  @override
  String get automatic_game_finder_button => 'Auto-detect installed games';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games available',
      one: '1 game available',
      zero: 'No game available',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Author';

  @override
  String get contributors => 'Contributors';

  @override
  String in_language(String language) {
    return 'In $language';
  }

  @override
  String in_language_description(String language) {
    return 'These games are available in $language (natively or translated by the community.)';
  }

  @override
  String get game_community_dubbed => 'Community Dubbed';

  @override
  String get game_community_dubbed_description =>
      'These games are dubbed by the community.';

  @override
  String game_dubbed(String language) {
    return 'Dubbed in $language';
  }

  @override
  String get game_dubbed_description =>
      'These games are dubbed by the community or by Jackbox.';

  @override
  String get no_game_in_this_category_title => 'No games in this category';

  @override
  String get no_game_in_this_category_description =>
      'There are no games in this category. Try adding more in the Settings section.';

  @override
  String select_game_location(String game) {
    return 'Select the location of $game';
  }

  @override
  String get download_error => 'Error while downloading';

  @override
  String get download_error_description =>
      'An error occurred while downloading the game. Please verify your internet connection and try again.';

  @override
  String get extracting_error => 'Error while extracting';

  @override
  String get extracting_error_description =>
      'An error occurred while extracting the game. Check if you have enough storage free and try again.';

  @override
  String get game_reset => 'Reset Game';

  @override
  String get game_reset_description =>
      'This will validate all the files of this game. If you installed any patch, it will be deleted from your game. Are you sure you want to continue?';

  @override
  String get small_description => 'Description';

  @override
  String get patreon_subscribers => 'Patreon Subscribers';

  @override
  String get audience => 'Audience';

  @override
  String get confirmation => 'Confirmation';

  @override
  String confirmation_description(String action) {
    return 'Are you sure you want to $action? This action cannot be undone.';
  }

  @override
  String get fix => 'Fix';

  @override
  String get fixes_available => 'YDKJ Vol. 6 Fix';

  @override
  String get fixes_available_description =>
      'You Don\'t Know Jack Vol. 6 The Lost Gold was detected as one of the installed games. This game normally doesn\'t work on Windows 10/11 and Linux. Would you like to download and install a patch that fixes it? You can always install it in its respective game info tab.';

  @override
  String get filter_players_number => 'Player Count';

  @override
  String get family_friendly => 'Family-Friendly';

  @override
  String get optional => 'Optional';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get stream_friendly => 'Stream-Friendly';

  @override
  String get moderation => 'Moderation';

  @override
  String get randomize_button_text => 'Let\'s Try Another One!';

  @override
  String get feeling_lucky => 'I\'m Feeling Lucky';

  @override
  String sort_by(String type) {
    return 'Sort by $type';
  }

  @override
  String get filter => 'Filter';

  @override
  String get show_games_hidden => 'Show Games You\'ve Hidden';

  @override
  String get hide_games_hidden => 'Hide Games You\'ve Hidden';

  @override
  String get max_playtime => 'Max Playtime';

  @override
  String get search_by_ranking => 'Search by Ranking';

  @override
  String get random_game => 'Random Game';

  @override
  String get personal_ranking => 'Personal Ranking';

  @override
  String get ranked_by_stars => 'Ranked by Stars';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Games ranked by stars from your personal ranking.';

  @override
  String get unranked => 'Unranked';

  @override
  String get app_behavior => 'App Behavior';

  @override
  String get settings_app_startup_category => 'App Startup';

  @override
  String get settings_app_startup_title => 'Open Launcher on App Startup';

  @override
  String get settings_app_startup_description =>
      'Open the list of games when you open the app.';

  @override
  String get settings_discord_rich_presence_category =>
      'Discord Rich Presence Settings';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Shows what you\'re playing on Discord. This will only work if you have Discord open.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Show Support Buttons';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Shows link buttons to the GitHub and the Discord of the app on your Discord Rich Presence.';

  @override
  String get settings_audio_category => 'Audio';

  @override
  String get settings_sfx_title => 'Enable SFX';

  @override
  String get settings_sfx_description => 'Enables sound effects in the app.';

  @override
  String get settings_app_saves_category => 'App Saves';

  @override
  String get settings_app_reset_stars_title => 'Reset Stars';

  @override
  String get settings_app_reset_stars_description =>
      'Resets all the stars for each game.';

  @override
  String get settings_app_reset_stars_button_text => 'Reset Stars';

  @override
  String get settings_app_reset_stars_action =>
      'reset all the stars for each game';

  @override
  String get settings_app_reset_hidden_title => 'Reset Hidden Games';

  @override
  String get settings_app_reset_hidden_description =>
      'Resets all the hidden games to visible.';

  @override
  String get settings_app_reset_hidden_button_text => 'Reset Hidden Games';

  @override
  String get settings_app_reset_hidden_action =>
      'reset all the hidden games to visible';

  @override
  String get rich_presence_application_start_details => 'Just Started the App';

  @override
  String get rich_presence_application_start_state => 'In the Menu';

  @override
  String get rich_presence_game_menu_details => 'Choosing a Game';

  @override
  String get rich_presence_game_menu_state => 'In the Games List';

  @override
  String get rich_presence_game_information_details =>
      'Reading the Information of a Game';

  @override
  String get rich_presence_game_information_state => 'Choosing a Game';

  @override
  String get rich_presence_patcher_details => 'Patching a Game';

  @override
  String get rich_presence_patcher_state => 'In the Patch List';

  @override
  String get rich_presence_settings_details => 'Tweaking the App';

  @override
  String get rich_presence_settings_state => 'In the Settings';

  @override
  String get rich_presence_in_game_details => 'In-game';

  @override
  String get open_launcher_on_startup_title_tip => 'Open Launcher on Startup';

  @override
  String get open_launcher_on_startup_description_tip =>
      'The app can launch on this screen when you start it automatically. Do you want to activate this feature? (This can always be changed in the settings.)';

  @override
  String get minutes => 'minutes';

  @override
  String get translation => 'Translation';

  @override
  String get using_beta_version_text =>
      'You are using the beta version of the app. If you encounter any issues, please report them on the Discord server or Github repository.';

  @override
  String get pack => 'Pack';

  @override
  String get stars => 'Stars';

  @override
  String get name => 'Name';

  @override
  String get players_number => 'Player Count';

  @override
  String get donate => 'Donate';

  @override
  String get installed_version => 'Installed Version';

  @override
  String get filter_available => 'Available';

  @override
  String get filter_fully_playable => 'Fully Playable';

  @override
  String get filter_midly_playable => 'Mildly Playable';

  @override
  String get filter_playable => 'Playable';

  @override
  String get filter_full_moderation => 'Full Moderation';

  @override
  String get filter_censoring => 'Censoring';

  @override
  String get filter_moderation_censoring => 'Mod. & Censoring';

  @override
  String get filter_dubbed => 'Dubbed';

  @override
  String get filter_translated => 'Translated';

  @override
  String get special_thanks => 'Special Thanks';

  @override
  String get stream_friendly_tooltip =>
      'If you can play this game through a stream, that being in a streaming platform or sharing your screen through Discord, Zoom, Meet, etc.';

  @override
  String get family_friendly_tooltip =>
      'If this game can be played with all the family (children included.)';

  @override
  String get moderation_tooltip =>
      'If this game has a moderation system (accepts, rejects or censors player input on-screen.)';

  @override
  String get audience_tooltip =>
      'If this game accepts audience members (up to 10.000, unless mentioned otherwise) to play along after players have joined.';

  @override
  String get subtitles_tooltip =>
      'If this game has subtitles to be displayed on-screen.';

  @override
  String get custom_server_title => 'Custom Server';

  @override
  String get custom_server_description =>
      'Use a link to connect to a custom server.';

  @override
  String get custom_server_explanation =>
      'Use a link to the info.json file of a custom server to connect to it.';

  @override
  String get custom_server_error => 'Failed to recover server from link.';

  @override
  String get custom_server_warning =>
      'If someone asked you to add a link there, it\'s likely a scam. Do not continue If you don\'t trust the owner of this server.';

  @override
  String get custom_server_add_question => 'Do you want to use this server?';

  @override
  String get custom_server_link => 'Custom server link';

  @override
  String get loading_initialization_failed => 'Failed to initialize the app.';

  @override
  String get loading_connection_failed => 'Failed to connect to the server.';

  @override
  String get loading_save_failed => 'Failed to retrieve your saves.';

  @override
  String get loading_open_issue_discord =>
      'Please open an issue on GitHub or report it on Discord.';

  @override
  String get loading_check_internet_connection =>
      'Please check your internet connection and try again.';

  @override
  String get loading_try_again => 'Try Again';

  @override
  String get settings_anonymous_data_title => 'Anonymous data collection';

  @override
  String get settings_anonymous_data_description =>
      'Help us improve the app by sending anonymous data about your usage of the app.';

  @override
  String get privacy_info => 'Privacy notice';

  @override
  String get privacy_description =>
      'This app is collecting anonymous statistics to improve the app. You can disable this in the settings.';

  @override
  String get hidden_button_tooltip =>
      'Click to hide this game from the game list.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Click to unhide this game from the game list.';

  @override
  String get patch_missing_before_launching_title => 'Patch Missing';

  @override
  String get patch_missing_before_launching_description =>
      'This game has a patch available. Do you want to install it before launching the game?';

  @override
  String get patch_missing_before_launching_install => 'Install Patch';

  @override
  String get patch_missing_before_launching_launch => 'Launch Game';
}
