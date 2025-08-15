// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get close => 'Zamknij';

  @override
  String get cancel => 'Anuluj';

  @override
  String get page_continue => 'Kontynuuj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get quit => 'Wyjdź';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get ok => 'OK';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Uruchom/ Wyszukaj gry';

  @override
  String get patch_a_game => 'Dodaj patch\'a do gry';

  @override
  String get settings => 'Ustawienia';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get installing_a_patch => 'Instalowanie łatki';

  @override
  String get installing_a_patch_description =>
      'Za chwilę pobierzesz łatkę. Ta akcja jest nieodwracalna.';

  @override
  String get installing_a_patch_end => 'Instalacja ukończona';

  @override
  String get can_close_popup => 'Możesz zamknąć te okienko';

  @override
  String get patch_unavailable => 'Łatka nie jest Dostępna';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Łatki zainstalowane',
      one: 'Łatka zainstalowana',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zaktualizuj łatki',
      one: 'Zaktualizuj łatkę',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zainstaluj łatki',
      one: 'Zainstaluj łatkę',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Usuwanie wersji';

  @override
  String get delete_version_description =>
      'Jeśli zresetujesz grę, możesz usunąć zainstalowaną jej wersję. W ten sposób możesz ponownie zainstalować łatki.';

  @override
  String get description => 'Opis';

  @override
  String get patch_modification => 'Modyfikowanie łatki';

  @override
  String get patch_modification_description =>
      'Ta łatka zmienia grę w następujący sposób:';

  @override
  String get patch_modification_content_text => 'Zmiana tekstu wewnątrz gry';

  @override
  String get patch_modification_content_internal =>
      'Zmiana wewnętrznych plików gry (zdjęcia, teksty...)';

  @override
  String get patch_modification_content_subtitles => 'Zmiana napisów';

  @override
  String patch_modification_content_website(String website) {
    return 'Zmiana tekstu wewnątrz klienta Jackbox (tylko dostępne na $website)';
  }

  @override
  String get patch_modification_content_audios => 'Zmiana tekstu mówionego';

  @override
  String get version => 'Wersja';

  @override
  String get authors => 'Autorzy';

  @override
  String get small_information => 'Informacje';

  @override
  String get more_informations => 'Więcej informacji';

  @override
  String get launch_game => 'Uruchom Grę';

  @override
  String get launch_game_fast_launcher => 'Uruchom grę (Szybki start)';

  @override
  String get launch_game_fast_launcher_description =>
      'Uruchamia grę w trybie szybkiego uruchamiania, pozwalając na pominięcie całej czołówki paczki oraz wyboru gry. Jest to dostępne tylko w niektórych grach.';

  @override
  String get launch_pack => 'Uruchom Paczkę';

  @override
  String get launch_pack_description => 'Uruchamia grę normalnie';

  @override
  String get launch_informations => 'Informacje dot. uruchomienia';

  @override
  String get launching => 'Uruchamianie…';

  @override
  String get launched => 'Uruchomiono!';

  @override
  String get path_not_found => 'Nie znaleziono ścieżki';

  @override
  String get path_not_found_small_description =>
      'Ścieżka gry nie została znaleziona.';

  @override
  String get path_not_found_description =>
      'Ścieżka gry nie została znaleziona. Sprawdź, czy gra jest zainstalowana- oraz czy ścieżka jest poprawna.';

  @override
  String get path_inexistant => 'Ścieżka nie istnieje';

  @override
  String get path_inexistant_small_description =>
      'Nie dodałeś/-aś ścieżki do tej paczki.';

  @override
  String get path_inexistant_description =>
      'Nie dodałeś/-aś ścieżki do tej paczki. Możesz to zrobić w ustawieniach.';

  @override
  String get pack_path => 'Ścieżka gry';

  @override
  String get owned_packs => 'Posiadane gry';

  @override
  String get add_pack => 'Dodaj grę';

  @override
  String get choose_pack => 'Wybierz grę';

  @override
  String get game_type_coop => 'Kooperacyjne';

  @override
  String get game_type_coop_description =>
      'W tych grach gracze muszą pracować razem, by wygrać.';

  @override
  String get game_type_versus => 'Każdy przeciwko każdemu';

  @override
  String get game_type_versus_description =>
      'W tych grach każdy gra na swój rachunek i musi ograć pozostałych graczy.';

  @override
  String get game_type_team => 'Drużynowe';

  @override
  String get game_type_team_description =>
      'W tych grach gracze są podzieleni na drużyny i muszą współpracować, aby wygrać.';

  @override
  String game_translation_translated(String language) {
    return 'Oficjalnie przetłumaczone na $language';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Te gry są natywnie dostępne w $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Te gry zostały przetłumaczone na francuski, włoski, niemiecki i hiszpański przez Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Przetłumaczone przez społeczność';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Te gry zostały przetłumaczone przez społeczność.';
  }

  @override
  String get game_translation_not_available => 'Po angielsku';

  @override
  String game_translation_not_available_description(String language) {
    return 'Te gry nie są przetłumaczone na $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Te gry są dostępne tylko w języku angielskim.';

  @override
  String get downloading => 'Pobieranie';

  @override
  String get starting => 'Rozpoczęcie';

  @override
  String get extracting => 'Wypakowywanie';

  @override
  String get finalizing => 'Kończenie';

  @override
  String get unknown_error => 'Nieznany błąd';

  @override
  String get contact_error =>
      'Skontaktuj się z użytkownikiem marek na Discordzie';

  @override
  String get game_patch_unavailable => 'Łatka nie jest dostępna';

  @override
  String get game_patch_available => 'Łatka jest dostępna';

  @override
  String get game_patch_installed => 'Ta łapka jest aktualna';

  @override
  String get game_patch_outdated => 'Dla tej łatki dostępna jest aktualizacja';

  @override
  String get players => 'gracze';

  @override
  String get search_game => 'Szukaj gry';

  @override
  String get search => 'Szukaj';

  @override
  String get all_games => 'Wszystkie gry';

  @override
  String get all_games_description => 'Wszystkie gry Jackbox w jednym miejscu.';

  @override
  String get search_by_pack => 'Szukaj według paczki';

  @override
  String get search_by_type => 'Szukaj według typu';

  @override
  String get search_by_translation => 'Szukaj według statusu tłumaczenia';

  @override
  String get search_by_tags => 'Szukaj według etykiet';

  @override
  String get select_server_subtitle => 'Wybierz jeden z dostępnych serwerów';

  @override
  String get select_server_loading => 'Ładuję serwery…';

  @override
  String get select_server_button => 'Wybierz';

  @override
  String connected_to_server(String server) {
    return 'Połączono z serwerem $server';
  }

  @override
  String get connected_to_server_change => 'Zmień';

  @override
  String get connection_to_server_failed => 'Nie udało się połączyć z serwerem';

  @override
  String get connection_to_main_server_failed =>
      'Błąd podczas pozyskiwania dostępnych serwerów.';

  @override
  String get quit_while_downloading_title => 'Pobieranie w toku';

  @override
  String get quit_while_downloading_description =>
      'Pobieranie jest w trakcie. Na pewno chcesz teraz wyjść?';

  @override
  String get automatic_game_finder_title => 'Znajdź gry automatycznie';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility może automatycznie wykryć zainstalowane gry na tym komputerze z Steam i Epic Games.\nCzy chcesz skorzystać z tej usługi?';

  @override
  String get automatic_game_finder_in_progress =>
      'Pobieranie gier, proszę czekać';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count gier',
      one: 'Znaleziono 1 grę',
      zero: 'Nie znaleziono żadnych gier',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Znaleziono serwer';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'Serwer $server został wybrany na podstawie twojego języka.';
  }

  @override
  String get show_all_packs => 'Pokaż gry, których nie posiadasz';

  @override
  String get show_owned_packs_only => 'Pokaż tylko posiadane gry';

  @override
  String get all_patches => 'Wszystkie łatki';

  @override
  String get error_happened => 'Wystąpił błąd';

  @override
  String get jackbox_utility_description =>
      'Aplikacja open-source do pobierania łatek i uruchamiania gier Jackbox.';

  @override
  String get server_information => 'Informacje dot. serwera (Język)';

  @override
  String get selected_server => 'Wybrany serwer';

  @override
  String get change_server => 'Zmień serwer';

  @override
  String get app_information => 'Informacje o aplikacji';

  @override
  String get automatic_game_finder_button =>
      'Automatycznie wykryj zainstalowane gry';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dostępne gry',
      one: '1 dostępna gra',
      zero: 'Brak dostępnych gier',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Autor';

  @override
  String get contributors => 'Współtwórcy';

  @override
  String in_language(String language) {
    return 'Po $language';
  }

  @override
  String in_language_description(String language) {
    return 'Te gry są dostępne w $language (albo naturalnie, albo poprzez tłumaczenie społeczności.)';
  }

  @override
  String get game_community_dubbed => 'Z dubbingiem społeczności';

  @override
  String get game_community_dubbed_description =>
      'Te gry mają dubbing zaproponowany przez społeczność.';

  @override
  String game_dubbed(String language) {
    return 'Z dubbingiem w $language';
  }

  @override
  String get game_dubbed_description =>
      'Te gry mają dubbing od społeczności albo od Jackbox.';

  @override
  String get no_game_in_this_category_title =>
      'W tej kategorii nie ma żadnej gry';

  @override
  String get no_game_in_this_category_description =>
      'W tej kategorii nie ma gier. Spróbuj dodać ich więcej w sekcji Ustawień.';

  @override
  String select_game_location(String game) {
    return 'Wybierz lokalizację $game';
  }

  @override
  String get download_error => 'Błąd podczas pobierania';

  @override
  String get download_error_description =>
      'Podczas pobierania gry wystąpił błąd. Sprawdź połączenie z Internetem i spróbuj ponownie.';

  @override
  String get extracting_error => 'Błąd podczas wyodrębniania';

  @override
  String get extracting_error_description =>
      'Podczas wyodrębniania gry wystąpił błąd. Sprawdź dostępne miejsce i spróbuj ponownie.';

  @override
  String get game_reset => 'Zresetuj grę';

  @override
  String get game_reset_description =>
      'Ten proces zweryfikuje wszystkie pliki gry. Jeśli zainstalowałeś/-aś jakieś łatki, zostaną one usunięte. Na pewno chcesz kontynuować?';

  @override
  String get small_description => 'Opis';

  @override
  String get patreon_subscribers => 'Subskrybenci z Patreona';

  @override
  String get audience => 'Publiczność';

  @override
  String get confirmation => 'Potwierdzenie';

  @override
  String confirmation_description(String action) {
    return 'Na pewno chcesz $action? Tej czynności nie da się cofnąć.';
  }

  @override
  String get fix => 'Napraw';

  @override
  String get fixes_available => 'Dostępny fix';

  @override
  String get fixes_available_description =>
      'Dla tej gry są dostępne pliki naprawcze. Czy chcesz je zainstalować? Zawsze możesz je zainstalować z odpowiedniej zakładki gry.';

  @override
  String get filter_players_number => 'Liczba graczy';

  @override
  String get family_friendly => 'Dla wszystkich';

  @override
  String get optional => 'Opcjonalne';

  @override
  String get subtitles => 'Napisy';

  @override
  String get stream_friendly => 'Możliwe do streamowania';

  @override
  String get moderation => 'Moderacja';

  @override
  String get randomize_button_text => 'Spróbujmy jakąś inną!';

  @override
  String get feeling_lucky => 'Szczęśliwy traf';

  @override
  String sort_by(String type) {
    return 'Sortuj według $type';
  }

  @override
  String get filter => 'Filtruj';

  @override
  String get show_games_hidden => 'Pokaż ukryte gry';

  @override
  String get hide_games_hidden => 'Ukryj ukryte gry';

  @override
  String get max_playtime => 'Maksymalny czas gry';

  @override
  String get search_by_ranking => 'Szukaj według rankingu';

  @override
  String get random_game => 'Dowolna gra';

  @override
  String get personal_ranking => 'Osobisty ranking';

  @override
  String get ranked_by_stars => 'Sortuj według gwiazdek';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Gry posortowane według gwiazdek z Twojego osobistego rankingu.';

  @override
  String get unranked => 'Niesklasyfikowane';

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
  String get settings_sfx_title => 'Uruchom dźwięki';

  @override
  String get settings_sfx_description => 'Uruchamia dźwięki w aplikacji.';

  @override
  String get settings_app_saves_category => 'App Saves';

  @override
  String get settings_app_reset_stars_title => 'Zresetuj gwiazdki';

  @override
  String get settings_app_reset_stars_description =>
      'Resets all the stars for each game.';

  @override
  String get settings_app_reset_stars_button_text => 'Zresetuj gwiazdki';

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
  String get rich_presence_application_start_state => 'W Menu';

  @override
  String get rich_presence_game_menu_details => 'Wybór Gry';

  @override
  String get rich_presence_game_menu_state => 'In the Games List';

  @override
  String get rich_presence_game_information_details =>
      'Reading the Information of a Game';

  @override
  String get rich_presence_game_information_state => 'Wybór Gry';

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
  String get stars => 'Gwiazdki';

  @override
  String get name => 'Nazwa';

  @override
  String get players_number => 'Liczba graczy';

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
  String get patch_missing_before_launching_launch => 'Uruchom Grę';
}
