// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get close => 'மூடு';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get page_continue => 'தொடரவும்';

  @override
  String get confirm => 'உறுதிப்படுத்தவும்';

  @override
  String get quit => 'வெளியேறு';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get ok => 'சரி';

  @override
  String get jackbox_utility => 'சாக்பாக்ச் பயன்பாடு';

  @override
  String get launch_search_game => 'விளையாட்டுகளைத் தொடங்கவும் / தேடவும்';

  @override
  String get patch_a_game => 'ஒட்டு விளையாட்டுகள்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get installing_a_patch => 'ஒரு இணைப்பு நிறுவுதல்';

  @override
  String get installing_a_patch_description =>
      'நீங்கள் பேட்சை நிறுவுவீர்கள். இந்த நடவடிக்கை மாற்ற முடியாதது.';

  @override
  String get installing_a_patch_end => 'நிறுவல் முடிந்தது';

  @override
  String get can_close_popup => 'இந்த பாப்-அப் மூடலாம்';

  @override
  String get patch_unavailable => 'இணைப்பு கிடைக்கவில்லை';

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
  String get delete_version => 'பதிப்பு நீக்குதல்';

  @override
  String get delete_version_description =>
      'உங்கள் விளையாட்டை மீட்டமைத்திருந்தால், இந்த விளையாட்டின் நிறுவப்பட்ட பதிப்பை நீக்கலாம். இது திட்டுகளை மீண்டும் நிறுவ உங்களை அனுமதிக்கும்.';

  @override
  String get description => 'விவரம்';

  @override
  String get patch_modification => 'இணைப்பு மாற்றம்';

  @override
  String get patch_modification_description =>
      'இந்த இணைப்பு பின்வரும் வழியில் விளையாட்டை மாற்றுகிறது:';

  @override
  String get patch_modification_content_text =>
      'விளையாட்டின் உரை உள்ளடக்கத்தை மாற்றியமைத்தல்';

  @override
  String get patch_modification_content_internal =>
      'விளையாட்டின் உள் கோப்புகளை மாற்றியமைத்தல் (படங்கள், உரைகள் ...)';

  @override
  String get patch_modification_content_subtitles =>
      'விளையாட்டின் வசன வரிகள் மாற்றம்';

  @override
  String patch_modification_content_website(String website) {
    return 'சாக் பாக்ச் கிளையண்டின் உரை உள்ளடக்கத்தை மாற்றியமைத்தல் ($website)';
  }

  @override
  String get patch_modification_content_audios =>
      'விளையாட்டின் ஒலியை மாற்றியமைத்தல்';

  @override
  String get version => 'பதிப்பு';

  @override
  String get authors => 'ஆசிரியர் (கள்)';

  @override
  String get small_information => 'தகவல்';

  @override
  String get more_informations => 'மேலும் செய்தி';

  @override
  String get launch_game => 'அறிமுகம்';

  @override
  String get launch_game_fast_launcher => 'துவக்க விளையாட்டு (ஃபாச்ட் லாஞ்சர்)';

  @override
  String get launch_game_fast_launcher_description =>
      'ஃபாச்ட் லாஞ்சர் பயன்முறையில் விளையாட்டைத் தொடங்குகிறது, இது பேக்கின் அறிமுக வீடியோ மற்றும் விளையாட்டின் தேர்வைத் தவிர்க்க உங்களை அனுமதிக்கிறது. சில விளையாட்டுகளுக்கு மட்டுமே கிடைக்கும்.';

  @override
  String get launch_pack => 'அறிமுகம்';

  @override
  String get launch_pack_description => 'பேக்கை பொதுவாக அறிமுகப்படுத்துகிறது';

  @override
  String get launch_informations => 'தகவல்களைத் தொடங்கவும்';

  @override
  String get launching => 'தொடங்குதல் ...';

  @override
  String get launched => 'தொடங்கப்பட்டது!';

  @override
  String get path_not_found => 'பாதை காணப்படவில்லை';

  @override
  String get path_not_found_small_description =>
      'விளையாட்டுக்கான பாதை காணப்படவில்லை.';

  @override
  String get path_not_found_description =>
      'விளையாட்டுக்கான பாதை காணப்படவில்லை. விளையாட்டு நிறுவப்பட்டுள்ளதா என்பதையும் பாதை சரியானது என்பதை சரிபார்க்கவும்.';

  @override
  String get path_inexistant => 'இல்லாத பாதை';

  @override
  String get path_inexistant_small_description =>
      'நீங்கள் பேக்கிற்கு பாதையைச் சேர்க்கவில்லை.';

  @override
  String get path_inexistant_description =>
      'நீங்கள் பேக்கிற்கு பாதையைச் சேர்க்கவில்லை. நீங்கள் அதை அமைப்புகளில் செய்யலாம்.';

  @override
  String get pack_path => 'விளையாட்டு பாதை';

  @override
  String get owned_packs => 'சொந்தமான விளையாட்டுகள்';

  @override
  String get add_pack => 'ஒரு விளையாட்டைச் சேர்க்கவும்';

  @override
  String get choose_pack => 'ஒரு விளையாட்டைத் தேர்வுசெய்க';

  @override
  String get game_type_coop => 'கூட்டுறவு';

  @override
  String get game_type_coop_description =>
      'இந்த விளையாட்டுகளில், வெற்றிபெற வீரர்கள் ஒன்றிணைந்து செயல்பட வேண்டும்.';

  @override
  String get game_type_versus => 'அனைவருக்கும் இலவசம்';

  @override
  String get game_type_versus_description =>
      'இந்த விளையாட்டுகளில், ஒவ்வொரு வீரரும் தனக்காக விளையாடுகிறார்கள், மற்ற வீரர்களை வெல்ல வேண்டும்.';

  @override
  String get game_type_team => 'அணிகள்';

  @override
  String get game_type_team_description =>
      'இந்த விளையாட்டுகளில், வீரர்கள் அணிகளாகப் பிரிக்கப்பட்டுள்ளனர், மேலும் வெற்றிபெற ஒன்றிணைந்து செயல்பட வேண்டும்.';

  @override
  String game_translation_translated(String language) {
    return '$language இல் அதிகாரப்பூர்வமாக மொழிபெயர்க்கப்பட்டுள்ளது';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'இந்த விளையாட்டுகள் $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'இந்த விளையாட்டுகள் சாக்பாக்ச் விளையாட்டுகளால் பிரஞ்சு, இத்தாலியன், செர்மன் மற்றும் ச்பானிச் மொழிகளில் மொழிபெயர்க்கப்பட்டுள்ளன.';

  @override
  String get game_translation_community_translated =>
      'சமூகத்தால் மொழிபெயர்க்கப்பட்டுள்ளது';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'இந்த விளையாட்டுகள் சமூகத்தால் மொழிபெயர்க்கப்பட்டுள்ளன.';
  }

  @override
  String get game_translation_not_available => 'ஆங்கிலத்தில்';

  @override
  String game_translation_not_available_description(String language) {
    return 'இந்த விளையாட்டுகள் $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'இந்த விளையாட்டுகள் ஆங்கிலத்தில் மட்டுமே கிடைக்கின்றன.';

  @override
  String get downloading => 'பதிவிறக்குகிறது';

  @override
  String get starting => 'தொடங்குகிறது';

  @override
  String get extracting => 'பிரித்தெடுக்கும்';

  @override
  String get finalizing => 'இறுதி';

  @override
  String get unknown_error => 'தெரியாத பிழை';

  @override
  String get contact_error =>
      'டிச்கார்ட்டில் அலெக்சிச்ல் 61 ஐ தொடர்பு கொள்ளவும்';

  @override
  String get game_patch_unavailable => 'இணைப்பு கிடைக்கவில்லை';

  @override
  String get game_patch_available => 'ஒரு இணைப்பு கிடைக்கிறது';

  @override
  String get game_patch_installed => 'இணைப்பு புதுப்பித்த நிலையில் உள்ளது';

  @override
  String get game_patch_outdated =>
      'இந்த இணைப்புக்கு ஒரு புதுப்பிப்பு கிடைக்கிறது';

  @override
  String get players => 'வீரர்கள்';

  @override
  String get search_game => 'ஒரு விளையாட்டைத் தேடுங்கள்';

  @override
  String get search => 'தேடல்';

  @override
  String get all_games => 'அனைத்து விளையாட்டுகளும்';

  @override
  String get all_games_description =>
      'அனைத்து சாக்பாக்ச் கேம்களையும் ஒரே இடத்தில் கண்டுபிடிக்கவும்.';

  @override
  String get search_by_pack => 'பேக் மூலம் தேடுங்கள்';

  @override
  String get search_by_type => 'வகை மூலம் தேடுங்கள்';

  @override
  String get search_by_translation => 'மொழிபெயர்ப்பு மூலம் தேடுங்கள்';

  @override
  String get search_by_tags => 'குறிச்சொற்களால் தேடுங்கள்';

  @override
  String get select_server_subtitle =>
      'கிடைக்கக்கூடிய சேவையகங்களில் ஒன்றைத் தேர்ந்தெடுக்கவும்';

  @override
  String get select_server_loading => 'சேவையகங்களை ஏற்றுகிறது ...';

  @override
  String get select_server_button => 'தேர்ந்தெடு';

  @override
  String connected_to_server(String server) {
    return 'சேவையகத்துடன் இணைக்கப்பட்டுள்ளது $server';
  }

  @override
  String get connected_to_server_change => 'மாற்றம்';

  @override
  String get connection_to_server_failed =>
      'சேவையகத்திற்கான இணைப்பு தோல்வியடைந்தது';

  @override
  String get connection_to_main_server_failed =>
      'கிடைக்கக்கூடிய சேவையகங்களை மீட்டெடுக்கும் போது பிழை.';

  @override
  String get quit_while_downloading_title =>
      'பதிவிறக்கம் முன்னேற்றத்தில் உள்ளது';

  @override
  String get quit_while_downloading_description =>
      'பதிவிறக்கம் நடந்து வருகிறது. நீங்கள் இப்போது வெளியேற விரும்புகிறீர்களா?';

  @override
  String get automatic_game_finder_title =>
      'தானியங்கி விளையாட்டு கண்டுபிடிப்பாளர்';

  @override
  String get automatic_game_finder_description =>
      'சாக்பாக்ச் பயன்பாடு நீராவி மற்றும் காவிய விளையாட்டுகளைப் பயன்படுத்தி இந்த கணினியில் நிறுவப்பட்ட கேம்களைக் கண்டறிய முடியும்.\n இந்த அம்சத்தைப் பயன்படுத்த விரும்புகிறீர்களா?';

  @override
  String get automatic_game_finder_in_progress =>
      'விளையாட்டுகளை மீட்டெடுப்பது, தயவுசெய்து காத்திருங்கள்';

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
  String get automatic_server_finder_found => 'சேவையகம் காணப்பட்டது';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'உங்கள் மொழியின் அடிப்படையில் சேவையகம் $server.';
  }

  @override
  String get show_all_packs => 'பயனற்ற விளையாட்டுகளைக் காட்டு';

  @override
  String get show_owned_packs_only => 'சொந்தமான விளையாட்டுகளை மட்டுமே காட்டு';

  @override
  String get all_patches => 'அனைத்து திட்டுகளும்';

  @override
  String get error_happened => 'பிழை ஏற்பட்டது';

  @override
  String get jackbox_utility_description =>
      'திட்டுகளைப் பதிவிறக்கி சாக் பாக்ச் கேம்களைத் தொடங்க திறந்த மூல பயன்பாடு.';

  @override
  String get server_information => 'சேவையக செய்தி (மொழி)';

  @override
  String get selected_server => 'தேர்ந்தெடுக்கப்பட்ட சேவையகம்';

  @override
  String get change_server => 'சேவையகத்தை மாற்றவும்';

  @override
  String get app_information => 'பயன்பாட்டு செய்தி';

  @override
  String get automatic_game_finder_button =>
      'நிறுவப்பட்ட விளையாட்டுகளை தானாக கண்டறியவும்';

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
  String get author => 'நூலாசிரியர்';

  @override
  String get contributors => 'பங்களிப்பாளர்கள்';

  @override
  String in_language(String language) {
    return '$language';
  }

  @override
  String in_language_description(String language) {
    return 'இந்த விளையாட்டுகள் $language இல் கிடைக்கின்றன (சொந்தமாக அல்லது சமூகத்தால் மொழிபெயர்க்கப்பட்டுள்ளன.)';
  }

  @override
  String get game_community_dubbed => 'சமூகம் டப்பிங்';

  @override
  String get game_community_dubbed_description =>
      'இந்த விளையாட்டுகள் சமூகத்தால் அழைக்கப்படுகின்றன.';

  @override
  String game_dubbed(String language) {
    return '$language இல் டப்பிங் செய்யப்பட்டது';
  }

  @override
  String get game_dubbed_description =>
      'இந்த விளையாட்டுகள் சமூகத்தால் அல்லது சாக்பாக்சால் அழைக்கப்படுகின்றன.';

  @override
  String get no_game_in_this_category_title =>
      'இந்த பிரிவில் விளையாட்டுகள் இல்லை';

  @override
  String get no_game_in_this_category_description =>
      'இந்த வகையில் எந்த விளையாட்டுகளும் இல்லை. அமைப்புகள் பிரிவில் மேலும் சேர்க்க முயற்சிக்கவும்.';

  @override
  String select_game_location(String game) {
    return 'விளையாட்டு of இன் இருப்பிடத்தைத் தேர்ந்தெடுக்கவும் $game';
  }

  @override
  String get download_error => 'பதிவிறக்கும் போது பிழை';

  @override
  String get download_error_description =>
      'விளையாட்டைப் பதிவிறக்கும் போது பிழை ஏற்பட்டது. உங்கள் இணைய இணைப்பை சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get extracting_error => 'பிரித்தெடுக்கும் போது பிழை';

  @override
  String get extracting_error_description =>
      'விளையாட்டைப் பிரித்தெடுக்கும் போது பிழை ஏற்பட்டது. உங்களிடம் போதுமான சேமிப்பிடம் இலவசம் இருக்கிறதா என்று சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get game_reset => 'விளையாட்டை மீட்டமை';

  @override
  String get game_reset_description =>
      'இது இந்த விளையாட்டின் அனைத்து கோப்புகளையும் சரிபார்க்கும். நீங்கள் ஏதேனும் இணைப்பு நிறுவியிருந்தால், அது உங்கள் விளையாட்டிலிருந்து நீக்கப்படும். நீங்கள் தொடர விரும்புகிறீர்களா?';

  @override
  String get small_description => 'விவரம்';

  @override
  String get patreon_subscribers => 'பேட்ரியன் சந்தாதாரர்கள்';

  @override
  String get audience => 'பார்வையாளர்கள்';

  @override
  String get confirmation => 'உறுதிப்படுத்தல்';

  @override
  String confirmation_description(String action) {
    return 'நீங்கள் நிச்சயமாக $action செய்ய விரும்புகிறீர்களா? இந்த செயலை செயல்தவிர்க்க முடியாது.';
  }

  @override
  String get fix => 'சரிசெய்யவும்';

  @override
  String get fixes_available => 'Ydkj தொகுதி. 6 சரி';

  @override
  String get fixes_available_description =>
      'உங்களுக்கு சாக் தொகுதி தெரியாது. இழந்த தங்கம் நிறுவப்பட்ட விளையாட்டுகளில் ஒன்றாக கண்டறியப்பட்டது. இந்த விளையாட்டு பொதுவாக சாளரங்கள் 10/11 மற்றும் லினக்சில் வேலை செய்யாது. அதை சரிசெய்யும் ஒரு பேட்சை பதிவிறக்கம் செய்து நிறுவ விரும்புகிறீர்களா? நீங்கள் அதை எப்போதும் அந்தந்த விளையாட்டு செய்தி தாவலில் நிறுவலாம்.';

  @override
  String get filter_players_number => 'வீரர் எண்ணிக்கை';

  @override
  String get family_friendly => 'குடும்ப நட்பு';

  @override
  String get optional => 'விரும்பினால்';

  @override
  String get subtitles => 'வசன வரிகள்';

  @override
  String get stream_friendly => 'ச்ட்ரீம்-நட்பு';

  @override
  String get moderation => 'மிதமான';

  @override
  String get randomize_button_text => 'இன்னொன்றை முயற்சிப்போம்!';

  @override
  String get feeling_lucky => 'நான் அதிர்ச்டசாலி என்று நினைக்கிறேன்';

  @override
  String sort_by(String type) {
    return 'வகை by மூலம் வரிசைப்படுத்துங்கள் $type';
  }

  @override
  String get filter => 'வடிப்பி';

  @override
  String get show_games_hidden => 'நீங்கள் மறைக்கப்பட்ட விளையாட்டுகளைக் காட்டு';

  @override
  String get hide_games_hidden =>
      'நீங்கள் மறைக்கப்பட்ட விளையாட்டுகளை மறைக்கவும்';

  @override
  String get max_playtime => 'அதிகபட்ச விளையாட்டு நேரம்';

  @override
  String get search_by_ranking => 'தரவரிசை மூலம் தேடுங்கள்';

  @override
  String get random_game => 'சீரற்ற விளையாட்டு';

  @override
  String get personal_ranking => 'தனிப்பட்ட தரவரிசை';

  @override
  String get ranked_by_stars => 'நட்சத்திரங்களால் தரவரிசைப்படுத்தப்பட்டது';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'உங்கள் தனிப்பட்ட தரவரிசையில் இருந்து நட்சத்திரங்களால் தரவரிசைப்படுத்தப்பட்ட விளையாட்டுகள்.';

  @override
  String get unranked => 'அன்ச்கிராங்க்';

  @override
  String get app_behavior => 'பயன்பாட்டு நடத்தை';

  @override
  String get settings_app_startup_category => 'பயன்பாட்டு தொடக்க';

  @override
  String get settings_app_startup_title =>
      'பயன்பாட்டு தொடக்கத்தில் துவக்கத்தைத் திறக்கவும்';

  @override
  String get settings_app_startup_description =>
      'நீங்கள் பயன்பாட்டைத் திறக்கும்போது விளையாட்டுகளின் பட்டியலைத் திறக்கவும்.';

  @override
  String get settings_discord_rich_presence_category =>
      'முரண்பாடு பணக்கார இருப்பு அமைப்புகள்';

  @override
  String get settings_discord_rich_presence_title =>
      'முரண்பாடு பணக்கார இருப்பு';

  @override
  String get settings_discord_rich_presence_description =>
      'முரண்பாட்டில் நீங்கள் விளையாடுவதைக் காட்டுகிறது. நீங்கள் முரண்பாடு திறந்திருந்தால் மட்டுமே இது செயல்படும்.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'உதவி பொத்தான்களைக் காட்டு';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'கிதுபிற்கான இணைப்பு பொத்தான்கள் மற்றும் உங்கள் கருத்து வேறுபாடு நிறைந்த பயன்பாட்டின் பயன்பாட்டின் முரண்பாடு ஆகியவற்றைக் காட்டுகிறது.';

  @override
  String get settings_audio_category => 'ஆடியோ';

  @override
  String get settings_sfx_title => 'SFX ஐ இயக்கவும்';

  @override
  String get settings_sfx_description =>
      'பயன்பாட்டில் ஒலி விளைவுகளை செயல்படுத்துகிறது.';

  @override
  String get settings_app_saves_category => 'பயன்பாடு சேமிக்கிறது';

  @override
  String get settings_app_reset_stars_title => 'நட்சத்திரங்களை மீட்டமைக்கவும்';

  @override
  String get settings_app_reset_stars_description =>
      'ஒவ்வொரு விளையாட்டுக்கும் அனைத்து நட்சத்திரங்களையும் மீட்டமைக்கிறது.';

  @override
  String get settings_app_reset_stars_button_text =>
      'நட்சத்திரங்களை மீட்டமைக்கவும்';

  @override
  String get settings_app_reset_stars_action =>
      'ஒவ்வொரு விளையாட்டுக்கும் அனைத்து நட்சத்திரங்களையும் மீட்டமைக்கவும்';

  @override
  String get settings_app_reset_hidden_title =>
      'மறைக்கப்பட்ட விளையாட்டுகளை மீட்டமைக்கவும்';

  @override
  String get settings_app_reset_hidden_description =>
      'மறைக்கப்பட்ட அனைத்து விளையாட்டுகளையும் காணக்கூடிய வகையில் மீட்டமைக்கிறது.';

  @override
  String get settings_app_reset_hidden_button_text =>
      'மறைக்கப்பட்ட விளையாட்டுகளை மீட்டமைக்கவும்';

  @override
  String get settings_app_reset_hidden_action =>
      'மறைக்கப்பட்ட அனைத்து விளையாட்டுகளையும் காணக்கூடிய வகையில் மீட்டமைக்கவும்';

  @override
  String get rich_presence_application_start_details =>
      'பயன்பாட்டைத் தொடங்கியது';

  @override
  String get rich_presence_application_start_state => 'பட்டியலில்';

  @override
  String get rich_presence_game_menu_details =>
      'ஒரு விளையாட்டைத் தேர்ந்தெடுப்பது';

  @override
  String get rich_presence_game_menu_state => 'விளையாட்டு பட்டியலில்';

  @override
  String get rich_presence_game_information_details =>
      'ஒரு விளையாட்டின் தகவலைப் படித்தல்';

  @override
  String get rich_presence_game_information_state =>
      'ஒரு விளையாட்டைத் தேர்ந்தெடுப்பது';

  @override
  String get rich_presence_patcher_details => 'ஒரு விளையாட்டை ஒட்டுதல்';

  @override
  String get rich_presence_patcher_state => 'இணைப்பு பட்டியலில்';

  @override
  String get rich_presence_settings_details => 'பயன்பாட்டை முறுக்குதல்';

  @override
  String get rich_presence_settings_state => 'அமைப்புகளில்';

  @override
  String get rich_presence_in_game_details => 'விளையாட்டில்';

  @override
  String get open_launcher_on_startup_title_tip =>
      'தொடக்கத்தில் திறந்த துவக்கி';

  @override
  String get open_launcher_on_startup_description_tip =>
      'இந்தத் திரையில் நீங்கள் தானாகவே தொடங்கும்போது பயன்பாடு தொடங்கலாம். இந்த அம்சத்தை செயல்படுத்த விரும்புகிறீர்களா? (இது எப்போதும் அமைப்புகளில் மாற்றப்படலாம்.)';

  @override
  String get minutes => 'நிமிடங்கள்';

  @override
  String get translation => 'மொழிபெயர்ப்பு';

  @override
  String get using_beta_version_text =>
      'பயன்பாட்டின் பீட்டா பதிப்பைப் பயன்படுத்துகிறீர்கள். நீங்கள் ஏதேனும் சிக்கல்களை எதிர்கொண்டால், தயவுசெய்து அவற்றை டிச்கார்ட் சேவையகம் அல்லது அறிவிலிமையம் களஞ்சியத்தில் புகாரளிக்கவும்.';

  @override
  String get pack => 'பேக்';

  @override
  String get stars => 'நட்சத்திரங்கள்';

  @override
  String get name => 'பெயர்';

  @override
  String get players_number => 'வீரர் எண்ணிக்கை';

  @override
  String get donate => 'நன்கொடை';

  @override
  String get installed_version => 'நிறுவப்பட்ட பதிப்பு';

  @override
  String get filter_available => 'கிடைக்கிறது';

  @override
  String get filter_fully_playable => 'முழுமையாக விளையாடக்கூடியது';

  @override
  String get filter_midly_playable => 'லேசாக விளையாடக்கூடியது';

  @override
  String get filter_playable => 'விளையாடக்கூடியது';

  @override
  String get filter_full_moderation => 'முழு மிதமான';

  @override
  String get filter_censoring => 'தணிக்கை';

  @override
  String get filter_moderation_censoring => 'மோட். & தணிக்கை';

  @override
  String get filter_dubbed => 'டப்பிங்';

  @override
  String get filter_translated => 'மொழிபெயர்க்கப்பட்டுள்ளது';

  @override
  String get special_thanks => 'சிறப்பு நன்றி';

  @override
  String get stream_friendly_tooltip =>
      'இந்த விளையாட்டை நீங்கள் ஒரு ச்ட்ரீம் மூலம் விளையாட முடிந்தால், அது ச்ட்ரீமிங் மேடையில் இருப்பது அல்லது உங்கள் திரையை கருத்து வேறுபாடு, பெரிதாக்கு, சந்திப்பு போன்றவற்றின் மூலம் பகிர்வது.';

  @override
  String get family_friendly_tooltip =>
      'இந்த விளையாட்டை அனைத்து குடும்பத்தினருடனும் விளையாட முடிந்தால் (குழந்தைகள் சேர்க்கப்பட்டுள்ளனர்.)';

  @override
  String get moderation_tooltip =>
      'இந்த விளையாட்டில் மிதமான அமைப்பு இருந்தால் (திரையில் பிளேயர் உள்ளீட்டை ஏற்றுக்கொள்கிறது, நிராகரிக்கிறது அல்லது தணிக்கை செய்கிறது.)';

  @override
  String get audience_tooltip =>
      'இந்த விளையாட்டு பார்வையாளர்களின் உறுப்பினர்களை (10.000 வரை, வேறுவிதமாகக் குறிப்பிடாவிட்டால்) வீரர்கள் சேர்ந்த பிறகு விளையாடுவதை ஏற்றுக்கொண்டால்.';

  @override
  String get subtitles_tooltip =>
      'இந்த விளையாட்டில் திரையில் காண்பிக்கப்பட வேண்டிய வசனங்கள் இருந்தால்.';

  @override
  String get custom_server_title => 'தனிப்பயன் சேவையகம்';

  @override
  String get custom_server_description =>
      'தனிப்பயன் சேவையகத்துடன் இணைக்க இணைப்பைப் பயன்படுத்தவும்.';

  @override
  String get custom_server_explanation =>
      'அதை இணைக்க தனிப்பயன் சேவையகத்தின் info.json கோப்பிற்கு இணைப்பைப் பயன்படுத்தவும்.';

  @override
  String get custom_server_error =>
      'இணைப்பிலிருந்து சேவையகத்தை மீட்டெடுப்பதில் தோல்வி.';

  @override
  String get custom_server_warning =>
      'அங்கு ஒரு இணைப்பைச் சேர்க்க யாராவது உங்களிடம் கேட்டால், அது ஒரு மோசடி. இந்த சேவையகத்தின் உரிமையாளரை நீங்கள் நம்பவில்லை என்றால் தொடர வேண்டாம்.';

  @override
  String get custom_server_add_question =>
      'இந்த சேவையகத்தைப் பயன்படுத்த விரும்புகிறீர்களா?';

  @override
  String get custom_server_link => 'தனிப்பயன் சேவையக இணைப்பு';

  @override
  String get loading_initialization_failed =>
      'பயன்பாட்டைத் தொடங்குவதில் தோல்வி.';

  @override
  String get loading_connection_failed => 'சேவையகத்துடன் இணைக்கத் தவறிவிட்டது.';

  @override
  String get loading_save_failed =>
      'உங்கள் சேமிப்புகளை மீட்டெடுப்பதில் தோல்வி.';

  @override
  String get loading_open_issue_discord =>
      'கிட்அப்பில் ஒரு சிக்கலைத் திறக்கவும் அல்லது முரண்பாட்டைப் புகாரளிக்கவும்.';

  @override
  String get loading_check_internet_connection =>
      'உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get loading_try_again => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get settings_anonymous_data_title => 'அநாமதேய தரவு சேகரிப்பு';

  @override
  String get settings_anonymous_data_description =>
      'பயன்பாட்டின் உங்கள் பயன்பாடு குறித்து அநாமதேய தரவை அனுப்புவதன் மூலம் பயன்பாட்டை மேம்படுத்த எங்களுக்கு உதவுங்கள்.';

  @override
  String get privacy_info => 'தனியுரிமை அறிவிப்பு';

  @override
  String get privacy_description =>
      'இந்த பயன்பாடு பயன்பாட்டை மேம்படுத்த அநாமதேய புள்ளிவிவரங்களை சேகரிக்கிறது. அமைப்புகளில் இதை முடக்கலாம்.';

  @override
  String get hidden_button_tooltip =>
      'இந்த விளையாட்டை விளையாட்டு பட்டியலிலிருந்து மறைக்க சொடுக்கு செய்க.';

  @override
  String get hidden_button_hidden_tooltip =>
      'விளையாட்டு பட்டியலிலிருந்து இந்த விளையாட்டை மறைக்க சொடுக்கு செய்க.';

  @override
  String get patch_missing_before_launching_title => 'ஒட்டு காணவில்லை';

  @override
  String get patch_missing_before_launching_description =>
      'இந்த விளையாட்டில் ஒரு இணைப்பு உள்ளது. விளையாட்டைத் தொடங்குவதற்கு முன் அதை நிறுவ விரும்புகிறீர்களா?';

  @override
  String get patch_missing_before_launching_install => 'பேட்சை நிறுவவும்';

  @override
  String get patch_missing_before_launching_launch => 'அறிமுகம்';
}
