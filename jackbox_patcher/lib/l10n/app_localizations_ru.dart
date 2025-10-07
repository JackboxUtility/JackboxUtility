// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get page_continue => 'Продолжить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get quit => 'закрыть';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'ОК';

  @override
  String get jackbox_utility => 'Jackbox Utility';

  @override
  String get launch_search_game => 'Запустить / Искать Игры';

  @override
  String get patch_a_game => 'Патчить Игры';

  @override
  String get settings => 'Настройки';

  @override
  String get notifications => 'Уведомления';

  @override
  String get installing_a_patch => 'Устанавливаем Патч';

  @override
  String get installing_a_patch_description =>
      'Вы установите патч. Это действие необратимо.';

  @override
  String get installing_a_patch_end => 'Установка Завершена';

  @override
  String get thank_the_team_button => 'Thank the team';

  @override
  String get thank_the_team_description => 'Thank the team for the translation';

  @override
  String get can_close_popup => 'Вы можете закрыть это окно';

  @override
  String get patch_unavailable => 'Патч недоступен';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Патчи установлены',
      one: 'Патч установлен',
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
  String get delete_version => 'Удаление версии';

  @override
  String get delete_version_description =>
      'Если вам надо сбросить игру, вы можете удалить данную версию игры. После этого вы сможете переустановить патчи.';

  @override
  String get description => 'Описание';

  @override
  String get patch_modification => 'Модификация патча';

  @override
  String get patch_modification_description =>
      'Этот патч изменяет игру следующим образом:';

  @override
  String get patch_modification_content_text =>
      'Изменение текстового содержимого игры';

  @override
  String get patch_modification_content_internal =>
      'Модификация внутренних файлов игры (изображения, тексты...)';

  @override
  String get patch_modification_content_subtitles =>
      'Изменение субтитров в игре';

  @override
  String patch_modification_content_website(String website) {
    return 'Модификация текстового контента клиента jackbox (доступно только на $website)';
  }

  @override
  String get patch_modification_content_audios => 'Модификация звука игры';

  @override
  String get version => 'Версия';

  @override
  String get authors => 'Автор(ы)';

  @override
  String get small_information => 'Информация';

  @override
  String get more_informations => 'Больше Информации';

  @override
  String get launch_game => 'Запустить игру';

  @override
  String get launch_game_fast_launcher => 'Запустить игру (Быстрый запуск)';

  @override
  String get launch_game_fast_launcher_description =>
      'Запускает игру в режиме быстрого запуска, который позволяет пропустить вступительный ролик пакета и выбор игры. Доступно только для некоторых игр.';

  @override
  String get launch_pack => 'Запустить игру';

  @override
  String get launch_pack_description => 'Запустить игру без изменений';

  @override
  String get launch_informations => 'Запуск Информации';

  @override
  String get launching => 'Запускаем...';

  @override
  String get launched => 'Запущено!';

  @override
  String get path_not_found => 'Путь не найден';

  @override
  String get path_not_found_small_description => 'Путь к игре не найден.';

  @override
  String get path_not_found_description =>
      'Путь к игре не найден. Проверьте, что игра установлена и что путь к ней указан правильно.';

  @override
  String get path_inexistant => 'Путь не найден';

  @override
  String get path_inexistant_small_description =>
      'Вы не добавили путь к пакету';

  @override
  String get path_inexistant_description =>
      'Вы не добавили путь в пакет. Вы можете сделать это в настройках';

  @override
  String get pack_path => 'Путь к игре';

  @override
  String get owned_packs => 'Установленные Игры';

  @override
  String get add_pack => 'Добавить игру';

  @override
  String get choose_pack => 'Выбрать игру';

  @override
  String get game_type_coop => 'Кооп';

  @override
  String get game_type_coop_description =>
      'В этих играх, players must work together to win.';

  @override
  String get game_type_versus => 'Free For All';

  @override
  String get game_type_versus_description =>
      'В этих играх, каждый игрок играет за себя и должен победить остальных.';

  @override
  String get game_type_team => 'Команды';

  @override
  String get game_type_team_description =>
      'В этих играх, игроки поделены на разные команды и должны работать вместе чтобы победить.';

  @override
  String game_translation_translated(String language) {
    return 'Официально переведено на $language';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Эти игры официально переведены на $language.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Эти игры переведены на Французский , Итальянский, Немецкий и Испанский командой Jackbox Games.';

  @override
  String get game_translation_community_translated => 'Переведено сообществом';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Эти игры переведены сообществом.';
  }

  @override
  String get game_translation_not_available => 'На английском';

  @override
  String game_translation_not_available_description(String language) {
    return 'Эти игры не переведены на $language.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Эти игры доступны только на английском.';

  @override
  String get downloading => 'Загрузка';

  @override
  String get starting => 'Начало';

  @override
  String get extracting => 'Распаковка';

  @override
  String get finalizing => 'Завершение';

  @override
  String get unknown_error => 'Неизвестная Ошибка';

  @override
  String get contact_error => 'Свяжитесь с Alexisl61 в Discord (на английском)';

  @override
  String get game_patch_unavailable => 'Патч недоступен';

  @override
  String get game_patch_available => 'Патч доступен';

  @override
  String get game_patch_installed => 'У вас установлена последняя версия патча';

  @override
  String get game_patch_outdated => 'Обновление к патчу доступно';

  @override
  String get players => 'игроков';

  @override
  String get search_game => 'Найти игру';

  @override
  String get search => 'Поиск';

  @override
  String get all_games => 'Все игры';

  @override
  String get all_games_description => 'Найдите все игры Jackbox в одном месте';

  @override
  String get search_by_pack => 'Найти по паку';

  @override
  String get search_by_type => 'Найти по типу';

  @override
  String get search_by_translation => 'Найти по переводу';

  @override
  String get search_by_tags => 'Найти по тегу';

  @override
  String get select_server_subtitle => 'Выберите один из доступных серверов';

  @override
  String get select_server_loading => 'Загрузка серверов...';

  @override
  String get select_server_button => 'Выбрать';

  @override
  String connected_to_server(String server) {
    return 'Подключение к серверу $server';
  }

  @override
  String get connected_to_server_change => 'Сменить';

  @override
  String get connection_to_server_failed => 'Подключение к серверу прервано.';

  @override
  String get connection_to_main_server_failed =>
      'Подключение ко всем серверам прервано.';

  @override
  String get quit_while_downloading_title => 'Установка';

  @override
  String get quit_while_downloading_description =>
      'Сейчас происходит установка, вы уверены, что хотите выйти?';

  @override
  String get automatic_game_finder_title => 'Автоматический поиск игры';

  @override
  String get automatic_game_finder_description =>
      'Jackbox Utility может найти установленные игры используя Steam и Epic Games.\nВы хотите использовать эту функцию?';

  @override
  String get automatic_game_finder_in_progress =>
      'Поиск игр, пожалуйста подождите';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Игр найдено: $count',
      one: 'Игр найдено: 1',
      zero: 'Игр не найдено',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Сервер найден';

  @override
  String automatic_server_finder_found_description(String server) {
    return 'Сервер $server был выбран на основе вашего языка.';
  }

  @override
  String get show_all_packs => 'Показать не приобретённые игры';

  @override
  String get show_owned_packs_only => 'Показать приобретённые игры';

  @override
  String get all_patches => 'Все патчи';

  @override
  String get error_happened => 'Произошла ошибка';

  @override
  String get jackbox_utility_description =>
      'Приложение с открытым исходным кодом для загрузки патчей и запуска игр Jackbox.';

  @override
  String get server_information => 'О сервере (Язык)';

  @override
  String get selected_server => 'Выбранный сервер';

  @override
  String get change_server => 'Сменить сервер';

  @override
  String get app_information => 'О приложении';

  @override
  String get automatic_game_finder_button => 'Найти установленные игры';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Игр доступно: $count',
      one: 'Игр доступно: 1',
      zero: 'Нет доступных игр',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Автор';

  @override
  String get contributors => 'Участники';

  @override
  String in_language(String language) {
    return 'На $language языке';
  }

  @override
  String in_language_description(String language) {
    return 'Эти игры доступны на $language языке (официально или переведены сообществом.)';
  }

  @override
  String get game_community_dubbed => 'Озвучено сообществом';

  @override
  String get game_community_dubbed_description =>
      'Эти игры озвучены сообществом.';

  @override
  String game_dubbed(String language) {
    return 'Озвучено на $language языке';
  }

  @override
  String get game_dubbed_description =>
      'Эти игру озвучены сообщестом или Jackbox.';

  @override
  String get no_game_in_this_category_title => 'В данной категории нет игр';

  @override
  String get no_game_in_this_category_description =>
      'В этой категории нет игр. Добавьте ещё игр в секции Настроек.';

  @override
  String select_game_location(String game) {
    return 'Выберите путь к $game';
  }

  @override
  String get download_error => 'Ошибка загрузки';

  @override
  String get download_error_description =>
      'Произошла ошибка во время загрузки игры. Пожалуйста удостоверьтесь, что ваше интернет соединение работает корректно.';

  @override
  String get extracting_error => 'Ошибка распаковки';

  @override
  String get extracting_error_description =>
      'Произошла ошибка во время распаковки игры. Проверьте, достаточно ли у вас свободного места в памяти, и повторите попытку.';

  @override
  String get game_reset => 'Сброс игры';

  @override
  String get game_reset_description =>
      'Это приведет к проверке всех файлов этой игры. Если вы установили какой-либо патч, он будет удален из вашей игры. Вы уверены, что хотите продолжить?';

  @override
  String get small_description => 'Описание';

  @override
  String get patreon_subscribers => 'Подписчики Patreon';

  @override
  String get audience => 'Зрители';

  @override
  String get confirmation => 'Подтверждение';

  @override
  String confirmation_description(String action) {
    return 'Вы точно хотите $action? Это действие необратимо.';
  }

  @override
  String get fix => 'Фикс';

  @override
  String get fixes_available => 'Фикс YDKJ Vol. 6';

  @override
  String get fixes_available_description =>
      'You Don\'t Know Jack Vol. 6 The Lost Gold была обнаружена как одна из установленных игр. Эта игра обычно не работает на Windows 10/11 и Linux. Вы хотите скачать и установить исправляющий это патч? Вы всегда можете установить его на соответствующей вкладке информации об игре.';

  @override
  String get filter_players_number => 'Кол-во Игроков';

  @override
  String get family_friendly => 'Семейный Режим';

  @override
  String get optional => 'Опционально';

  @override
  String get subtitles => 'Субтитры';

  @override
  String get stream_friendly => 'Для Стримеров';

  @override
  String get moderation => 'Модерация';

  @override
  String get randomize_button_text => 'Давайте другую!';

  @override
  String get feeling_lucky => 'Мне повезёт';

  @override
  String sort_by(String type) {
    return 'Сортировать по $type';
  }

  @override
  String get filter => 'Фильтр';

  @override
  String get show_games_hidden => 'Показать игры, которые вы скрыли';

  @override
  String get hide_games_hidden => 'Скрыть скрытые игры';

  @override
  String get max_playtime => 'Максимальное время игры';

  @override
  String get search_by_ranking => 'Поиск по рейтингу';

  @override
  String get random_game => 'Случайная игра';

  @override
  String get personal_ranking => 'Личный рейтинг';

  @override
  String get ranked_by_stars => 'Ранжирование по звездам';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Games ranked by stars from your personal ranking.';

  @override
  String get unranked => 'Без рейтинга';

  @override
  String get app_behavior => 'Поведение приложений';

  @override
  String get settings_app_startup_category => 'Запуск приложений';

  @override
  String get settings_app_startup_title =>
      'Открывать лаунчер при запуске приложения';

  @override
  String get settings_app_startup_description =>
      'Открывать список игр при открытии приложения';

  @override
  String get settings_discord_rich_presence_category =>
      'Настройки Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_title => 'Discord Rich Presence';

  @override
  String get settings_discord_rich_presence_description =>
      'Показывает, во что вы играете в Discord. Это будет работать только в том случае, если у вас открыт Discord.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Показывать кнопки поддержки';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Показывает кнопки ссылок на GitHub и Discord приложения в вашем Discord Rich Presence.';

  @override
  String get settings_audio_category => 'Аудио';

  @override
  String get settings_sfx_title => 'Включить SFX';

  @override
  String get settings_sfx_description =>
      'Включает звуковые эффекты в приложении';

  @override
  String get settings_app_saves_category => 'Сохранения приложений';

  @override
  String get settings_app_reset_stars_title => 'Сбросить звезды';

  @override
  String get settings_app_reset_stars_description =>
      'Сбрасывает все звезды для каждой игры';

  @override
  String get settings_app_reset_stars_button_text => 'Сбросить звезды';

  @override
  String get settings_app_reset_stars_action =>
      'Сбросить все звезды для каждой игры';

  @override
  String get settings_app_reset_hidden_title => 'Сбросить скрытые игры';

  @override
  String get settings_app_reset_hidden_description =>
      'Сбросить все скрытые игры до видимых';

  @override
  String get settings_app_reset_hidden_button_text => 'Сбросить скрытые игры';

  @override
  String get settings_app_reset_hidden_action =>
      'Сбросить все скрытые игры на видимые';

  @override
  String get rich_presence_application_start_details =>
      'Только что запустил приложение';

  @override
  String get rich_presence_application_start_state => 'В меню';

  @override
  String get rich_presence_game_menu_details => 'Выбор игры';

  @override
  String get rich_presence_game_menu_state => 'В списке игр';

  @override
  String get rich_presence_game_information_details =>
      'Чтение информации об игре';

  @override
  String get rich_presence_game_information_state => 'Выбор игры';

  @override
  String get rich_presence_patcher_details => 'Патчить игру';

  @override
  String get rich_presence_patcher_state => 'В списке патчей';

  @override
  String get rich_presence_settings_details => 'Настройка приложения';

  @override
  String get rich_presence_settings_state => 'В настройках';

  @override
  String get rich_presence_in_game_details => 'В игре';

  @override
  String get open_launcher_on_startup_title_tip =>
      'Открывать лаунчер при запуске';

  @override
  String get open_launcher_on_startup_description_tip =>
      'Приложение может запускаться на этом экране при автоматическом запуске. Хотите ли вы активировать эту функцию? (Это всегда можно изменить в настройках)';

  @override
  String get minutes => 'минут';

  @override
  String get translation => 'Перевод';

  @override
  String get using_beta_version_text =>
      'Вы используете бета-версию приложения. Если у вас возникнут какие-либо проблемы, сообщите о них на сервере Discord или в репозитории Github.';

  @override
  String get pack => 'Пак';

  @override
  String get stars => 'Звёзд';

  @override
  String get name => 'Название';

  @override
  String get players_number => 'Количество Игроков';

  @override
  String get donate => 'Донат';

  @override
  String get installed_version => 'Установленная Версия';

  @override
  String get filter_available => 'Доступно';

  @override
  String get filter_fully_playable => 'Полностью Играемо';

  @override
  String get filter_midly_playable => 'Почти Играемо';

  @override
  String get filter_playable => 'Играемо';

  @override
  String get filter_full_moderation => 'Полная Модерация';

  @override
  String get filter_censoring => 'Цензура';

  @override
  String get filter_moderation_censoring => 'Модерация и Цензура';

  @override
  String get filter_dubbed => 'Озвучено';

  @override
  String get filter_translated => 'Переведено';

  @override
  String get special_thanks => 'Отдельное Спасибо';

  @override
  String get stream_friendly_tooltip =>
      'Если вы можете играть в эту игру через стрим, то есть на стриминговой платформе или делиться своим экраном через Discord, Zoom, Meet и т.д.';

  @override
  String get family_friendly_tooltip =>
      'Если в эту игру можно играть всей семьей (включая детей)';

  @override
  String get moderation_tooltip =>
      'Есть ли в этой игре система модерации (принимает, отклоняет или цензурирует экранные сообщения игроков)';

  @override
  String get audience_tooltip =>
      'Принимает ли игра зрителей (до 10.000, если не указано иное) для участия в игре после того, как к ней присоединились игроки.';

  @override
  String get subtitles_tooltip =>
      'Если в этой игре есть субтитры, которые должны отображаться на экране.';

  @override
  String get custom_server_title => 'Пользовательский сервер';

  @override
  String get custom_server_description =>
      'Используйте ссылку для подключения к пользовательскому серверу.';

  @override
  String get custom_server_explanation =>
      'Используйте ссылку на файл info.json пользовательского сервера, чтобы подключиться к нему.';

  @override
  String get custom_server_error => 'Не удалось восстановить сервер по ссылке.';

  @override
  String get custom_server_warning =>
      'Если кто-то попросил вас добавить туда ссылку, скорее всего, это мошенничество. Не продолжайте, если вы не доверяете владельцу этого сервера.';

  @override
  String get custom_server_add_question =>
      'Вы хотите использовать этот сервер?';

  @override
  String get custom_server_link => 'Пользовательская ссылка на сервер';

  @override
  String get loading_initialization_failed =>
      'Не удалось инициализировать приложение.';

  @override
  String get loading_connection_failed => 'Не удалось подключиться к серверу.';

  @override
  String get loading_save_failed => 'Не удалось получить ваши сохранения.';

  @override
  String get loading_open_issue_discord =>
      'Пожалуйста, откройте проблему на GitHub или сообщите о ней в Discord.';

  @override
  String get loading_check_internet_connection =>
      'Пожалуйста, проверьте подключение к Интернету и повторите попытку.';

  @override
  String get loading_try_again => 'Попробовать еще раз';

  @override
  String get settings_anonymous_data_title => 'Анонимный сбор данных';

  @override
  String get settings_anonymous_data_description =>
      'Помогите нам улучшить приложение, отправив анонимные данные о том, как вы используете приложение.';

  @override
  String get privacy_info => 'Примечание о конфиденциальности';

  @override
  String get privacy_description =>
      'Это приложение собирает анонимную статистику для улучшения приложения. Вы можете отключить это в настройках.';

  @override
  String get hidden_button_tooltip =>
      'Нажмите чтобы спрятать игру из списка игр.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Нажмите чтобы показать игру в списке игр.';

  @override
  String get patch_missing_before_launching_title => 'Патч отсутствует';

  @override
  String get patch_missing_before_launching_description =>
      'Обнаружено обновление для этой игры. Вы хотите установить его перед запуском игры?';

  @override
  String get patch_missing_before_launching_install => 'Установить обновление';

  @override
  String get patch_missing_before_launching_launch => 'Запустить игру';
}
