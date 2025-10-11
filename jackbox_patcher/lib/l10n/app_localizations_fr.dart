// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get page_continue => 'Continuer';

  @override
  String get confirm => 'Valider';

  @override
  String get quit => 'Quitter';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'Ok';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Lancer / Rechercher un jeu';

  @override
  String get patch_a_game => 'Patcher un jeu';

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get installing_a_patch => 'Installation du patch';

  @override
  String get installing_a_patch_description =>
      'Vous allez installer le patch. Cette action est irréversible.';

  @override
  String get installing_a_patch_end => 'Installation terminée';

  @override
  String get thank_the_team_button => 'Remercier l\'équipe';

  @override
  String get thank_the_team_description =>
      'Remerciez l\'équipe pour la traduction';

  @override
  String get can_close_popup => 'Vous pouvez fermer cette pop-up';

  @override
  String get patch_unavailable => 'Patch non disponible';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Patchs installés',
      one: 'Patch installé',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mettre à jour',
      one: 'Mettre à jour',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Installer les patchs',
      one: 'Installer le patch',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Suppression de la version';

  @override
  String get delete_version_description =>
      'Si vous avez réinitialisé votre jeu, vous pouvez supprimer la version installée de ce jeu. Cela vous permettra de réinstaller les patchs.';

  @override
  String get description => 'Description';

  @override
  String get patch_modification => 'Modification du patch';

  @override
  String get patch_modification_description =>
      'Ce patch modifie le jeu de la manière suivante :';

  @override
  String get patch_modification_content_text =>
      'Modification du contenu textuel du jeu';

  @override
  String get patch_modification_content_internal =>
      'Modification des fichiers internes du jeu (images, textes...)';

  @override
  String get patch_modification_content_subtitles =>
      'Modification des sous-titres du jeu';

  @override
  String patch_modification_content_website(String website) {
    return 'Modification du contenu textuel du client jackbox (seulement disponible sur $website)';
  }

  @override
  String get patch_modification_content_audios =>
      'Modification des fichiers audio du jeu';

  @override
  String get version => 'Version';

  @override
  String get authors => 'Auteur(s)';

  @override
  String get small_information => 'Info';

  @override
  String get more_informations => 'Plus d\'informations';

  @override
  String get launch_game => 'Lancer le jeu';

  @override
  String get launch_game_fast_launcher => 'Lancer le jeu (fast launcher)';

  @override
  String get launch_game_fast_launcher_description =>
      'Lance le jeu en mode fast launcher ce qui permet de passer outre la vidéo d\'intro du pack et le choix du jeu. Seulement disponible pour certains jeux.';

  @override
  String get launch_pack => 'Lancer le pack';

  @override
  String get launch_pack_description => 'Lance le pack normalement';

  @override
  String get launch_informations => 'Informations de lancement';

  @override
  String get launching => 'Launching...';

  @override
  String get launched => 'Launched !';

  @override
  String get path_not_found => 'Chemin introuvable';

  @override
  String get path_not_found_small_description =>
      'Le chemin vers le pack n\'a pas été trouvé.';

  @override
  String get path_not_found_description =>
      'Le chemin pour ce pack n\'a pas été trouvé sur votre ordinateur. Vous devez de nouveau ajouter le chemin pour ce pack dans ses paramètres.';

  @override
  String get path_inexistant => 'Chemin inexistant';

  @override
  String get path_inexistant_small_description =>
      'Vous n\'avez pas ajouté le chemin vers le pack. Vous pouvez le faire dans les paramètres.';

  @override
  String get path_inexistant_description =>
      'Vous n\'avez pas ajouté le chemin vers le pack. Vous pouvez le faire dans les paramètres.';

  @override
  String get pack_path => 'Chemin vers le pack';

  @override
  String get owned_packs => 'Packs possédés';

  @override
  String get add_pack => 'Ajouter un pack';

  @override
  String get choose_pack => 'Choisissez un pack';

  @override
  String get game_type_coop => 'Jeu en cooperation';

  @override
  String get game_type_coop_description =>
      'Dans ces jeux, les joueurs doivent travailler ensemble pour gagner.';

  @override
  String get game_type_versus => 'Chacun pour soi';

  @override
  String get game_type_versus_description =>
      'Dans ces jeux, chaque joueur joue pour lui-même et doit battre les autres joueurs.';

  @override
  String get game_type_team => 'Jeu en équipe';

  @override
  String get game_type_team_description =>
      'Dans ces jeux, les joueurs sont divisés en équipes et doivent travailler ensemble pour gagner.';

  @override
  String game_translation_translated(String language) {
    return 'Traduit en $language par Jackbox';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Ces jeux sont traduits nativement en $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Ces jeux sont traduits en Français, Italien, Allemand et Espagnol par Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Traduit par la communauté';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Ces jeux sont traduits par la communauté française Jackbox France et Jackbox International.';
  }

  @override
  String get game_translation_not_available => 'En Anglais';

  @override
  String game_translation_not_available_description(String language) {
    return 'Ces jeux ne sont pas traduits en $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Ces jeux sont seulement disponibles en Anglais.';

  @override
  String get downloading => 'Téléchargement';

  @override
  String get starting => 'Démarrage';

  @override
  String get extracting => 'Extraction';

  @override
  String get finalizing => 'Finalisation';

  @override
  String get unknown_error => 'Erreur inconnue';

  @override
  String get contact_error => 'Contactez Alexis#1588 sur Discord';

  @override
  String get game_patch_unavailable => 'Aucune traduction disponible';

  @override
  String get game_patch_available => 'Un patch est disponible';

  @override
  String get game_patch_installed => 'Ce jeu est à jour';

  @override
  String get game_patch_outdated => 'Une mise à jour du patch est disponible';

  @override
  String get players => 'joueurs';

  @override
  String get search_game => 'Rechercher un jeu';

  @override
  String get search => 'Rechercher';

  @override
  String get all_games => 'Tous les jeux';

  @override
  String get all_games_description =>
      'Retrouvez tous les jeux Jackbox à un seul et même endroit.';

  @override
  String get search_by_pack => 'Recherche par pack';

  @override
  String get search_by_type => 'Recherche par type';

  @override
  String get search_by_translation => 'Recherche par traduction';

  @override
  String get search_by_tags => 'Recherche par tags';

  @override
  String get select_server_subtitle => 'Choisissez un serveur pour commencer';

  @override
  String get select_server_loading => 'Chargement des serveurs...';

  @override
  String get select_server_button => 'Sélectionner';

  @override
  String connected_to_server(String server) {
    return 'Connecté au serveur $server';
  }

  @override
  String get connected_to_server_change => 'Changer';

  @override
  String get connection_to_server_failed => 'Connexion au serveur échoué';

  @override
  String get connection_to_main_server_failed =>
      'Impossible de récupérer la liste des serveurs. Vérifiez votre connexion internet.';

  @override
  String get quit_while_downloading_title => 'Téléchargement en cours';

  @override
  String get quit_while_downloading_description =>
      'Un téléchargement est en cours, êtes vous sûr de vouloir quitter maintenant ?';

  @override
  String get automatic_game_finder_title => 'Détecteur automatique de jeu';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility peut détecter les jeux provenant de Steam et Epic games.\nVoulez-vous utiliser cette fonctionnalité ?';

  @override
  String get automatic_game_finder_in_progress =>
      'Récupération des jeux en cours';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux trouvés',
      one: '1 jeu trouvé',
      zero: 'Aucun jeu trouvé',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Serveur trouvé';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'Le serveur $server a été choisi automatiquement à partir de votre langue.';
  }

  @override
  String get show_all_packs => 'Montrer tous les packs';

  @override
  String get show_owned_packs_only => 'Montrer seulement les packs possédés';

  @override
  String get all_patches => 'Tous les patchs';

  @override
  String get error_happened => 'Une erreur est survenue';

  @override
  String get jackbox_utility_description =>
      'Une application open-source pour installer des patchs et lancer des jeux Jackbox.';

  @override
  String get server_information => 'Information du serveur (Langue)';

  @override
  String get selected_server => 'Serveur sélectionné';

  @override
  String get change_server => 'Changer de serveur';

  @override
  String get app_information => 'Information de l\'application';

  @override
  String get automatic_game_finder_button => 'Lancer la détection automatique';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux disponible',
      one: '1 jeu disponible',
      zero: 'Aucun jeu disponible',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Auteur';

  @override
  String get contributors => 'Contributeurs';

  @override
  String in_language(String language) {
    return 'Traduit en $language';
  }

  @override
  String in_language_description(String language) {
    return 'Ces jeux snt disponibles en $language (nativement ou traduit par la communauté)';
  }

  @override
  String get game_community_dubbed => 'Doublé par la communauté';

  @override
  String get game_community_dubbed_description =>
      'Ces jeux ont une version doublée par la communauté.';

  @override
  String game_dubbed(String language) {
    return 'Traduit en $language';
  }

  @override
  String get game_dubbed_description =>
      'Ces jeux sont doublés par la communauté ou par Jackbox.';

  @override
  String get no_game_in_this_category_title => 'No game in this category';

  @override
  String get no_game_in_this_category_description =>
      'There is no game in this category. Try adding more in the settings section.';

  @override
  String select_game_location(String game) {
    return 'Select the location of $game';
  }

  @override
  String get download_error => 'Ereur pendant le téléchargement';

  @override
  String get download_error_description =>
      'Une erreur est survenue pendant le téléchargement. Vérifiez votre connexion à internet et rééssayez.';

  @override
  String get extracting_error => 'Erreur pendant l\'extraction';

  @override
  String get extracting_error_description =>
      'Une erreur est survenue pendant l\'extraction. Regardez si vous avez assez d\'espace de stockage et rééssayez.';

  @override
  String get game_reset => 'Réinitialiser le jeu';

  @override
  String get game_reset_description =>
      'Cela va valider tous les fichiers du jeu. Si vous avez installé un patch, il sera enlevé du jeu. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get small_description => 'Description';

  @override
  String get patreon_subscribers => 'Abonnés Patreon';

  @override
  String get audience => 'Audience';

  @override
  String get confirmation => 'Confirmation';

  @override
  String confirmation_description(String action) {
    return 'Êtes-vous sûr de vouloir $action ? Cette action ne peut pas être annulée.';
  }

  @override
  String get fix => 'Fix';

  @override
  String get fixes_available => 'Fix disponible';

  @override
  String get fixes_available_description =>
      'Des fixs sont disponible au téléchargement pour vos jeux. Voulez-vous les télécharger maintenant ?';

  @override
  String get filter_players_number => 'Nombre de joueurs';

  @override
  String get family_friendly => 'Familial';

  @override
  String get optional => 'Optionel';

  @override
  String get subtitles => 'Sous-titres';

  @override
  String get stream_friendly => 'Stream friendly';

  @override
  String get moderation => 'Modération';

  @override
  String get randomize_button_text => 'En choisir un autre !';

  @override
  String get feeling_lucky => 'J\'ai de la chance';

  @override
  String sort_by(String type) {
    return 'Trier par $type';
  }

  @override
  String get filter => 'Filtrer';

  @override
  String get show_games_hidden => 'Montrer les jeux cachés';

  @override
  String get hide_games_hidden => 'Cacher les jeux cachés';

  @override
  String get max_playtime => 'Temps de jeu max';

  @override
  String get search_by_ranking => 'Chercher par classement';

  @override
  String get random_game => 'Jeu au hasard';

  @override
  String get personal_ranking => 'Classement personnel';

  @override
  String get ranked_by_stars => 'Classement personnel';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Jeux classés par étoiles à partir de votre classement personnel.';

  @override
  String get unranked => 'Non classé';

  @override
  String get app_behavior => 'Comportement de l\'application';

  @override
  String get settings_app_startup_category => 'Démarrage de l\'application';

  @override
  String get settings_app_startup_title =>
      'Ouvrir le lanceur au chargement de l\'application';

  @override
  String get settings_app_startup_description =>
      'Ouvrir la liste de jeu quand vous ouvrez l\'application.';

  @override
  String get settings_discord_rich_presence_category =>
      'Paramètres de Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Montre ce que vous faites sur Discord. Vous devez avoir Discord ouvert pour que ça marche.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Montrer les boutons de support';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Montre les boutons de support redirigeant au GitHub de l\'application sur votre profil Discord.';

  @override
  String get settings_audio_category => 'Audio';

  @override
  String get settings_sfx_title => 'Activer les SFX';

  @override
  String get settings_sfx_description =>
      'Activer les effets sonores dans l\'application.';

  @override
  String get settings_app_saves_category => 'Sauvegarde de l\'application';

  @override
  String get settings_app_reset_stars_title => 'Réinitialiser le classement';

  @override
  String get settings_app_reset_stars_description =>
      'Réinitialiser le classement pour chacun des jeux.';

  @override
  String get settings_app_reset_stars_button_text =>
      'Réinitialiser le classement';

  @override
  String get settings_app_reset_stars_action =>
      'réinitialiser le classement pour chacun des jeux';

  @override
  String get settings_app_reset_hidden_title => 'Réinitialiser les jeux cachés';

  @override
  String get settings_app_reset_hidden_description =>
      'Réinitialise les jeux cachés en visible.';

  @override
  String get settings_app_reset_hidden_button_text =>
      'Réinitialiser les jeux cachés';

  @override
  String get settings_app_reset_hidden_action =>
      'réinitialiser les jeux cachés en visible';

  @override
  String get rich_presence_application_start_details =>
      'Vient de démarrer l\'application';

  @override
  String get rich_presence_application_start_state => 'Dans le menu';

  @override
  String get rich_presence_game_menu_details => 'Choisis un jeu';

  @override
  String get rich_presence_game_menu_state => 'Dans la liste de jeu';

  @override
  String get rich_presence_game_information_details =>
      'Lis les informations sur un jeu';

  @override
  String get rich_presence_game_information_state => 'Choisis un jeu';

  @override
  String get rich_presence_patcher_details => 'Patch un jeu';

  @override
  String get rich_presence_patcher_state => 'Dans la liste des patchs';

  @override
  String get rich_presence_settings_details => 'Customise l\'application';

  @override
  String get rich_presence_settings_state => 'Dans les paramètres';

  @override
  String get rich_presence_in_game_details => 'En jeu';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Ouvrir le menu des jeux au démarrage';

  @override
  String get open_launcher_on_startup_description_tip =>
      'L\'application peut démarrer sur cet écran quand vous la démarrez automatiquemeent. Voulez-vous activer ce paramètre ? (Vous pouvez toujours le changer dans les paramètres plus tard)';

  @override
  String get minutes => 'minutes';

  @override
  String get translation => 'Traduction';

  @override
  String get using_beta_version_text =>
      'Vous utilisez la version BETA de l\'application. Si vous trouvez des bugs, n\'hésitez pas à en parler sur le serveur discord ou sur Github. Merci !';

  @override
  String get pack => 'Pack';

  @override
  String get stars => 'Etoiles';

  @override
  String get name => 'Nom';

  @override
  String get players_number => 'Nombre de joueurs';

  @override
  String get donate => 'Supporter l\'application';

  @override
  String get installed_version => 'Version installée';

  @override
  String get filter_available => 'Disponible';

  @override
  String get filter_fully_playable => 'Jouable entièrement';

  @override
  String get filter_midly_playable => 'Jouable partiellement';

  @override
  String get filter_playable => 'Jouable';

  @override
  String get filter_full_moderation => 'Modération complète';

  @override
  String get filter_censoring => 'Censure';

  @override
  String get filter_moderation_censoring => 'Mod. et Censure';

  @override
  String get filter_dubbed => 'Doublé';

  @override
  String get filter_translated => 'Traduit';

  @override
  String get special_thanks => 'Remerciements';

  @override
  String get stream_friendly_tooltip =>
      'Si il est possible de jouer à ce jeu avec un stream sur une plateforme de streaming ou en partageant son écran sur Discord, Zoom, Meet, etc.';

  @override
  String get family_friendly_tooltip =>
      'Si ce jeu convient à toute la famille (enfants inclus).';

  @override
  String get moderation_tooltip =>
      'Si ce jeu a un système de modération (censure, etc.)';

  @override
  String get audience_tooltip =>
      'Si ce jeu accepte une audience jouant avec les joueurs en jeu.';

  @override
  String get subtitles_tooltip => 'Si ce jeu a des sous-titres.';

  @override
  String get custom_server_title => 'Serveur personnalisé';

  @override
  String get custom_server_description =>
      'Utiliser un lien pour se connecter à un serveur personnalisé.';

  @override
  String get custom_server_explanation =>
      'Utiliser un lien direct vers le fichier info.json du serveur personnalisé auquel vous souhaitez vous connecter.';

  @override
  String get custom_server_error =>
      'Impossible de récupérer un serveur à partir de ce lien.';

  @override
  String get custom_server_warning =>
      'Si quelqu\'un vous a demandé de coller un lien ici, c\'est surement un lien malveillant. Ne collez pas de lien ici si vous n\'avez pas confiance à 100% en la personne qui vous l\'a donné.';

  @override
  String get custom_server_add_question => 'Voulez-vous utiliser ce serveur ?';

  @override
  String get custom_server_link => 'Lien de serveur';

  @override
  String get loading_initialization_failed =>
      'Erreur lors de l\'initialisation de l\'application.';

  @override
  String get loading_connection_failed =>
      'Erreur lors de la connexion au serveur.';

  @override
  String get loading_save_failed =>
      'Erreur lors de la récupération des sauvegardes.';

  @override
  String get loading_open_issue_discord =>
      'Ouvrez une issue sur GitHub ou parlez-en sur notre serveur discord.';

  @override
  String get loading_check_internet_connection =>
      'Vérifiez votre connexion à internet et rééssayez.';

  @override
  String get loading_try_again => 'Rééssayer';

  @override
  String get settings_anonymous_data_title => 'Collecte de données anonymes';

  @override
  String get settings_anonymous_data_description =>
      'Aidez-nous à améliorer l\'application en envoyant des données anonymes de votre utilisation.';

  @override
  String get privacy_info => 'Confidentialité';

  @override
  String get privacy_description =>
      'L\'application collecte des statistiques anonymes pour améliorer l\'application. Ceci est désactivable dans les paramètres.';

  @override
  String get hidden_button_tooltip =>
      'Cliquer pour cacher ce jeu dans la liste de jeu.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Cliquer pour montrer ce jeu dans la liste de jeu.';

  @override
  String get patch_missing_before_launching_title => 'Traduction manquante';

  @override
  String get patch_missing_before_launching_description =>
      'Ce jeu a un patch de disponible. Souhaitez-vous l\'installer avant de lancer le jeu ?';

  @override
  String get patch_missing_before_launching_install => 'Installer le patch';

  @override
  String get patch_missing_before_launching_launch => 'Lancer le jeu';
}
