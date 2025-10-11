// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get page_continue => 'Continuar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get quit => 'Salir';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'Ok';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Ejecutar / Buscar juegos';

  @override
  String get patch_a_game => 'Parchear juegos';

  @override
  String get settings => 'Ajustes';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get installing_a_patch => 'Instalando parche';

  @override
  String get installing_a_patch_description =>
      'Instalarás el parche. Esta acción es irreversible.';

  @override
  String get installing_a_patch_end => 'Instalación completada';

  @override
  String get thank_the_team_button => 'Agradecer al equipo';

  @override
  String get thank_the_team_description =>
      'Agradece al equipo por la traducción';

  @override
  String get can_close_popup => 'Ya puedes cerrar esta ventana';

  @override
  String get patch_unavailable => 'Parche no disponible';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Parches instalados',
      one: 'Parche instalado',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Actualizar parches',
      one: 'Actualizar parche',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Instalar parches',
      one: 'Instalar parche',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Borrar parche';

  @override
  String get delete_version_description =>
      'Si deseas que este juego vuelva a estar en inglés, esto lo restaurará a como estaba antes.';

  @override
  String get description => 'Descripción';

  @override
  String get patch_modification => 'Modificación del parche';

  @override
  String get patch_modification_description =>
      'Este parche traduce el juego de la siguiente manera:';

  @override
  String get patch_modification_content_text =>
      'Traduce el contenido textual del juego.';

  @override
  String get patch_modification_content_internal =>
      'Traduce los archivos internos del juego (imágenes, textos secundarios, etc.)';

  @override
  String get patch_modification_content_subtitles =>
      'Traduce los subtítulos del juego';

  @override
  String patch_modification_content_website(String website) {
    return 'Traduce el contenido del dispositivo (solo disponible en $website)';
  }

  @override
  String get patch_modification_content_audios => 'Posee un doblaje completo.';

  @override
  String get version => 'Versión:';

  @override
  String get authors => 'Créditos';

  @override
  String get small_information => 'Info';

  @override
  String get more_informations => 'Más información';

  @override
  String get launch_game => 'Ejecutar juego';

  @override
  String get launch_game_fast_launcher => 'Ejecutar juego (rápidamente)';

  @override
  String get launch_game_fast_launcher_description =>
      'Ejecuta el juego rápidamente, omitiendo el video de introducción del Pack y la sección del menú.';

  @override
  String get launch_pack => 'Ejecutar juego';

  @override
  String get launch_pack_description => 'Ejecuta el juego normalmente';

  @override
  String get launch_informations => 'Información de ejecución';

  @override
  String get launching => 'Ejecutando...';

  @override
  String get launched => '¡Ejecutado!';

  @override
  String get path_not_found => 'Ruta no encontrada';

  @override
  String get path_not_found_small_description =>
      'No se encontró la ruta del juego.';

  @override
  String get path_not_found_description =>
      'No se encontró la ruta al juego. Comprueba que el juego esté instalado y que la ruta sea correcta.';

  @override
  String get path_inexistant => 'Ruta inexistente';

  @override
  String get path_inexistant_small_description =>
      'No agregaste la ruta del juego.';

  @override
  String get path_inexistant_description =>
      'No agregaste la ruta del juego. Puedes hacerlo en los Ajustes.';

  @override
  String get pack_path => 'Ruta del juego';

  @override
  String get owned_packs => 'Juegos que posees';

  @override
  String get add_pack => 'Añadir un juego';

  @override
  String get choose_pack => 'Elige un juego';

  @override
  String get game_type_coop => 'Cooperativo';

  @override
  String get game_type_coop_description =>
      'En estos juegos, los jugadores deben trabajar juntos para ganar.';

  @override
  String get game_type_versus => 'Todos contra todos';

  @override
  String get game_type_versus_description =>
      'En estos juegos, cada jugador juega por sí mismo y debe vencer a los demás jugadores.';

  @override
  String get game_type_team => 'Equipos';

  @override
  String get game_type_team_description =>
      'En estos juegos, los jugadores se dividen en equipos y deben trabajar juntos para ganar.';

  @override
  String game_translation_translated(String language) {
    return 'Traducido oficialmente';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Estos juegos están traducidos de manera oficial al $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Estos juegos están traducidos en francés, italiano, alemán y español por Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Traducido por la comunidad';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Estos juegos están traducidos por la comunidad.';
  }

  @override
  String get game_translation_not_available => 'En inglés';

  @override
  String game_translation_not_available_description(String language) {
    return 'Estos juegos no están traducidos al $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Estos juegos solo están disponibles en inglés.';

  @override
  String get downloading => 'Descargando';

  @override
  String get starting => 'Comenzando';

  @override
  String get extracting => 'Extrayendo';

  @override
  String get finalizing => 'Finalizando';

  @override
  String get unknown_error => 'Error desconocido';

  @override
  String get contact_error => 'Contacta a Akira896 en Discord';

  @override
  String get game_patch_unavailable => 'Parche no disponible';

  @override
  String get game_patch_available => 'Un parche está disponible';

  @override
  String get game_patch_installed => 'Este parche está actualizado';

  @override
  String get game_patch_outdated =>
      'Hay una actualización disponible para este parche';

  @override
  String get players => 'jugadores';

  @override
  String get search_game => 'Buscar un juego';

  @override
  String get search => 'Buscar';

  @override
  String get all_games => 'Todos los juegos';

  @override
  String get all_games_description =>
      'Encuentra todos los juegos de Jackbox en un solo lugar.';

  @override
  String get search_by_pack => 'Buscar por Pack';

  @override
  String get search_by_type => 'Buscar por tipo';

  @override
  String get search_by_translation => 'Buscar por traducción';

  @override
  String get search_by_tags => 'Buscar por etiquetas';

  @override
  String get select_server_subtitle =>
      'Selecciona uno de los servidores disponibles';

  @override
  String get select_server_loading => 'Cargando servidores...';

  @override
  String get select_server_button => 'Seleccionar';

  @override
  String connected_to_server(String server) {
    return 'Conectado al servidor de $server';
  }

  @override
  String get connected_to_server_change => 'Cambiar';

  @override
  String get connection_to_server_failed => 'La conexión con el servidor falló';

  @override
  String get connection_to_main_server_failed =>
      'Se produjo un error al recuperar los servidores disponibles';

  @override
  String get quit_while_downloading_title => 'Descarga en progreso';

  @override
  String get quit_while_downloading_description =>
      'Una descarga está en progreso. ¿Seguro que quieres salir ahora?';

  @override
  String get automatic_game_finder_title => 'Buscador automático de juegos';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility puede detectar los juegos instalados en esta computadora de Steam y Epic Games.\n¿Quieres usar esta función?';

  @override
  String get automatic_game_finder_in_progress =>
      'Recuperando juegos, por favor espera';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se encontraron $count juegos',
      one: 'Se encontró 1 juego',
      zero: 'No se encontraron juegos',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Servidor encontrado';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'El servidor $server se ha elegido en función de tu idioma';
  }

  @override
  String get show_all_packs => 'Mostrar los juegos que no posees';

  @override
  String get show_owned_packs_only => 'Mostrar solo los juegos que posees';

  @override
  String get all_patches => 'Todos los parches';

  @override
  String get error_happened => 'Se ha producido un error';

  @override
  String get jackbox_utility_description =>
      'Una aplicación open-source para descargar parches y ejecutar los juegos de Jackbox.';

  @override
  String get server_information => 'Información del servidor (idioma)';

  @override
  String get selected_server => 'Servidor seleccionado';

  @override
  String get change_server => 'Cambiar servidor';

  @override
  String get app_information => 'Información de la aplicación';

  @override
  String get automatic_game_finder_button => 'Detectar los juegos instalados';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count juegos disponibles',
      one: '1 juego disponible',
      zero: 'No hay juegos disponibles',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Autor';

  @override
  String get contributors => 'Contribuyentes';

  @override
  String in_language(String language) {
    return 'En $language';
  }

  @override
  String in_language_description(String language) {
    return 'Estos juegos están disponibles en $language (nativamente o traducidos por la comunidad).';
  }

  @override
  String get game_community_dubbed => 'Doblado por la comunidad';

  @override
  String get game_community_dubbed_description =>
      'Estos juegos se encuentran doblados por la comunidad.';

  @override
  String game_dubbed(String language) {
    return 'Doblado al $language';
  }

  @override
  String get game_dubbed_description =>
      'Estos juegos están doblados por la comunidad o de manera oficial.';

  @override
  String get no_game_in_this_category_title =>
      'No hay juegos en esta categoría';

  @override
  String get no_game_in_this_category_description =>
      'No se encuentran juegos en esta categoría. Intenta añadir más en la sección de Ajustes.';

  @override
  String select_game_location(String game) {
    return 'Selecciona la ubicación de $game';
  }

  @override
  String get download_error => 'Error al descargar';

  @override
  String get download_error_description =>
      'Se produjo un error al descargar el parche. Verifica tu conexión a internet e inténtalo de nuevo.';

  @override
  String get extracting_error => 'Error al extraer';

  @override
  String get extracting_error_description =>
      'Se produjo un error al extraer el juego. Comprueba si tienes suficiente espacio de almacenamiento libre e inténtalo de nuevo.';

  @override
  String get game_reset => 'Restaurar juego';

  @override
  String get game_reset_description =>
      'Esto validará todos los archivos de este juego. Si instalaste algún parche, se eliminará del juego. ¿Seguro que quieres continuar?';

  @override
  String get small_description => 'Descripción';

  @override
  String get patreon_subscribers => 'Suscriptores de Patreon';

  @override
  String get audience => 'Público';

  @override
  String get confirmation => 'Confirmación';

  @override
  String confirmation_description(String action) {
    return '¿Seguro que quieres $action? Esta acción no se puede deshacer.';
  }

  @override
  String get fix => 'Arreglo';

  @override
  String get fixes_available => 'Arreglos disponibles';

  @override
  String get fixes_available_description =>
      'Hay varios arreglos disponibles para descargar para tus juegos. ¿Quieres descargarlos ahora?';

  @override
  String get filter_players_number => 'Número de jugadores';

  @override
  String get family_friendly => 'Para toda la familia';

  @override
  String get optional => 'Opcional';

  @override
  String get subtitles => 'Subtítulos';

  @override
  String get stream_friendly => 'Apto para streaming';

  @override
  String get moderation => 'Moderación';

  @override
  String get randomize_button_text => '¡Probemos con otro!';

  @override
  String get feeling_lucky => 'Me siento con suerte';

  @override
  String sort_by(String type) {
    return 'Ordenar por $type';
  }

  @override
  String get filter => 'Filtro';

  @override
  String get show_games_hidden => 'Mostrar los juegos que ocultaste';

  @override
  String get hide_games_hidden => 'Ocultar los juegos que ocultaste';

  @override
  String get max_playtime => 'Tiempo de juego máximo';

  @override
  String get search_by_ranking => 'Buscar por ranking';

  @override
  String get random_game => 'Juego aleatorio';

  @override
  String get personal_ranking => 'Ranking personal';

  @override
  String get ranked_by_stars => 'Clasificación por estrellas';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Juegos clasificados por estrellas según tu ranking personal.';

  @override
  String get unranked => 'Sin clasificar';

  @override
  String get app_behavior => 'Comportamiento de la aplicación';

  @override
  String get settings_app_startup_category => 'Inicio de la aplicación';

  @override
  String get settings_app_startup_title =>
      'Abrir el launcher al iniciar la aplicación';

  @override
  String get settings_app_startup_description =>
      'Abre la lista de juegos cuando abres la aplicación.';

  @override
  String get settings_discord_rich_presence_category =>
      'Ajustes del estado de la actividad en Discord';

  @override
  String get settings_discord_rich_presence_title =>
      'Estado de la actividad en Discord';

  @override
  String get settings_discord_rich_presence_description =>
      'Muestra lo que estás jugando en Discord. Esto solo funcionará si tienes Discord abierto.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Mostrar botones de apoyo';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Muestra los botones de enlace al GitHub y al Discord de la aplicación en tu estado de la actividad de Discord.';

  @override
  String get settings_audio_category => 'Audio';

  @override
  String get settings_sfx_title => 'Habilitar efectos de sonido';

  @override
  String get settings_sfx_description =>
      'Habilita efectos de sonido en la aplicación.';

  @override
  String get settings_app_saves_category => 'Guardados de la aplicación';

  @override
  String get settings_app_reset_stars_title => 'Restablecer estrellas';

  @override
  String get settings_app_reset_stars_description =>
      'Restablece todas las estrellas en cada juego.';

  @override
  String get settings_app_reset_stars_button_text => 'Restablecer estrellas';

  @override
  String get settings_app_reset_stars_action =>
      'restablecer todas las estrellas en cada juego';

  @override
  String get settings_app_reset_hidden_title => 'Restablecer juegos ocultos';

  @override
  String get settings_app_reset_hidden_description =>
      'Restablece todos los juegos ocultos a visibles.';

  @override
  String get settings_app_reset_hidden_button_text =>
      'Restablecer juegos ocultos';

  @override
  String get settings_app_reset_hidden_action =>
      'restablecer todos los juegos ocultos a visibles';

  @override
  String get rich_presence_application_start_details =>
      'Acaba de iniciar la aplicación';

  @override
  String get rich_presence_application_start_state => 'En el menú';

  @override
  String get rich_presence_game_menu_details => 'Eligiendo un juego';

  @override
  String get rich_presence_game_menu_state => 'En la lista de juegos';

  @override
  String get rich_presence_game_information_details =>
      'Leyendo la información de un juego';

  @override
  String get rich_presence_game_information_state => 'Eligiendo un juego';

  @override
  String get rich_presence_patcher_details => 'Parcheando juegos';

  @override
  String get rich_presence_patcher_state => 'En la lista de parches';

  @override
  String get rich_presence_settings_details => 'Ajustando la aplicación';

  @override
  String get rich_presence_settings_state => 'En los ajustes';

  @override
  String get rich_presence_in_game_details => 'Jugando a';

  @override
  String get open_launcher_on_startup_title_tip => 'Abrir launcher al inicio';

  @override
  String get open_launcher_on_startup_description_tip =>
      'La aplicación puede iniciarse en esta pantalla cuando la inicias automáticamente. ¿Quieres activar esta función? (Esto siempre se puede cambiar en los Ajustes).';

  @override
  String get minutes => 'minutos';

  @override
  String get translation => 'Traducción';

  @override
  String get using_beta_version_text =>
      'Estás utilizando la versión beta de la aplicación. Si encuentras algún problema, infórmalo en el servidor de Discord o en el repositorio de GitHub.';

  @override
  String get pack => 'Pack';

  @override
  String get stars => 'estrellas';

  @override
  String get name => 'nombre';

  @override
  String get players_number => 'número de jugadores';

  @override
  String get donate => 'Donar';

  @override
  String get installed_version => 'Versión instalada';

  @override
  String get filter_available => 'Disponible';

  @override
  String get filter_fully_playable => 'Perfecto';

  @override
  String get filter_midly_playable => 'Decente';

  @override
  String get filter_playable => 'Jugable';

  @override
  String get filter_full_moderation => 'Moderación completa';

  @override
  String get filter_censoring => 'Censura';

  @override
  String get filter_moderation_censoring => 'Moderación y censura';

  @override
  String get filter_dubbed => 'Doblado';

  @override
  String get filter_translated => 'Traducido';

  @override
  String get special_thanks => 'Agradecimientos especiales';

  @override
  String get stream_friendly_tooltip =>
      'Si puedes jugar este juego en un stream, ya sea en una plataforma de streaming o compartiendo tu pantalla a través de Discord, Zoom, Meet, etc.';

  @override
  String get family_friendly_tooltip =>
      'Si este juego se puede jugar con toda la familia (incluyendo niños).';

  @override
  String get moderation_tooltip =>
      'Si este juego tiene un sistema de moderación (acepta, rechaza o censura lo que envían los jugadores en pantalla).';

  @override
  String get audience_tooltip =>
      'Si este juego acepta miembros del público (hasta 10.000, a menos que se indique lo contrario) para jugar después de que los jugadores se hayan unido.';

  @override
  String get subtitles_tooltip =>
      'Si este juego tiene subtítulos que se muestran en pantalla.';

  @override
  String get custom_server_title => 'Servidor personalizado';

  @override
  String get custom_server_description =>
      'Usa un enlace para conectarte a un servidor personalizado.';

  @override
  String get custom_server_explanation =>
      'Usa un enlace al archivo info.json de un servidor personalizado para conectarse a él.';

  @override
  String get custom_server_error =>
      'No se pudo recuperar el servidor con el enlace.';

  @override
  String get custom_server_warning =>
      'Si alguien te pidió que agregaras un enlace allí, es probable que sea una estafa. No continúes si no confías en el propietario de este servidor.';

  @override
  String get custom_server_add_question => '¿Quieres usar este servidor?';

  @override
  String get custom_server_link => 'Enlace de servidor personalizado';

  @override
  String get loading_initialization_failed =>
      'No se pudo inicializar la aplicación.';

  @override
  String get loading_connection_failed => 'Error al conectar con el servidor.';

  @override
  String get loading_save_failed => 'No se pudieron recuperar tus guardados.';

  @override
  String get loading_open_issue_discord =>
      'Abre un issue en GitHub o repórtalo en Discord.';

  @override
  String get loading_check_internet_connection =>
      'Comprueba tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get loading_try_again => 'Intentar otra vez';

  @override
  String get settings_anonymous_data_title => 'Recopilación de datos anónimos';

  @override
  String get settings_anonymous_data_description =>
      'Ayúdanos a mejorar la aplicación enviando datos anónimos sobre tu uso de la aplicación.';

  @override
  String get privacy_info => 'Aviso de privacidad';

  @override
  String get privacy_description =>
      'Esta aplicación recopila estadísticas anónimas para mejorar la aplicación. Puedes deshabilitar esto en la sección de Ajustes.';

  @override
  String get hidden_button_tooltip =>
      'Haz clic para ocultar este juego de la lista de juegos.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Haz clic para mostrar este juego en la lista de juegos.';

  @override
  String get patch_missing_before_launching_title => 'Falta un parche';

  @override
  String get patch_missing_before_launching_description =>
      'Este juego tiene un parche disponible. ¿Quieres instalarlo antes de iniciar el juego?';

  @override
  String get patch_missing_before_launching_install => 'Instalar parche';

  @override
  String get patch_missing_before_launching_launch => 'Ejecutar juego';
}
