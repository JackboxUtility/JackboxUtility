// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get close => 'Tancar';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get page_continue => 'Continuar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get quit => 'Sortir';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'Ok';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Executar / Cercar Jocs';

  @override
  String get patch_a_game => 'Traduir Jocs';

  @override
  String get settings => 'Opcions';

  @override
  String get notifications => 'Notificacions';

  @override
  String get installing_a_patch => 'Instal·lant traducció';

  @override
  String get installing_a_patch_description =>
      'Instal·laràs la traducció. Aquesta acció és irreversible.';

  @override
  String get installing_a_patch_end => 'Instal·lació completada';

  @override
  String get thank_the_team_button => 'Agraeix a l\'equip';

  @override
  String get thank_the_team_description =>
      'Agradeix a l\'equip per la traducció';

  @override
  String get can_close_popup => 'Pots tancar aquesta finestra';

  @override
  String get patch_unavailable => 'Traducció no disponible';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Traduccions instal·lades',
      one: 'Traducció instal·lada',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Actualitzar traduccions',
      one: 'Actualitzar traducció',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Instal·lar traduccions',
      one: 'Instal·lar traducció',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Eliminar traducció';

  @override
  String get delete_version_description =>
      'Elimina les traduccions instal·lades al joc.';

  @override
  String get description => 'Descripció';

  @override
  String get patch_modification => 'Informació de la traducció';

  @override
  String get patch_modification_description =>
      'Aquesta traducció altera el joc de la següent manera:';

  @override
  String get patch_modification_content_text =>
      'Tradueix el contingut textual del joc';

  @override
  String get patch_modification_content_internal =>
      'Tradueix els arxius interns del joc (imatges, textos secundaris, etc.)';

  @override
  String get patch_modification_content_subtitles =>
      'Tradueix els subtítols del joc';

  @override
  String patch_modification_content_website(String website) {
    return 'Tradueix el contingut del dispositiu (només disponible a $website)';
  }

  @override
  String get patch_modification_content_audios =>
      'Tradueix el doblatge del joc';

  @override
  String get version => 'Versió:';

  @override
  String get authors => 'Crèdits';

  @override
  String get small_information => 'Info';

  @override
  String get more_informations => 'Més Informació';

  @override
  String get launch_game => 'Jugar';

  @override
  String get launch_game_fast_launcher => 'Jugar (Llançament Ràpid)';

  @override
  String get launch_game_fast_launcher_description =>
      'Executa el joc ràpidament, ometent el vídeo introductori del pack i el menú principal. Només disponible en alguns jocs.';

  @override
  String get launch_pack => 'Jugar';

  @override
  String get launch_pack_description => 'Executa el joc de manera normal';

  @override
  String get launch_informations => 'Informació d\'Execució';

  @override
  String get launching => 'Executant...';

  @override
  String get launched => 'Executat!';

  @override
  String get path_not_found => 'Fitxers No Trobats';

  @override
  String get path_not_found_small_description =>
      'No s\'han trobat els fitxers del joc.';

  @override
  String get path_not_found_description =>
      'No s\'han trobat els fitxers del joc. Comprova que el joc estigui instal·lat i que la ruta sigui correcta.';

  @override
  String get path_inexistant => 'Ruta Inexistent';

  @override
  String get path_inexistant_small_description =>
      'No s\'ha afegit la ruta del joc.';

  @override
  String get path_inexistant_description =>
      'No s\'ha afegit la ruta del joc. Pots fer-ho a les Opcions.';

  @override
  String get pack_path => 'Ruta del joc';

  @override
  String get owned_packs => 'Jocs en propietat';

  @override
  String get add_pack => 'Afegir un Joc';

  @override
  String get choose_pack => 'Escollir un Joc';

  @override
  String get game_type_coop => 'Coop';

  @override
  String get game_type_coop_description =>
      'En aquests jocs, els jugadors han de treballar plegats per guanyar.';

  @override
  String get game_type_versus => 'Todos contra todos';

  @override
  String get game_type_versus_description =>
      'En aquests jocs, cada jugador juga individualment i ha de vèncer als altres jugadors.';

  @override
  String get game_type_team => 'Equipos';

  @override
  String get game_type_team_description =>
      'En aquests jocs, els jugadors es divideixen en equips i han de treballar plegats per guanyar l\'equip rival.';

  @override
  String game_translation_translated(String language) {
    return 'Traduït oficialment';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Aquests jocs estan traduïts de manera oficial a $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Aquests jocs estan traduïts al Francès, Italià, Alemany i Espanyol per Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Traduït per la comunitat';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Aquests jocs estan traduïts voluntariament per la comunitat.';
  }

  @override
  String get game_translation_not_available => 'En Anglès';

  @override
  String game_translation_not_available_description(String language) {
    return 'Aquests jocs no estan traduïts a $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Aquests jocs només estan disponibles en Anglès.';

  @override
  String get downloading => 'Descarregant';

  @override
  String get starting => 'Començant';

  @override
  String get extracting => 'Descomprimint';

  @override
  String get finalizing => 'Finalitzant';

  @override
  String get unknown_error => 'Error desconegut';

  @override
  String get contact_error =>
      'Posa\'t en contacte amb un administrador al servidor de Discord de Jackbox Utility';

  @override
  String get game_patch_unavailable => 'Traducció no disponible';

  @override
  String get game_patch_available => 'Traducció disponible';

  @override
  String get game_patch_installed => 'Aquesta traducció està actualitzada';

  @override
  String get game_patch_outdated =>
      'Hi ha una actualització disponible per a aquesta traducció';

  @override
  String get players => 'jugadors';

  @override
  String get search_game => 'Cercar un joc';

  @override
  String get search => 'Cercar';

  @override
  String get all_games => 'Tots els jocs';

  @override
  String get all_games_description =>
      'Tots els jocs de Jackbox en un sol lloc.';

  @override
  String get search_by_pack => 'Cercar per Pack';

  @override
  String get search_by_type => 'Cercar per Tipus';

  @override
  String get search_by_translation => 'Cercar per Traducció';

  @override
  String get search_by_tags => 'Cercar per Etiquetes';

  @override
  String get select_server_subtitle =>
      'Sel·lecciona un dels servidors disponibles';

  @override
  String get select_server_loading => 'Carregant Servidors...';

  @override
  String get select_server_button => 'Sel·leccionar';

  @override
  String connected_to_server(String server) {
    return 'Connectat al servidor de $server';
  }

  @override
  String get connected_to_server_change => 'Canviar';

  @override
  String get connection_to_server_failed =>
      'La Connexió amb el Servidor ha Fallat';

  @override
  String get connection_to_main_server_failed =>
      'Hi ha hagut un error llistant els servidors disponibles.';

  @override
  String get quit_while_downloading_title => 'Descàrrega en Curs';

  @override
  String get quit_while_downloading_description =>
      'Hi ha una descàrrega en curs. Segur que vols sortir?';

  @override
  String get automatic_game_finder_title => 'Cercador Automàtic de Jocs';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility pot detectar els jocs instal·lats des de Steam i Epic Games d\'aquest ordinador.\nVols activar aquesta funció?';

  @override
  String get automatic_game_finder_in_progress => 'Detectant jocs...';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'S\'han trobat $count jocs',
      one: 'S\'ha trobat 1 joc',
      zero: 'No s\'ha trobat cap joc',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Servidor Escollit';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'El servidor $server s\'ha escollit en funció del teu idioma';
  }

  @override
  String get show_all_packs => 'Mostrar tots els jocs';

  @override
  String get show_owned_packs_only => 'Mostrar només jocs en propietat';

  @override
  String get all_patches => 'Totes les traduccions';

  @override
  String get error_happened => 'Hi ha hagut un error';

  @override
  String get jackbox_utility_description =>
      'Una aplicació de codi obert per modificar i executar els jocs de Jackbox.';

  @override
  String get server_information => 'Informació del Servidor';

  @override
  String get selected_server => 'Servidor Escollit';

  @override
  String get change_server => 'Canviar Servidor';

  @override
  String get app_information => 'Informació de l\'Aplicació';

  @override
  String get automatic_game_finder_button => 'Detectar jocs instal·lats';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jocs disponibles',
      one: '1 joc disponible',
      zero: 'No hi ha cap joc disponible',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Autor';

  @override
  String get contributors => 'Col·laboradors';

  @override
  String in_language(String language) {
    return 'En $language';
  }

  @override
  String in_language_description(String language) {
    return 'Aquests jocs estan disponibles en $language (oficialment o traduïts per la comunitat).';
  }

  @override
  String get game_community_dubbed => 'Doblat per la comunitat';

  @override
  String get game_community_dubbed_description =>
      'Aquests jocs estan doblats per la comunitat.';

  @override
  String game_dubbed(String language) {
    return 'Doblat a $language';
  }

  @override
  String get game_dubbed_description =>
      'Aquests jocs estan doblats de manera oficial o per la comunitat.';

  @override
  String get no_game_in_this_category_title =>
      'No hi ha jocs en aquesta categoria';

  @override
  String get no_game_in_this_category_description =>
      'No hi ha jocs en aquesta categoria. Prova a afegir-ne més des de les Opcions.';

  @override
  String select_game_location(String game) {
    return 'Escull la ubicació de $game';
  }

  @override
  String get download_error => 'Error de descàrrega';

  @override
  String get download_error_description =>
      'Hi ha hagut un error descarregant la traducció. Comprova la teva connexió a Internet i torna-ho a intentar.';

  @override
  String get extracting_error => 'Error de descompressió';

  @override
  String get extracting_error_description =>
      'Hi ha hagut un error descomprimint el joc. Comprova si tens suficient espai d\'emmagatzematge lliure i torna-ho a intentar.';

  @override
  String get game_reset => 'Restaurar Joc';

  @override
  String get game_reset_description =>
      'Això validarà tots els arxius del joc. Qualsevol traducció instal·lada s\'eliminarà del joc. Segur que vols continuar?';

  @override
  String get small_description => 'Descripció';

  @override
  String get patreon_subscribers => 'Subscriptors de Patreon';

  @override
  String get audience => 'Audiència';

  @override
  String get confirmation => 'Confirmació';

  @override
  String confirmation_description(String action) {
    return 'Segur que vols $action? Aquesta acció no es pot desfer.';
  }

  @override
  String get fix => 'Millores';

  @override
  String get fixes_available => 'Millores disponibles';

  @override
  String get fixes_available_description =>
      'Hi ha algunes millores dels teus jocs disponibles. Vols descarregar-les ara?';

  @override
  String get filter_players_number => 'Nombre de Jugadors';

  @override
  String get family_friendly => 'Per a tota la família';

  @override
  String get optional => 'Opcional';

  @override
  String get subtitles => 'Subtítols';

  @override
  String get stream_friendly => 'Apte per a streaming';

  @override
  String get moderation => 'Moderació';

  @override
  String get randomize_button_text => 'Provem-ne un altre!';

  @override
  String get feeling_lucky => 'Em sento afortunat';

  @override
  String sort_by(String type) {
    return 'Ordenar per $type';
  }

  @override
  String get filter => 'Filtre';

  @override
  String get show_games_hidden => 'Mostrar jocs que has ocultat';

  @override
  String get hide_games_hidden => 'Ocultar jocs que has ocultat';

  @override
  String get max_playtime => 'Temps màxim de joc';

  @override
  String get search_by_ranking => 'Cercar per Puntuació';

  @override
  String get random_game => 'Joc Aleatori';

  @override
  String get personal_ranking => 'Puntuació Personal';

  @override
  String get ranked_by_stars => 'Classificat per Estrelles';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Jocs classificats per estrelles segons la teva puntuació personal.';

  @override
  String get unranked => 'Sense Puntuar';

  @override
  String get app_behavior => 'Comportament de l\'Aplicació';

  @override
  String get settings_app_startup_category => 'Inici de l\'Aplicació';

  @override
  String get settings_app_startup_title =>
      'Obrir el llançador a l\'iniciar l\'aplicació';

  @override
  String get settings_app_startup_description =>
      'Mostra la llista de jocs quan obris l\'aplicació.';

  @override
  String get settings_discord_rich_presence_category =>
      'Opcions del Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Mostra a què estàs jugant a Discord. Això només funcionarà quan Discord estigui obert.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Mostrar botons de suport';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Mostra els botons d\'enllaç al nostre GitHub i Discord en el teu estat de Discord.';

  @override
  String get settings_audio_category => 'Audio';

  @override
  String get settings_sfx_title => 'Activar efectes de so';

  @override
  String get settings_sfx_description =>
      'Activa els efectes de so de l\'aplicació.';

  @override
  String get settings_app_saves_category => 'Dades de l\'Aplicació';

  @override
  String get settings_app_reset_stars_title => 'Esborrar estrelles';

  @override
  String get settings_app_reset_stars_description =>
      'Restableix les estrelles de cada joc.';

  @override
  String get settings_app_reset_stars_button_text => 'Esborrar estrelles';

  @override
  String get settings_app_reset_stars_action =>
      'esborrar totes les estrelles de cada joc';

  @override
  String get settings_app_reset_hidden_title => 'Esborrar jocs ocults';

  @override
  String get settings_app_reset_hidden_description =>
      'Restableix tots els jocs ocults a visibles.';

  @override
  String get settings_app_reset_hidden_button_text => 'Esborrar jocs ocults';

  @override
  String get settings_app_reset_hidden_action =>
      'restablir tots els jocs ocults a visibles';

  @override
  String get rich_presence_application_start_details =>
      'Acaba d\'Iniciar l\'Aplicació';

  @override
  String get rich_presence_application_start_state => 'Al Menú';

  @override
  String get rich_presence_game_menu_details => 'Escollint un Joc';

  @override
  String get rich_presence_game_menu_state => 'A la Llista de Jocs';

  @override
  String get rich_presence_game_information_details =>
      'Llegint la Informació d\'un Joc';

  @override
  String get rich_presence_game_information_state => 'Escollint un Joc';

  @override
  String get rich_presence_patcher_details => 'Traduint un Joc';

  @override
  String get rich_presence_patcher_state => 'A la Llista de Traduccions';

  @override
  String get rich_presence_settings_details => 'Configurant l\'Aplicació';

  @override
  String get rich_presence_settings_state => 'A les Opcions';

  @override
  String get rich_presence_in_game_details => 'Jugant';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Obrir el llançador a l\'iniciar';

  @override
  String get open_launcher_on_startup_description_tip =>
      'L\'aplicació es pot obrir en aquesta pantalla quan s\'obri automàticament. Vols activar aquesta funció? (Es pot desactivar en qualsevol moment des de les Opcions).';

  @override
  String get minutes => 'minuts';

  @override
  String get translation => 'Traducció';

  @override
  String get using_beta_version_text =>
      'Estàs utilitzant la versió beta de l\'aplicació. Si trobes algun problema, avisa\'ns a través del servidor de Discord o el repositori de GitHub.';

  @override
  String get pack => 'Pack';

  @override
  String get stars => 'Estrelles';

  @override
  String get name => 'Nom';

  @override
  String get players_number => 'Nombre de jugadors';

  @override
  String get donate => 'Donar';

  @override
  String get installed_version => 'Versió Instal·lada';

  @override
  String get filter_available => 'Disponible';

  @override
  String get filter_fully_playable => 'Perfecte';

  @override
  String get filter_midly_playable => 'Decent';

  @override
  String get filter_playable => 'Jugable';

  @override
  String get filter_full_moderation => 'Moderació Completa';

  @override
  String get filter_censoring => 'Censura';

  @override
  String get filter_moderation_censoring => 'Mod. i Censura';

  @override
  String get filter_dubbed => 'Doblat';

  @override
  String get filter_translated => 'Traduït';

  @override
  String get special_thanks => 'Agraïments especials';

  @override
  String get stream_friendly_tooltip =>
      'Si pots jugar a aquest joc a través d\'Internet, ja sigui en una plataforma de streaming o compartint la teva pantalla a través de Discord, Meet, Zoom, etc.';

  @override
  String get family_friendly_tooltip =>
      'Si aquest joc és apte per a tota la família (nens inclosos).';

  @override
  String get moderation_tooltip =>
      'Si aquest joc té un sistema de moderació (per acceptar, refusar o censurar el que els jugadors envien a la pantalla).';

  @override
  String get audience_tooltip =>
      'Si aquest joc admet que pugui jugar una audiència (de fins a 10.000 persones si no s\'indica el contrari) que s\'uneix un cop hagin entrat tots els jugadors.';

  @override
  String get subtitles_tooltip =>
      'Si aquest joc té la narració subtitulada en pantalla.';

  @override
  String get custom_server_title => 'Servidor Personalitzat';

  @override
  String get custom_server_description =>
      'Fes servir un enllaç per connectar-te a un servidor personalitzat.';

  @override
  String get custom_server_explanation =>
      'Fes servir un enllaç al fitxer info.json d\'un servidor personalitzat per connectar-t\'hi.';

  @override
  String get custom_server_error =>
      'No s\'ha trobat cap servidor amb aquest enllaç.';

  @override
  String get custom_server_warning =>
      'Si algú t\'ha demanat de posar un enllaç aquí, és probable que sigui una estafa. No continuis si no confies amb l\'autor d\'aquest servidor.';

  @override
  String get custom_server_add_question => 'Vols fer servir aquest servidor?';

  @override
  String get custom_server_link => 'Enllaç del servidor personalitzat';

  @override
  String get loading_initialization_failed =>
      'Hi ha hagut un error iniciant l\'aplicació.';

  @override
  String get loading_connection_failed =>
      'Hi ha hagut un error de connexió amb el servidor.';

  @override
  String get loading_save_failed =>
      'Hi ha hagut un error recuperant les dades desades.';

  @override
  String get loading_open_issue_discord =>
      'Si us plau, obre un Issue de Github o avisa del problema al servidor de Discord.';

  @override
  String get loading_check_internet_connection =>
      'Comprova la teva connexió a Internet i torna-ho a intentar.';

  @override
  String get loading_try_again => 'Torna-ho a intentar';

  @override
  String get settings_anonymous_data_title => 'Recopilació de dades anònimes';

  @override
  String get settings_anonymous_data_description =>
      'Ajuda\'ns a millorar l\'app enviant-nos dades anònimes d\'ús.';

  @override
  String get privacy_info => 'Avís de privacitat';

  @override
  String get privacy_description =>
      'Aquesta app recopila dades anònimes per millorar el seu funcionament. Pots desactivar-ho a les opcions.';

  @override
  String get hidden_button_tooltip =>
      'Fes clic per amagar aquest joc de la llista de jocs.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Fes clic per mostrar aquest joc a la llista de jocs.';

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
