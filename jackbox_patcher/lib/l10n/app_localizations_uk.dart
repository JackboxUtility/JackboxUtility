// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get close => 'Закрити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get page_continue => 'Продовжити';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get quit => 'Вийти';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get ok => 'Гаразд';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Лаунчер / Пошук';

  @override
  String get patch_a_game => 'Патчер';

  @override
  String get settings => 'Налаштування';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get installing_a_patch => 'Встановлення патча';

  @override
  String get installing_a_patch_description =>
      'Ви встановлюєте патч. Ця дія є незворотною.';

  @override
  String get installing_a_patch_end => 'Встановлення завершено';

  @override
  String get can_close_popup => 'Ви можете закрити це вікно';

  @override
  String get patch_unavailable => 'Патч недоступний';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Патчі встановлено',
      one: 'Патч встановлено',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Оновити патчі',
      one: 'Оновити патч',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Встановити патчі',
      one: 'Встановити патч',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Видалення версії';

  @override
  String get delete_version_description =>
      'Якщо ви відновили файли, ви можете видалити встановлену версію цієї гри. Це дозволить вам перевстановити патчі.';

  @override
  String get description => 'Опис';

  @override
  String get patch_modification => 'Модифікації патча';

  @override
  String get patch_modification_description =>
      'Цей патч змінює гру наступним чином:';

  @override
  String get patch_modification_content_text =>
      'Модифікація текстового наповнення гри';

  @override
  String get patch_modification_content_internal =>
      'Модифікація внутрішніх файлів гри (зображень, текстів тощо)';

  @override
  String get patch_modification_content_subtitles =>
      'Модифікація субтитрів до гри';

  @override
  String patch_modification_content_website(String website) {
    return 'Модифікація текстового наповнення клієнта Jackbox (лише на $website)';
  }

  @override
  String get patch_modification_content_audios =>
      'Модифікація звукового супроводу гри';

  @override
  String get version => 'Версія';

  @override
  String get authors => 'Автор(и)';

  @override
  String get small_information => 'Інфо';

  @override
  String get more_informations => 'Більше інформації';

  @override
  String get launch_game => 'Запустити гру';

  @override
  String get launch_game_fast_launcher => 'Запустити гру (швидкий запуск)';

  @override
  String get launch_game_fast_launcher_description =>
      'Запускає гру у режимі швидкого запуску, що пропускає вступне відео та вибір ігор. Доступно лише для кількох ігор.';

  @override
  String get launch_pack => 'Запустити збірку';

  @override
  String get launch_pack_description => 'Запускає збірку стандартним способом';

  @override
  String get launch_informations => 'Інформація про запуск';

  @override
  String get launching => 'Запуск...';

  @override
  String get launched => 'Запущено!';

  @override
  String get path_not_found => 'Шлях не знайдено';

  @override
  String get path_not_found_small_description => 'Шлях до гри не знайдено.';

  @override
  String get path_not_found_description =>
      'Шлях до гри не знайдено. Будь ласка, перевірте, чи встановлено гру та чи правильно вказано шлях до неї.';

  @override
  String get path_inexistant => 'Шляху не існує';

  @override
  String get path_inexistant_small_description => 'Шлях до гри відсутній.';

  @override
  String get path_inexistant_description =>
      'Шлях до гри відсутній. Будь ласка, вкажіть шлях у налаштуваннях.';

  @override
  String get pack_path => 'Шлях до гри';

  @override
  String get owned_packs => 'Встановлені ігри';

  @override
  String get add_pack => 'Додати гру';

  @override
  String get choose_pack => 'Оберіть гру';

  @override
  String get game_type_coop => 'Кооперативні';

  @override
  String get game_type_coop_description =>
      'У цих іграх гравці повинні працювати разом, щоб перемогти.';

  @override
  String get game_type_versus => 'Кожен сам за себе';

  @override
  String get game_type_versus_description =>
      'У цих іграх кожен гравець грає сам за себе та повинен перемогти інших гравців.';

  @override
  String get game_type_team => 'Командні';

  @override
  String get game_type_team_description =>
      'У цих іграх гравці діляться на команди та повинні працювати разом, щоб перемогти.';

  @override
  String game_translation_translated(String language) {
    return 'Офіційний переклад';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'У цих іграх присутня $language, офіційний переклад.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Ці ігри перекладені французькою, італійською, німецькою та іспанською мовами компанією Jackbox Games.';

  @override
  String get game_translation_community_translated => 'Переклад від спільноти';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'У цих іграх присутня $language, переклад від спільноти.';
  }

  @override
  String get game_translation_not_available => 'Без перекладу';

  @override
  String game_translation_not_available_description(String language) {
    return 'У цих іграх наразі відсутня $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Ці ігри доступні лише англійською мовою.';

  @override
  String get downloading => 'Завантаження';

  @override
  String get starting => 'Початок роботи';

  @override
  String get extracting => 'Витягування';

  @override
  String get finalizing => 'Завершення роботи';

  @override
  String get unknown_error => 'Невідома помилка';

  @override
  String get contact_error =>
      'Запитайте про вашу помилку на Discord-сервері (discord.gg/jUQzjjaxQP)';

  @override
  String get game_patch_unavailable => 'Патч недоступний';

  @override
  String get game_patch_available => 'Патч доступний';

  @override
  String get game_patch_installed => 'Патч актуальний';

  @override
  String get game_patch_outdated => 'Для цього патча доступне оновлення';

  @override
  String get players => 'гравців';

  @override
  String get search_game => 'Пошук гри';

  @override
  String get search => 'Пошук';

  @override
  String get all_games => 'Усі ігри';

  @override
  String get all_games_description =>
      'Знайдіть усі ігри Jackbox Games в одному місці.';

  @override
  String get search_by_pack => 'Пошук за збіркою';

  @override
  String get search_by_type => 'Пошук за типом';

  @override
  String get search_by_translation => 'Пошук за перекладом';

  @override
  String get search_by_tags => 'Пошук за тегами';

  @override
  String get select_server_subtitle => 'Оберіть один з доступних серверів';

  @override
  String get select_server_loading => 'Завантаження серверів...';

  @override
  String get select_server_button => 'Обрати';

  @override
  String connected_to_server(String server) {
    return 'Під\'єднано до сервера «$server»';
  }

  @override
  String get connected_to_server_change => 'Змінити';

  @override
  String get connection_to_server_failed => 'Не вдалося з\'єднатися з сервером';

  @override
  String get connection_to_main_server_failed =>
      'Помилка під час отримання даних про доступні сервери.';

  @override
  String get quit_while_downloading_title => 'Завантаження триває';

  @override
  String get quit_while_downloading_description =>
      'Завантаження триває, ви впевнені, що хочете вийти зараз?';

  @override
  String get automatic_game_finder_title => 'Автоматичне виявлення';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility може виявити встановлену гру на цьому комп\'ютері за допомогою Steam та Epic Games.\nБажаєте скористатися цією функцією?';

  @override
  String get automatic_game_finder_in_progress =>
      'Виявлення ігор, будь ласка, зачекайте';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Виявлено $count ігор',
      few: 'Виявлено $count гри',
      one: 'Виявлено 1 гру',
      zero: 'Ігор не виявлено',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Сервер знайдено';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'На основі вашої мови було обрано сервер «$server».';
  }

  @override
  String get show_all_packs => 'Показати усі ігри';

  @override
  String get show_owned_packs_only => 'Показати лише встановлені ігри';

  @override
  String get all_patches => 'Усі патчі';

  @override
  String get error_happened => 'Виникла помилка';

  @override
  String get jackbox_utility_description =>
      'Застосунок з відкритим вихідним кодом для встановлення патчів та запуску ігор від Jackbox Games.';

  @override
  String get server_information => 'Інформація про сервер (Мова)';

  @override
  String get selected_server => 'Обраний сервер';

  @override
  String get change_server => 'Змінити сервер';

  @override
  String get app_information => 'Інформація про застосунок';

  @override
  String get automatic_game_finder_button => 'Автоматичне виявлення';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Доступно $count ігор',
      few: 'Доступно $count гри',
      one: 'Доступна 1 гра',
      zero: 'Немає доступних ігор',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Розробник';

  @override
  String get contributors => 'Контриб\'ютори';

  @override
  String in_language(String language) {
    return 'Присутня $language';
  }

  @override
  String in_language_description(String language) {
    return 'У цих іграх присутня $language.';
  }

  @override
  String get game_community_dubbed => 'Озвучення від спільноти';

  @override
  String get game_community_dubbed_description =>
      'У цих іграх присутнє озвучення від спільноти.';

  @override
  String game_dubbed(String language) {
    return 'Присутня $language озвучка';
  }

  @override
  String get game_dubbed_description => 'У цих іграх присутнє озвучення.';

  @override
  String get no_game_in_this_category_title => 'У цій категорії немає ігор';

  @override
  String get no_game_in_this_category_description =>
      'У цій категорії немає жодної гри. Спробуйте змінити категорію чи додати необхідну гру у налаштуваннях.';

  @override
  String select_game_location(String game) {
    return 'Оберіть папку з $game';
  }

  @override
  String get download_error => 'Помилка під час завантаження';

  @override
  String get download_error_description =>
      'Під час завантаження гри виникла помилка. Будь ласка, перевірте ваше підключення до Інтернету і спробуйте ще раз.';

  @override
  String get extracting_error => 'Помилка під час розпакування';

  @override
  String get extracting_error_description =>
      'Під час розпакування гри виникла помилка. Будь ласка, перевірте, чи достатньо у вас вільного місця на диску і спробуйте ще раз.';

  @override
  String get game_reset => 'Відновити гру';

  @override
  String get game_reset_description =>
      'Ця дія перевірить всі файли гри. Якщо ви встановили якийсь патч, його буде видалено. Ви впевнені, що хочете продовжити?';

  @override
  String get small_description => 'Опис';

  @override
  String get patreon_subscribers => 'Патрони';

  @override
  String get audience => 'Глядачі';

  @override
  String get confirmation => 'Підтвердження';

  @override
  String confirmation_description(String action) {
    return 'Ви дійсно бажаєте $action? Цю дію неможливо скасувати.';
  }

  @override
  String get fix => 'Виправлення';

  @override
  String get fixes_available => 'Виправлення доступне';

  @override
  String get fixes_available_description =>
      'Доступно кілька виправлень для ваших ігор. Бажаєте їх завантажити?';

  @override
  String get filter_players_number => 'Кількість гравців';

  @override
  String get family_friendly => 'Для сім\'ї';

  @override
  String get optional => 'Необов\'язково';

  @override
  String get subtitles => 'Субтитри';

  @override
  String get stream_friendly => 'Для трансляцій';

  @override
  String get moderation => 'Модерація';

  @override
  String get randomize_button_text => 'Прокрутімо ще раз!';

  @override
  String get feeling_lucky => 'Мені пощастить';

  @override
  String sort_by(String type) {
    return 'Сортувати за $type';
  }

  @override
  String get filter => 'Фільтри';

  @override
  String get show_games_hidden => 'Показати приховані ігри';

  @override
  String get hide_games_hidden => 'Приховати приховані ігри';

  @override
  String get max_playtime => 'Максимальний час гри (хв)';

  @override
  String get search_by_ranking => 'Пошук за рейтингом';

  @override
  String get random_game => 'Випадкова гра';

  @override
  String get personal_ranking => 'Особистий рейтинг';

  @override
  String get ranked_by_stars => 'Ваші зірки';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Ігри посортовані за зірками, які ви їм виставили.';

  @override
  String get unranked => 'Без рейтингу';

  @override
  String get app_behavior => 'Поведінка застосунка';

  @override
  String get settings_app_startup_category => 'Запуск застосунка';

  @override
  String get settings_app_startup_title =>
      'Відкривати лаунчер при запуску застосунка';

  @override
  String get settings_app_startup_description =>
      'При запуску застосунок буде оминати головне меню та одразу відкривати лаунчер.';

  @override
  String get settings_discord_rich_presence_category =>
      'Параметри Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Ваша активність у застосунку та іграх показуватиметься у вашому профілі в Discord.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Кнопки з посиланнями';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Біля вашої активності у Discord з\'являться кнопки з посиланнями на GitHub та Discord-сервер Jackbox Utility.';

  @override
  String get settings_audio_category => 'Звуки';

  @override
  String get settings_sfx_title => 'Звуки у застосунку';

  @override
  String get settings_sfx_description =>
      'Додаткові звукові ефекти у застосунку.';

  @override
  String get settings_app_saves_category => 'Пам\'ять застосунка';

  @override
  String get settings_app_reset_stars_title => 'Скинути зірки';

  @override
  String get settings_app_reset_stars_description =>
      'Скинути усі зірки, які ви поставили іграм.';

  @override
  String get settings_app_reset_stars_button_text => 'Скинути зірки';

  @override
  String get settings_app_reset_stars_action =>
      'скинути усі зірки, які ви поставили іграм';

  @override
  String get settings_app_reset_hidden_title => 'Скинути приховані ігри';

  @override
  String get settings_app_reset_hidden_description =>
      'Скинути видимість усіх ігор, які ви приховали.';

  @override
  String get settings_app_reset_hidden_button_text => 'Скинути приховані ігри';

  @override
  String get settings_app_reset_hidden_action =>
      'скинути видимість усіх ігор, які ви приховали';

  @override
  String get rich_presence_application_start_details => 'Щойно запущено';

  @override
  String get rich_presence_application_start_state => 'У головному меню';

  @override
  String get rich_presence_game_menu_details => 'Обирає гру';

  @override
  String get rich_presence_game_menu_state => 'У лаунчері';

  @override
  String get rich_presence_game_information_details =>
      'Читає інформацію про гру';

  @override
  String get rich_presence_game_information_state => 'Обирає гру';

  @override
  String get rich_presence_patcher_details => 'Встановлює патч на гру';

  @override
  String get rich_presence_patcher_state => 'У патчері';

  @override
  String get rich_presence_settings_details => 'Налаштовує застосунок';

  @override
  String get rich_presence_settings_state => 'У налаштуваннях';

  @override
  String get rich_presence_in_game_details => 'У грі';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Відкривати лаунчер при запуску застосунка';

  @override
  String get open_launcher_on_startup_description_tip =>
      'Застосунок може автоматично запускатися одразу на цьому екрані. Бажаєте активувати цю функцію? (Це завжди можна змінити в налаштуваннях)';

  @override
  String get minutes => 'хвилин';

  @override
  String get translation => 'Переклад';

  @override
  String get using_beta_version_text =>
      'Ви використовуєте бета-версію. Якщо у вас виникнуть проблеми, будь ласка, повідомте про них на Discord-сервері чи у GitHub-репозиторії.';

  @override
  String get pack => 'збіркою';

  @override
  String get stars => 'зірками';

  @override
  String get name => 'назвою';

  @override
  String get players_number => 'к-тю гравців';

  @override
  String get donate => 'Підтримати';

  @override
  String get installed_version => 'Встановлена версія';

  @override
  String get filter_available => 'Доступно';

  @override
  String get filter_fully_playable => 'Повністю';

  @override
  String get filter_midly_playable => 'Частково';

  @override
  String get filter_playable => 'Так';

  @override
  String get filter_full_moderation => 'Повна модерація';

  @override
  String get filter_censoring => 'Цензура';

  @override
  String get filter_moderation_censoring => 'Модерація й цензура';

  @override
  String get filter_dubbed => 'Озвучено';

  @override
  String get filter_translated => 'Перекладено';

  @override
  String get special_thanks => 'Окрема подяка';

  @override
  String get stream_friendly_tooltip =>
      'Показує чи можна грати у цю гру за допомогою трансляції, чи то стрімінговій платформі, чи то через Discord, Zoom, Meet тощо';

  @override
  String get family_friendly_tooltip =>
      'Показує чи можна грати у цю гру всією сім\'єю (включно з дітьми)';

  @override
  String get moderation_tooltip =>
      'Показує чи має ця гра систему модерації (приймання/відхилення/цензурування надісланого гравцями вмісту)';

  @override
  String get audience_tooltip =>
      'Показує чи можуть до цієї гри приєднуватися глядачі (до 10 000 глядачів, якщо не вказано інакше)';

  @override
  String get subtitles_tooltip =>
      'Показує чи має ця гра можливість показу субтитрів на екрані';

  @override
  String get custom_server_title => 'Інший сервер';

  @override
  String get custom_server_description =>
      'Під\'єднуйтеся до інших серверів за посиланням';

  @override
  String get custom_server_explanation =>
      'Використовуйте raw-посилання на файл «info.json», щоб під\'єднатися до сервера.';

  @override
  String get custom_server_error =>
      'Не вдалося знайти сервер за наданим посилання.';

  @override
  String get custom_server_warning =>
      'Якщо хтось просить вас ввести тут посилання, то існує велика ймовірність, що цей «хтось» — шахрай. Продовжуйте, лише якщо ви довіряєте власнику цього сервера.';

  @override
  String get custom_server_add_question =>
      'Бажаєте використовувати цей сервер?';

  @override
  String get custom_server_link => 'Посилання на сервер';

  @override
  String get loading_initialization_failed =>
      'Не вдалося ініціалізувати застосунок.';

  @override
  String get loading_connection_failed =>
      'Не вдалося під\'єднатися до сервера.';

  @override
  String get loading_save_failed => 'Не вдалося отримати ваші збереження.';

  @override
  String get loading_open_issue_discord =>
      'Будь ласка, відкрийте Issue на GitHub або повідомте про це у Discord.';

  @override
  String get loading_check_internet_connection =>
      'Будь ласка, перевірте ваше з\'єднання з інтернетом та спробуйте ще раз.';

  @override
  String get loading_try_again => 'Спробувати ще раз';

  @override
  String get settings_anonymous_data_title => 'Збір анонімних даних';

  @override
  String get settings_anonymous_data_description =>
      'Допоможіть покращити застосунок, надсилаючи анонімні дані про те, як ви його використовуєте.';

  @override
  String get privacy_info => 'Приватність';

  @override
  String get privacy_description =>
      'Цей застосунок збирає анонімну статистику для його покращення. Ви можете вимкнути це у налаштуваннях.';

  @override
  String get hidden_button_tooltip => 'Приховати цю гру з лаунчера';

  @override
  String get hidden_button_hidden_tooltip => 'Показувати цю гру в лаунчері';

  @override
  String get patch_missing_before_launching_title => 'Патч відсутній';

  @override
  String get patch_missing_before_launching_description =>
      'Для цієї гри доступний патч. Бажаєте встановити його?';

  @override
  String get patch_missing_before_launching_install => 'Встановити патч';

  @override
  String get patch_missing_before_launching_launch => 'Запустити гру';
}
