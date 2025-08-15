// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get page_continue => 'Fortsetzen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get quit => 'Beenden';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get ok => 'Okay';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Starte / Suche Spiele';

  @override
  String get patch_a_game => 'Patche ein Spiel';

  @override
  String get settings => 'Optionen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get installing_a_patch => 'Installiere einen Patch';

  @override
  String get installing_a_patch_description => 'Der Patch wird installiert.';

  @override
  String get installing_a_patch_end => 'Installation abgeschlossen';

  @override
  String get can_close_popup => 'Du kannst dieses Fenster nun schließen';

  @override
  String get patch_unavailable => 'Kein Patch verfügbar';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Patches installiert',
      one: 'Patch installiert',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Patches aktualisieren',
      one: 'Patch aktualisieren',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Patches installieren',
      one: 'Patch installieren',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Version entfernen';

  @override
  String get delete_version_description =>
      'Wenn du dein Spiel zurückgesetzt hast, kannst du die installierte Version dieses Spiels löschen. So kannst du die Patches erneut installieren.';

  @override
  String get description => 'Beschreibung';

  @override
  String get patch_modification => 'Patch-Modifizierung';

  @override
  String get patch_modification_description =>
      'Dieser Patch hat Einfluss auf folgende Inhalte:';

  @override
  String get patch_modification_content_text =>
      'Veränderung der Texte im Spiel';

  @override
  String get patch_modification_content_internal =>
      'Veränderung der internen Dateien des Spiels (Bilder, Texte...)';

  @override
  String get patch_modification_content_subtitles =>
      'Veränderung der Untertitel';

  @override
  String patch_modification_content_website(String website) {
    return 'Veränderung der Inhalte des Controllers (nur verfügbar auf $website)';
  }

  @override
  String get patch_modification_content_audios =>
      'Veränderung der Sprachausgabe des Spiels';

  @override
  String get version => 'Version';

  @override
  String get authors => 'Mitwirkende';

  @override
  String get small_information => 'Info';

  @override
  String get more_informations => 'Mehr Informationen';

  @override
  String get launch_game => 'Spiel starten';

  @override
  String get launch_game_fast_launcher => 'Spiel starten (Schnellstart)';

  @override
  String get launch_game_fast_launcher_description =>
      'Startet das Spiel im Schnellstart-Modus. Dadurch werden sowohl das Introvideo als auch die Spieleauswahl übersprungen. Nur für bestimmte Spiele verfügbar.';

  @override
  String get launch_pack => 'Pack starten';

  @override
  String get launch_pack_description => 'Startet das Party Pack normal';

  @override
  String get launch_informations => 'Startinformationen';

  @override
  String get launching => 'Starte…';

  @override
  String get launched => 'Gestartet!';

  @override
  String get path_not_found => 'Pfad nicht gefunden';

  @override
  String get path_not_found_small_description =>
      'Der Pfad zum Spiel wurde nicht gefunden.';

  @override
  String get path_not_found_description =>
      'Der Pfad zum Spiel wurde nicht gefunden. Bitte vergewissere dich, dass das Spiel installiert ist und der Pfad korrekt ist.';

  @override
  String get path_inexistant => 'Pfad existiert nicht';

  @override
  String get path_inexistant_small_description =>
      'Du hast den Pfad noch nicht zum Spiel hinzugefügt.';

  @override
  String get path_inexistant_description =>
      'Du hast den Pfad noch nicht zum Spiel hinzugefügt. Dies ist in den Optionen möglich.';

  @override
  String get pack_path => 'Spielpfad';

  @override
  String get owned_packs => 'Spiele im Besitz';

  @override
  String get add_pack => 'Spiel hinzufügen';

  @override
  String get choose_pack => 'Wähle ein Spiel';

  @override
  String get game_type_coop => 'Co-Op';

  @override
  String get game_type_coop_description =>
      'Bei diesen Spielen müssen die Spieler zusammenarbeiten, um zu gewinnen.';

  @override
  String get game_type_versus => 'Gegeneinander';

  @override
  String get game_type_versus_description =>
      'Bei diesen Spielen treten die Spieler gegeneinander an und versuchen, selber zu gewinnen.';

  @override
  String get game_type_team => 'Team';

  @override
  String get game_type_team_description =>
      'Bei diesen Spielen werden die Spieler in Teams aufgeteilt und müssen zusammenarbeiten, um zu gewinnen.';

  @override
  String game_translation_translated(String language) {
    return 'Offiziell übersetzt auf $language';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Diese Spiele haben eine offizielle Übersetzung auf $language';
  }

  @override
  String get game_translation_translated_description_en =>
      'Diese Spiele wurden von Jackbox Games ins Französische, Italienische, Deutsche und Spanische übersetzt.';

  @override
  String get game_translation_community_translated =>
      'Übersetzt von der Community';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Diese Spiele wurden von der Community übersetzt';
  }

  @override
  String get game_translation_not_available => 'Auf Englisch';

  @override
  String game_translation_not_available_description(String language) {
    return 'Diese Spiele wurden nicht auf $language übersetzt';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Diese Spiele sind nur auf Englisch verfügbar.';

  @override
  String get downloading => 'Downloade...';

  @override
  String get starting => 'Starte...';

  @override
  String get extracting => 'Entpacke Patch...';

  @override
  String get finalizing => 'Fast fertig...';

  @override
  String get unknown_error => 'Unbekannter Fehler';

  @override
  String get contact_error => 'Melde dich bitte bei Erizzle auf Discord';

  @override
  String get game_patch_unavailable => 'Patch nicht verfügbar';

  @override
  String get game_patch_available => 'Ein Patch ist verfügbar';

  @override
  String get game_patch_installed => 'Der Patch ist auf dem neusten Stand';

  @override
  String get game_patch_outdated => 'Für diesen Patch ist ein Update verfügbar';

  @override
  String get players => 'Spieler';

  @override
  String get search_game => 'Suche ein Spiel';

  @override
  String get search => 'Suche';

  @override
  String get all_games => 'Alle Spiele';

  @override
  String get all_games_description => 'Alle Jackbox-Spiele auf einen Blick';

  @override
  String get search_by_pack => 'Suche nach Pack';

  @override
  String get search_by_type => 'Suche nach Kategorie';

  @override
  String get search_by_translation => 'Suche nach Übersetzungsstatus';

  @override
  String get search_by_tags => 'Suche nach Tags';

  @override
  String get select_server_subtitle => 'Wähle einen der verfügbaren Server';

  @override
  String get select_server_loading => 'Lade Server…';

  @override
  String get select_server_button => 'Bestätigen';

  @override
  String connected_to_server(String server) {
    return 'Verbunden mit dem Server: $server';
  }

  @override
  String get connected_to_server_change => 'Ändern';

  @override
  String get connection_to_server_failed =>
      'Verbindung zum Server fehlgeschlagen';

  @override
  String get connection_to_main_server_failed =>
      'Aufgrund eines Fehlers konnten die verfügbaren Server nicht abgerufen werden.';

  @override
  String get quit_while_downloading_title => 'Ein Download ist aktiv';

  @override
  String get quit_while_downloading_description =>
      'Ein Download ist zurzeit aktiv. Bist du sicher, dass du die App schließen möchtest?';

  @override
  String get automatic_game_finder_title => 'Automatische Spiele-Erkennung';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility kann installierte Spiele über Steam und Epic Games automatisch für dich erkennen.\nMöchtest du diese Funktion nutzen?';

  @override
  String get automatic_game_finder_in_progress =>
      'Spiele werden abgerufen. Bitte warte kurz.';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele gefunden',
      one: '1 Spiel gefunden',
      zero: 'Kein Spiel gefunden',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Server gefunden';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'Der Server $server wurde basierend auf deiner Sprache ausgewählt';
  }

  @override
  String get show_all_packs => 'Alle Spiele anzeigen';

  @override
  String get show_owned_packs_only => 'Nur Spiele im Besitz anzeigen';

  @override
  String get all_patches => 'Alle Patches';

  @override
  String get error_happened => 'Ein Fehler ist aufgetreten';

  @override
  String get jackbox_utility_description =>
      'Eine Open-Source-App zum Herunterladen von Patches und Starten von Jackbox-Spielen';

  @override
  String get server_information => 'Server-Informationen (Sprache)';

  @override
  String get selected_server => 'Ausgewählter Server';

  @override
  String get change_server => 'Server ändern';

  @override
  String get app_information => 'App-Informationen';

  @override
  String get automatic_game_finder_button =>
      'Installierte Spiele automatisch erkennen';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele erkannt',
      one: '1 Spiel erkannt',
      zero: 'Kein Spiel erkannt',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Autor';

  @override
  String get contributors => 'Mitwirkende';

  @override
  String in_language(String language) {
    return 'Auf $language';
  }

  @override
  String in_language_description(String language) {
    return 'Diese Spiele sind auf $language verfügbar (nativ oder durch die Community)';
  }

  @override
  String get game_community_dubbed => 'Community-Synchro';

  @override
  String get game_community_dubbed_description =>
      'Diese Spiele wurden von der Community synchronisiert';

  @override
  String game_dubbed(String language) {
    return 'Mit deutscher Sprachausgabe';
  }

  @override
  String get game_dubbed_description =>
      'Diese Spiele wurden von der Community oder von Jackbox synchronisiert';

  @override
  String get no_game_in_this_category_title => 'Kein Spiel in dieser Kategorie';

  @override
  String get no_game_in_this_category_description =>
      'In dieser Kategorie besitzt du keine Spiele. Wenn du in den Einstellungen weitere hinzufügst, werden sie dir hier angezeigt.';

  @override
  String select_game_location(String game) {
    return 'Wähle den Speicherort von $game';
  }

  @override
  String get download_error => 'Fehler beim Herunterladen';

  @override
  String get download_error_description =>
      'Beim Herunterladen des Spiels ist ein Fehler aufgetreten. Bitte überprüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get extracting_error => 'Fehler beim Entpacken';

  @override
  String get extracting_error_description =>
      'Beim Entpacken des Spiels ist ein Fehler aufgetreten. Bitte überprüfe, ob du ausreichend freien Speicherplatz zur Verfügung hast und versuche es erneut.';

  @override
  String get game_reset => 'Übersetzung entfernen';

  @override
  String get game_reset_description =>
      'Dadurch wird dein Spiel vollständig zurückgesetzt. Wenn du einen Patch installiert haben solltest, wird dieser gelöscht. Bist du dir GANZ sicher, dass du fortfahren möchtest?';

  @override
  String get small_description => 'Beschreibung';

  @override
  String get patreon_subscribers => 'Patreon-Supporter';

  @override
  String get audience => 'Publikum';

  @override
  String get confirmation => 'Bestätigung';

  @override
  String confirmation_description(String action) {
    return 'Möchtest du wirklich $action? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get fix => 'Fix';

  @override
  String get fixes_available => 'Fixes verfügbar';

  @override
  String get fixes_available_description =>
      'Für deine Spiele sind mehrere Fixes zum Download verfügbar. Möchtest du sie jetzt herunterladen?';

  @override
  String get filter_players_number => 'Spieleranzahl';

  @override
  String get family_friendly => 'Familienfreundlich';

  @override
  String get optional => 'Optional';

  @override
  String get subtitles => 'Untertitel';

  @override
  String get stream_friendly => 'Streamtauglich';

  @override
  String get moderation => 'Moderation';

  @override
  String get randomize_button_text => 'Erneut versuchen';

  @override
  String get feeling_lucky => 'Auf gut Glück';

  @override
  String sort_by(String type) {
    return 'Sortieren nach $type';
  }

  @override
  String get filter => 'Filter';

  @override
  String get show_games_hidden => 'Zeige von dir ausgeblendete Spiele';

  @override
  String get hide_games_hidden => 'Verberge von dir ausgeblendete Spiele';

  @override
  String get max_playtime => 'Max. Spieldauer';

  @override
  String get search_by_ranking => 'Suche nach Ranking';

  @override
  String get random_game => 'Zufälliges Spiel';

  @override
  String get personal_ranking => 'Persönliches Ranking';

  @override
  String get ranked_by_stars => 'Sortiert nach Sternen';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Spiele sortiert nach deinem persönlichen Sterne-Ranking';

  @override
  String get unranked => 'Unsortiert';

  @override
  String get app_behavior => 'App-Verhalten';

  @override
  String get settings_app_startup_category => 'App-Start';

  @override
  String get settings_app_startup_title => 'Launcher beim App-Start öffnen';

  @override
  String get settings_app_startup_description =>
      'Beim Öffnen der App direkt in der Spieleliste starten';

  @override
  String get settings_discord_rich_presence_category =>
      'Einstellungen des Discord-Aktivitätsstatus';

  @override
  String get settings_discord_rich_presence_title => 'Discord-Aktivitätsstatus';

  @override
  String get settings_discord_rich_presence_description =>
      'Zeigt auf Discord, was du spielst. Funktioniert nur, wenn Discord geöffnet ist';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Support-Buttons anzeigen';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'In deinem Discord-Aktivitätsstatus Verlinkungen zur GitHub- und Discordpräsenz der App anzeigen.';

  @override
  String get settings_audio_category => 'Audio';

  @override
  String get settings_sfx_title => 'Soundeffekte';

  @override
  String get settings_sfx_description => 'Aktiviert Soundeffekte in der App';

  @override
  String get settings_app_saves_category => 'App-Speicherdaten';

  @override
  String get settings_app_reset_stars_title => 'Sterne zurücksetzen';

  @override
  String get settings_app_reset_stars_description =>
      'Setzt alle Sterne für jedes Spiel zurück';

  @override
  String get settings_app_reset_stars_button_text => 'Sterne zurücksetzen';

  @override
  String get settings_app_reset_stars_action =>
      'alle Sterne für jedes Spiel zurücksetzen';

  @override
  String get settings_app_reset_hidden_title =>
      'Ausgeblendete Spiele zurücksetzen';

  @override
  String get settings_app_reset_hidden_description =>
      'Setzt alle ausgeblendeten Spiele zurück auf sichtbar';

  @override
  String get settings_app_reset_hidden_button_text =>
      'Ausgeblendete Spiele zurücksetzen';

  @override
  String get settings_app_reset_hidden_action =>
      'alle ausgeblendeten Spiele zurücksetzen';

  @override
  String get rich_presence_application_start_details => 'Startet die App';

  @override
  String get rich_presence_application_start_state => 'Im Menü';

  @override
  String get rich_presence_game_menu_details => 'Wählt ein Spiel';

  @override
  String get rich_presence_game_menu_state => 'In der Spieleliste';

  @override
  String get rich_presence_game_information_details =>
      'Liest die Informationen eines Spiels';

  @override
  String get rich_presence_game_information_state => 'Wählt ein Spiel';

  @override
  String get rich_presence_patcher_details => 'Patcht ein Spiel';

  @override
  String get rich_presence_patcher_state => 'In der Patchliste';

  @override
  String get rich_presence_settings_details => 'In den Optionen';

  @override
  String get rich_presence_settings_state => 'In den Optionen';

  @override
  String get rich_presence_in_game_details => 'Im Spiel';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Launcher beim App-Start öffnen';

  @override
  String get open_launcher_on_startup_description_tip =>
      'Die App kann beim Öffnen automatisch auf diesem Bildschirm starten. Möchtest du diese Funktion aktivieren? (Dies kann jederzeit in den Optionen geändert werden.)';

  @override
  String get minutes => 'Minuten';

  @override
  String get translation => 'Übersetzungsstatus';

  @override
  String get using_beta_version_text =>
      'Du benutzt die Beta-Version dieser App. Sollten dir Fehler auffallen, melde sie bitte auf dem Discord-Server oder im GitHub-Repository.';

  @override
  String get pack => 'Pack';

  @override
  String get stars => 'Sternen';

  @override
  String get name => 'Name';

  @override
  String get players_number => 'Spieleranzahl';

  @override
  String get donate => 'Spenden';

  @override
  String get installed_version => 'Installierte Version';

  @override
  String get filter_available => 'Verfügbar';

  @override
  String get filter_fully_playable => 'Uneingeschränkt';

  @override
  String get filter_midly_playable => 'Bedingt';

  @override
  String get filter_playable => 'Spielbar';

  @override
  String get filter_full_moderation => 'Vollständige Moderation';

  @override
  String get filter_censoring => 'Zensur';

  @override
  String get filter_moderation_censoring => 'Moderation & Zensur';

  @override
  String get filter_dubbed => 'Sprachausgabe';

  @override
  String get filter_translated => 'Übersetzt';

  @override
  String get special_thanks => 'Besonderer Dank';

  @override
  String get stream_friendly_tooltip =>
      'Inwiefern dieses Spiel über einen Stream spielbar ist, bei dem der eigene Bildschirm über eine Streamingplattform oder Plattformen wie z.B. Discord, Zoom oder Meet übertragen wird.';

  @override
  String get family_friendly_tooltip =>
      'Inwiefern dieses Spiel mit der ganzen Familie (einschließlich Kindern) gespielt werden kann.';

  @override
  String get moderation_tooltip =>
      'Inwiefern dieses Spiel ein Moderationssystem hat (über das Spielereingaben auf dem Bildschirm akzeptiert, abgelehnt oder zensiert werden können).';

  @override
  String get audience_tooltip =>
      'Inwiefern dieses Spiel Publikumsmitgliedern (üblicherweise bis zu 10.000) erlaubt, nach dem Beitritt der Spieler mitzuspielen.';

  @override
  String get subtitles_tooltip =>
      'Ob das Spiel Untertitel hat, die auf dem Bildschirm angezeigt werden.';

  @override
  String get custom_server_title => 'Eigener Server';

  @override
  String get custom_server_description =>
      'Benutze deinen Link, um einen eigenen Server zu verbinden.';

  @override
  String get custom_server_explanation =>
      'Nutze einen Direktlink zur info.json-Datei deines eigenen Servers, um ihn zu verbinden.';

  @override
  String get custom_server_error =>
      'Der Server konnte nicht durch den Link hinzugefügt werden.';

  @override
  String get custom_server_warning =>
      'Sollte dich jemand gebeten haben, hier einen Link einzufügen, handelt es sich wahrscheinlich um einen böswilligen Angriff / Scam. Füge nur Server von vertrauenswürdigen Personen hinzu.';

  @override
  String get custom_server_add_question =>
      'Möchtest du diesen Server benutzen?';

  @override
  String get custom_server_link => 'Eigener Link zum Server';

  @override
  String get loading_initialization_failed =>
      'App konnte nicht gestartet werden.';

  @override
  String get loading_connection_failed =>
      'Die Verbindung zum Server ist fehlgeschlagen.';

  @override
  String get loading_save_failed =>
      'Deine Speicherdaten konnten nicht gelesen werden.';

  @override
  String get loading_open_issue_discord =>
      'Bitte melde diesen Fehler auf Discord oder GitHub.';

  @override
  String get loading_check_internet_connection =>
      'Bitte überprüfe deine Internetverbindung und versuche es nochmal.';

  @override
  String get loading_try_again => 'Nochmal versuchen';

  @override
  String get settings_anonymous_data_title =>
      'Anonymisierte Nutzerdaten-Erfassung';

  @override
  String get settings_anonymous_data_description =>
      'Unterstütze uns durch Sendung anonymisierter Nutzerdaten bei der Verbesserung der App';

  @override
  String get privacy_info => 'Datenschutz-Hinweis';

  @override
  String get privacy_description =>
      'Diese App sammelt anonymisierte Nutzerdaten zur Verbesserung der App. Dies kannst du jederzeit in den Optionen deaktivieren.';

  @override
  String get hidden_button_tooltip =>
      'Klicke, um dieses Spiel aus der Spieleliste auszublenden.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Klicke, um dieses Spiel in der Spieleliste wieder anzuzeigen.';

  @override
  String get patch_missing_before_launching_title => 'Kein Patch installiert';

  @override
  String get patch_missing_before_launching_description =>
      'Für dieses Spiel ist ein Patch verfügbar. Möchtest du ihn installieren, bevor du es startest?';

  @override
  String get patch_missing_before_launching_install => 'Patch installieren';

  @override
  String get patch_missing_before_launching_launch => 'Spiel starten';
}
