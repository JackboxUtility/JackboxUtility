// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get close => 'Закрыць';

  @override
  String get cancel => 'Адмена';

  @override
  String get page_continue => 'Працягнуць';

  @override
  String get confirm => 'Пацвердзіць';

  @override
  String get quit => 'закрыць';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Не';

  @override
  String get ok => 'ОК';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Запусціць / Шукаць Гульні';

  @override
  String get patch_a_game => 'Патчыць Гульні';

  @override
  String get settings => 'Налады';

  @override
  String get notifications => 'Апавяшчэнні';

  @override
  String get installing_a_patch => 'Усталёўваны Патч';

  @override
  String get installing_a_patch_description =>
      'Вы ўсталюеце патч. Гэта дзеянне незваротнае.';

  @override
  String get installing_a_patch_end => 'Усталяванне скончана';

  @override
  String get can_close_popup => 'Вы можаце зачыніць гэтае акно';

  @override
  String get patch_unavailable => 'Патч недаступны';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Патчаў ўсталявана',
      one: 'Патч усталяваны',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Абнавіць патчы',
      one: 'Абнавіць патч',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Усталяваць патчы',
      one: 'Усталяваць патч',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Выдаленне версіі';

  @override
  String get delete_version_description =>
      'Калі вам трэба скінуць гульню, вы можаце выдаліць дадзеную версію гульні. Пасля гэтага вы зможаце пераўсталяваць патчы.';

  @override
  String get description => 'Апісанне';

  @override
  String get patch_modification => 'Мадыфікацыя патча';

  @override
  String get patch_modification_description =>
      'Гэты патч змяняе гульню наступным чынам:';

  @override
  String get patch_modification_content_text =>
      'Падтрымка гульні ў гульні з кантэнтам';

  @override
  String get patch_modification_content_internal =>
      'Мадыфікацыя ўнутраных файлаў гульні (малюнкі, тэксты...)';

  @override
  String get patch_modification_content_subtitles =>
      'Мадыфікацыя субтытраў гульні';

  @override
  String patch_modification_content_website(String website) {
    return 'Мадыфікацыя тэкставага кантэнту кліента jackbox (даступна толькі на $website)';
  }

  @override
  String get patch_modification_content_audios => 'Мадыфікацыя гуку гульні';

  @override
  String get version => 'Версія';

  @override
  String get authors => 'Аўтар(ы)';

  @override
  String get small_information => 'Інфармацыя';

  @override
  String get more_informations => 'Больш Інфармацыі';

  @override
  String get launch_game => 'Запусціць гульню';

  @override
  String get launch_game_fast_launcher => 'Запусціць гульню (Хуткі запуск)';

  @override
  String get launch_game_fast_launcher_description =>
      'Запускае гульню ў рэжыме хуткага запуску, які дазваляе прапусціць уступны ролік пакета і выбар гульні. Даступна толькі для некаторых гульняў.';

  @override
  String get launch_pack => 'Запусціць гульню';

  @override
  String get launch_pack_description => 'Запусціць гульню без змен';

  @override
  String get launch_informations => 'Запуск Інфармацыі';

  @override
  String get launching => 'Запускаем...';

  @override
  String get launched => 'Запушчана!';

  @override
  String get path_not_found => 'Шлях не знойдзены';

  @override
  String get path_not_found_small_description => 'Шлях да гульні не знойдзены.';

  @override
  String get path_not_found_description =>
      'Шлях да гульні не знойдзены. Праверце, што гульня ўсталявана і што шлях да яе паказаны правільна.';

  @override
  String get path_inexistant => 'Шлях не знойдзены';

  @override
  String get path_inexistant_small_description => 'Вы не дадалі шлях да пака';

  @override
  String get path_inexistant_description =>
      'Вы не дадалі шлях да паку. Вы можаце зрабіць гэта ў наладах';

  @override
  String get pack_path => 'Шлях да гульні';

  @override
  String get owned_packs => 'Устаноўленыя Гульні';

  @override
  String get add_pack => 'Дадаць гульню';

  @override
  String get choose_pack => 'Выбраць гульню';

  @override
  String get game_type_coop => 'Каоп';

  @override
  String get game_type_coop_description =>
      'У гэтых гульнях, players must work together to win.';

  @override
  String get game_type_versus => 'Free For All';

  @override
  String get game_type_versus_description =>
      'У гэтых гульнях, кожны гулец гуляе за сябе і павінен перамагчы астатніх.';

  @override
  String get game_type_team => 'Каманды';

  @override
  String get game_type_team_description =>
      'У гэтых гульнях, гульцы падзелены на розныя каманды і павінны працаваць разам каб перамагчы.';

  @override
  String game_translation_translated(String language) {
    return 'Афіцыйна перакладзена на $language мову';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Гэтыя гульні афіцыйна перакладзены на $language мову.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Гэтыя гульні перакладзены на Французскі , Італьянскі, Нямецкі і Іспанскі камандай Jackbox Games.';

  @override
  String get game_translation_community_translated =>
      'Перакладзена супольнасцю';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Гэтыя гульні перакладзены супольнасцю.';
  }

  @override
  String get game_translation_not_available => 'На англійскай';

  @override
  String game_translation_not_available_description(String language) {
    return 'Гэтыя гульні не перакладзены на $language мову.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Гэтыя гульні даступныя толькі на ангельскай.';

  @override
  String get downloading => 'Загрузка';

  @override
  String get starting => 'Пачатак';

  @override
  String get extracting => 'Распакоўка';

  @override
  String get finalizing => 'Завяршэнне';

  @override
  String get unknown_error => 'Невядомая Памылка';

  @override
  String get contact_error =>
      'Звяжыцеся з Alexisl61 у Discord (на ангельскай мове)';

  @override
  String get game_patch_unavailable => 'Патч недаступны';

  @override
  String get game_patch_available => 'Патч даступны';

  @override
  String get game_patch_installed => 'У вас усталявана апошняя версія патча';

  @override
  String get game_patch_outdated => 'Абнаўленне да патча даступна';

  @override
  String get players => 'гульцоў';

  @override
  String get search_game => 'Знайсці гульню';

  @override
  String get search => 'Пошук';

  @override
  String get all_games => 'Усе гульні';

  @override
  String get all_games_description =>
      'Знаходзьце ўсе Jackbox гульні ў адным месцы.';

  @override
  String get search_by_pack => 'Знайсці па паку';

  @override
  String get search_by_type => 'Знайсці па тыпе';

  @override
  String get search_by_translation => 'Знайсьці па перакладзе';

  @override
  String get search_by_tags => 'Знайсці па тэгу';

  @override
  String get select_server_subtitle => 'Абярыце адзін з даступных сервераў';

  @override
  String get select_server_loading => 'Загрузка сервераў...';

  @override
  String get select_server_button => 'Выбраць';

  @override
  String connected_to_server(String server) {
    return 'Падлучэнне да сервера $server';
  }

  @override
  String get connected_to_server_change => 'Змяніць';

  @override
  String get connection_to_server_failed => 'Падлучэнне да сервера перарвана.';

  @override
  String get connection_to_main_server_failed =>
      'Падключэнне да ўсіх сервераў перарвана.';

  @override
  String get quit_while_downloading_title => 'Усталяванне';

  @override
  String get quit_while_downloading_description =>
      'Цяпер адбываецца ўстаноўка, вы ўпэўнены, што хочаце выйсці?';

  @override
  String get automatic_game_finder_title => 'Аўтаматычны пошук гульні';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility можа знайсці ўсталяваныя гульні выкарыстоўваючы Steam і Epic Games.\nВы хочаце выкарыстоўваць гэтую функцыю?';

  @override
  String get automatic_game_finder_in_progress =>
      'Пошук гульняў, калі ласка пачакайце';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Гульняў знойдзена: $count',
      one: 'Гульняў знойдзена: 1',
      zero: 'Гульняў не знойдзена',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Сервер знойдзены';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'Сервер $server быў абраны на аснове вашай мовы.';
  }

  @override
  String get show_all_packs => 'Паказаць не набытыя гульні';

  @override
  String get show_owned_packs_only => 'Паказаць набытыя гульні';

  @override
  String get all_patches => 'Усе патчы';

  @override
  String get error_happened => 'Адбылася памылка';

  @override
  String get jackbox_utility_description =>
      'Прыкладанне з адкрытым зыходным кодам для загрузкі патчаў і запуску гульняў Jackbox.';

  @override
  String get server_information => 'Пра сервер';

  @override
  String get selected_server => 'Вылучаны сервер';

  @override
  String get change_server => 'Змяніць сервер';

  @override
  String get app_information => 'Аб дадатку';

  @override
  String get automatic_game_finder_button => 'Знайсці ўсталяваныя гульні';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Гульняў даступна: $count',
      one: 'Гульняў даступна: 1',
      zero: 'Няма даступных гульняў',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Аўтар';

  @override
  String get contributors => 'Удзельнікі';

  @override
  String in_language(String language) {
    return 'На $language мове';
  }

  @override
  String in_language_description(String language) {
    return 'Гэтыя гульні даступныя на $language мове (афіцыйна або перакладзены супольнасцю.)';
  }

  @override
  String get game_community_dubbed => 'Агучана супольнасцю';

  @override
  String get game_community_dubbed_description =>
      'Гэтыя гульні агучаныя супольнасцю.';

  @override
  String game_dubbed(String language) {
    return 'Агучана на $language мове';
  }

  @override
  String get game_dubbed_description =>
      'Гэтыя гульні агучаныя супольнасьцю або Jackbox.';

  @override
  String get no_game_in_this_category_title => 'У гэтай катэгорыі няма гульняў';

  @override
  String get no_game_in_this_category_description =>
      'У гэтай катэгорыі няма гульняў. Дадайце яшчэ гульняў у секцыі Налад.';

  @override
  String select_game_location(String game) {
    return 'Абярыце шлях да $game';
  }

  @override
  String get download_error => 'Памылка загрузкі';

  @override
  String get download_error_description =>
      'Адбылася памылка падчас загрузкі гульні. Калі ласка, пераканайцеся, што ваша інтэрнэт злучэнне працуе карэктна.';

  @override
  String get extracting_error => 'Памылка распакавання';

  @override
  String get extracting_error_description =>
      'Адбылася памылка падчас распакавання гульні.';

  @override
  String get game_reset => 'Скід гульні';

  @override
  String get game_reset_description =>
      'Гэта прывядзе да праверкі ўсіх файлаў гэтай гульні. Калі вы ўсталявалі які-небудзь патч, ён будзе выдалены з вашай гульні. Вы ўпэўненыя, што жадаеце працягнуць?';

  @override
  String get small_description => 'Апісанне';

  @override
  String get patreon_subscribers => 'Падпісчыкі Patreon';

  @override
  String get audience => 'Гледачы';

  @override
  String get confirmation => 'Пацвярджэнне';

  @override
  String confirmation_description(String action) {
    return 'Вы сапраўды жадаеце $action? Гэта дзеянне незваротна.';
  }

  @override
  String get fix => 'Фікс';

  @override
  String get fixes_available => 'Фікс YDKJ Vol. 6';

  @override
  String get fixes_available_description =>
      'You Don\'t Know Jack Vol. 6 The Lost Gold была выяўлена як адна з устаноўленых гульняў. Гэтая гульня звычайна не працуе на Windows 10/11 і Linux. Вы хочаце спампаваць і ўсталяваць які выпраўляе гэта патч? Вы заўсёды можаце ўсталяваць яго на адпаведнай укладцы інфармацыі аб гульні.';

  @override
  String get filter_players_number => 'Коль-ць Гульцоў';

  @override
  String get family_friendly => 'Сямейны Рэжым';

  @override
  String get optional => 'Апцыянальна';

  @override
  String get subtitles => 'Субтытры';

  @override
  String get stream_friendly => 'Для стрымераў';

  @override
  String get moderation => 'Мадэрацыя';

  @override
  String get randomize_button_text => 'Давайце іншую!';

  @override
  String get feeling_lucky => 'Мне павязе';

  @override
  String sort_by(String type) {
    return 'Сартаваць па $type';
  }

  @override
  String get filter => 'Фільтр';

  @override
  String get show_games_hidden => 'Паказаць гульні, якія вы схавалі';

  @override
  String get hide_games_hidden => 'Схаваць схаваныя гульні';

  @override
  String get max_playtime => 'Максімальны час гульні';

  @override
  String get search_by_ranking => 'Пошук па рэйтынгу';

  @override
  String get random_game => 'Выпадковая гульня';

  @override
  String get personal_ranking => 'Асабісты рэйтынг';

  @override
  String get ranked_by_stars => 'Ранжыраванне па зорках';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Games ranked by stars from your personal ranking.';

  @override
  String get unranked => 'Без рэйтынгу';

  @override
  String get app_behavior => 'Паводзіны прыкладанняў';

  @override
  String get settings_app_startup_category => 'Запуск прыкладанняў';

  @override
  String get settings_app_startup_title =>
      'Адкрываць лаўнчар пры запуску прыкладання';

  @override
  String get settings_app_startup_description =>
      'Адкрываць спіс гульняў пры адкрыцці прыкладання';

  @override
  String get settings_discord_rich_presence_category =>
      'Налады Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Паказвае, у што вы гуляеце ў Discord. Гэта будзе працаваць толькі ў тым выпадку, калі ў вас адкрыты Discord.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Паказваць кнопкі падтрымкі';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Паказвае кнопкі спасылак на GitHub і Discord прыкладанні ў вашым Discord Rich Presence.';

  @override
  String get settings_audio_category => 'Аўдыё';

  @override
  String get settings_sfx_title => 'Уключыць SFX';

  @override
  String get settings_sfx_description => 'Уключае гукавыя эфекты ў дадатку';

  @override
  String get settings_app_saves_category => 'Захавання прыкладанняў';

  @override
  String get settings_app_reset_stars_title => 'Скінуць зоркі';

  @override
  String get settings_app_reset_stars_description =>
      'Скідае ўсе зоркі для кожнай гульні';

  @override
  String get settings_app_reset_stars_button_text => 'Скінуць зоркі';

  @override
  String get settings_app_reset_stars_action =>
      'Скінуць усе зоркі для кожнай гульні';

  @override
  String get settings_app_reset_hidden_title => 'Скінуць схаваныя гульні';

  @override
  String get settings_app_reset_hidden_description =>
      'Скінуць усе схаваныя гульні да бачных';

  @override
  String get settings_app_reset_hidden_button_text => 'Скінуць схаваныя гульні';

  @override
  String get settings_app_reset_hidden_action =>
      'Скінуць усе схаваныя гульні на бачныя';

  @override
  String get rich_presence_application_start_details =>
      'Толькі што запусціў дадатак';

  @override
  String get rich_presence_application_start_state => 'У меню';

  @override
  String get rich_presence_game_menu_details => 'Выбар гульні';

  @override
  String get rich_presence_game_menu_state => 'У спісе гульняў';

  @override
  String get rich_presence_game_information_details =>
      'Чытанне інфармацыі аб гульні';

  @override
  String get rich_presence_game_information_state => 'Выбар гульні';

  @override
  String get rich_presence_patcher_details => 'Патчыць гульню';

  @override
  String get rich_presence_patcher_state => 'У спісе патчаў';

  @override
  String get rich_presence_settings_details => 'Настройка прыкладання';

  @override
  String get rich_presence_settings_state => 'У наладах';

  @override
  String get rich_presence_in_game_details => 'У гульне';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Адкрываць лаўнчар пры запуску';

  @override
  String get open_launcher_on_startup_description_tip =>
      'Прылада можа запускацца на гэтым экране пры аўтаматычным запуску. Ці вы хочаце актываваць гэтую функцыю? (Гэта заўсёды можна змяніць у наладах)';

  @override
  String get minutes => 'хвілін';

  @override
  String get translation => 'Пераклад';

  @override
  String get using_beta_version_text =>
      'Вы выкарыстоўваеце бэта-версію прыкладання. Калі ў вас узнікнуць якія-небудзь праблемы, паведаміце аб іх на серверы Discord або ў рэпазітары Github.';

  @override
  String get pack => 'Пак';

  @override
  String get stars => 'Зорак';

  @override
  String get name => 'Назва';

  @override
  String get players_number => 'Колькасць Гульцоў';

  @override
  String get donate => 'Донат';

  @override
  String get installed_version => 'Усталяваная Версія';

  @override
  String get filter_available => 'Даступна';

  @override
  String get filter_fully_playable => 'Цалкам Гуляемы';

  @override
  String get filter_midly_playable => 'Амаль Гуляем';

  @override
  String get filter_playable => 'Гуляемы';

  @override
  String get filter_full_moderation => 'Поўная Мадэрацыя';

  @override
  String get filter_censoring => 'Цэнзура';

  @override
  String get filter_moderation_censoring => 'Мадэрацыя і Цэнзура';

  @override
  String get filter_dubbed => 'Агучана';

  @override
  String get filter_translated => 'Перакладзена';

  @override
  String get special_thanks => 'Асобнае Дзякуй';

  @override
  String get stream_friendly_tooltip =>
      'Калі вы можаце гуляць у гэтую гульню праз стрым, гэта значыць на стрымінгавай платформе або дзяліцца сваім экранам праз Discord, Zoom, Meet і г.д.';

  @override
  String get family_friendly_tooltip =>
      'Калі ў гэтую гульню можна гуляць усёй сям\'ёй (уключаючы дзяцей)';

  @override
  String get moderation_tooltip =>
      'Ці ёсць у гэтай гульні сістэма мадэрацыі (прымае, адхіляе або цэнзуруе экранныя паведамленні гульцоў)';

  @override
  String get audience_tooltip =>
      'Ці прымае гульня гледачоў (да 10.000, калі не пазначана іншае) для ўдзелу ў гульні пасля таго, як да яе далучыліся гульцы.';

  @override
  String get subtitles_tooltip =>
      'Калі ў гэтай гульні ёсць субтытры, якія павінны адлюстроўвацца на экране.';

  @override
  String get custom_server_title => 'Карыстальніцкі сервер';

  @override
  String get custom_server_description =>
      'Выкарыстоўвайце спасылку для падлучэння да карыстальніцкага сервера.';

  @override
  String get custom_server_explanation =>
      'Выкарыстоўвайце спасылку на файл info.json карыстальніцкага сервера, каб падключыцца да яго.';

  @override
  String get custom_server_error => 'Не ўдалося аднавіць сервер па спасылцы.';

  @override
  String get custom_server_warning =>
      'Калі нехта папрасіў вас дадаць туды спасылку, гэта, хутчэй за ўсё, махлярства. Не працягвайце, калі вы не давяраеце ўладальніку гэтага сервера.';

  @override
  String get custom_server_add_question =>
      'Вы хочаце выкарыстоўваць гэты сервер?';

  @override
  String get custom_server_link => 'Карыстальніцкая спасылка на сервер';

  @override
  String get loading_initialization_failed =>
      'Не ўдалося ініцыялізаваць праграму.';

  @override
  String get loading_connection_failed => 'Не атрымалася злучыцца з серверам.';

  @override
  String get loading_save_failed => 'Не ўдалося атрымаць захаваныя файлы.';

  @override
  String get loading_open_issue_discord =>
      'Калі ласка, адкрыйце праблему на GitHub або паведаміце пра яе на Discord.';

  @override
  String get loading_check_internet_connection =>
      'Калі ласка, праверце падключэнне да Інтэрнэту і паўтарыце спробу.';

  @override
  String get loading_try_again => 'Паўтарыць спробу';

  @override
  String get settings_anonymous_data_title => 'Ананімны збор дадзеных';

  @override
  String get settings_anonymous_data_description =>
      'Дапамажыце нам палепшыць праграму, дасылаючы ананімныя даныя аб выкарыстанні вамі праграмы.';

  @override
  String get privacy_info => 'Паведамленне аб прыватнасці';

  @override
  String get privacy_description =>
      'Гэта праграма збірае ананімную статыстыку для паляпшэння праграмы. Вы можаце адключыць гэта ў наладах.';

  @override
  String get hidden_button_tooltip =>
      'Націсніце, каб cхаваць гульню ў спісе гульняў.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Націсніце, каб паказаць гульню ў спісе гульняў.';

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
