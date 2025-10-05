// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get close => 'Kapat';

  @override
  String get cancel => 'İptal';

  @override
  String get page_continue => 'Devam Et';

  @override
  String get confirm => 'Onayla';

  @override
  String get quit => 'Çıkış';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'OK';

  @override
  String get jackbox_utility => 'Jackbox İzlencesi';

  @override
  String get launch_search_game => 'Oyun Çalıştır / Ara';

  @override
  String get patch_a_game => 'Oyun Yamaları';

  @override
  String get settings => 'Ayarlar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get installing_a_patch => 'Yama Yüklemesi';

  @override
  String get installing_a_patch_description =>
      'Bu yamayı yükleyeceksiniz. Bu işlem geri alınamaz.';

  @override
  String get installing_a_patch_end => 'Yükleme Tamamlandı';

  @override
  String get thank_the_team_button => 'Thank the team';

  @override
  String get thank_the_team_description => 'Thank the team for the translation';

  @override
  String get can_close_popup => 'Bu mesaj kutusunu kapatabilirsiniz';

  @override
  String get patch_unavailable => 'Yama Mevcut Değil';

  @override
  String patch_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yama indirildi',
      one: 'Yama indirildi',
    );
    return '$_temp0';
  }

  @override
  String patch_outdated(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yamaları güncelle',
      one: 'Yamayı güncelle',
    );
    return '$_temp0';
  }

  @override
  String patch_not_installed(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yamaları indir',
      one: 'Yamayı indir',
    );
    return '$_temp0';
  }

  @override
  String get delete_version => 'Sürümü Sil';

  @override
  String get delete_version_description =>
      'Eğer oyununuzu sıfırladıysanız, bu oyunun yüklenmiş sürümünü silebilirsiniz. Bu size yamaları yeniden indirmenize izin verir.';

  @override
  String get description => 'Açıklama';

  @override
  String get patch_modification => 'Yama modifikasyonu';

  @override
  String get patch_modification_description =>
      'Bu yamanın, oyununuza yapacağı değişiklikler:';

  @override
  String get patch_modification_content_text =>
      'Oyunun metin içeriği modifikasyonu';

  @override
  String get patch_modification_content_internal =>
      'Oyunun iç dosyalarının (görüntü, metin...) modifikasyonu';

  @override
  String get patch_modification_content_subtitles =>
      'Oyunun altyazılarının modifikasyonu';

  @override
  String patch_modification_content_website(String website) {
    return 'Jackbox kumandasının metinsel modifikasyonu (yalnızda $website adresinde mevcuttur)';
  }

  @override
  String get patch_modification_content_audios => 'Oyun sesinin modifikasyonu';

  @override
  String get version => 'Sürüm';

  @override
  String get authors => 'Yazarlar';

  @override
  String get small_information => 'Bilgi';

  @override
  String get more_informations => 'Daha Fazla Bilgi';

  @override
  String get launch_game => 'Oyunu Çalıştır';

  @override
  String get launch_game_fast_launcher => 'Oyunu Çalıştır (Hızlı Çalıştırıcı)';

  @override
  String get launch_game_fast_launcher_description =>
      'Oyunu hızlı çalıştırıcı moduyla çalıştırır ve seçtiğiniz oyunun intro videosunu ve paket seçimini atlamanıza izin verir. Sadece bazı oyunlar için mevcuttur.';

  @override
  String get launch_pack => 'Oyunu Çalıştır';

  @override
  String get launch_pack_description => 'Paketi normal bir şekilde çalıştırır';

  @override
  String get launch_informations => 'Çalıştırma Bilgisi';

  @override
  String get launching => 'Çalıştırılıyor...';

  @override
  String get launched => 'Çalıştırıldı!';

  @override
  String get path_not_found => 'Dosya Konumu Bulunamadı';

  @override
  String get path_not_found_small_description =>
      'Oyun dosyasının konumu bulunamadı.';

  @override
  String get path_not_found_description =>
      'Oyun dosyasının konumu bulunamadı. Lütfen oyunun yüklü olduğunu ve dosya yolunun doğru olduğunu kontrol edin.';

  @override
  String get path_inexistant => 'Dosya Konumu Yok';

  @override
  String get path_inexistant_small_description =>
      'Paketi konumlara eklemediniz.';

  @override
  String get path_inexistant_description =>
      'Paketi konumlara eklemediniz. Bunu ayarlarda yapabilirsiniz.';

  @override
  String get pack_path => 'Oyun konumu';

  @override
  String get owned_packs => 'Sahip Olunan Oyunlar';

  @override
  String get add_pack => 'Oyun Ekle';

  @override
  String get choose_pack => 'Oyun Seç';

  @override
  String get game_type_coop => 'Kooperatif';

  @override
  String get game_type_coop_description =>
      'Bu oyunlarda oyuncular, kazanmak için hep beraber çalışırlar.';

  @override
  String get game_type_versus => 'Kendi Başına';

  @override
  String get game_type_versus_description =>
      'Bu oyunlarda, her oyuncu kendisi için oynar ve diğer oyuncuları yenmesi gerekmektedir.';

  @override
  String get game_type_team => 'Takımlı';

  @override
  String get game_type_team_description =>
      'Bu oyunlarda, oyuncular takımlara ayrılıp kazanmak için beraber çalışırlar.';

  @override
  String game_translation_translated(String language) {
    return 'Resmi Olarak $language Diline Çevrildi';
  }

  @override
  String game_translation_translated_description(String language) {
    return 'Bu oyunlar $language diline resmi olarak çevrildi.';
  }

  @override
  String get game_translation_translated_description_en =>
      'Bu oyunlar, Jackbox Games tarafından Fransızca, İtalyanca, Almanca ve İspanyolca dillerine çevrildi.';

  @override
  String get game_translation_community_translated =>
      'Topluluk Tarafından Çevrildi';

  @override
  String game_translation_community_translated_description(Object language) {
    return 'Bu oyunlar topluluk tarafından çevrilmiştir.';
  }

  @override
  String get game_translation_not_available => 'İngilizce Dilinde';

  @override
  String game_translation_not_available_description(String language) {
    return 'Bu oyunlar $language diline çevirilmemiştir.';
  }

  @override
  String get game_translation_not_available_description_en =>
      'Bu oyunlar yalnızca İngilizce dilinde mevcuttur.';

  @override
  String get downloading => 'İndiriliyor';

  @override
  String get starting => 'Başlatılıyor';

  @override
  String get extracting => 'Çıkartılıyor';

  @override
  String get finalizing => 'Sonlandırılıyor';

  @override
  String get unknown_error => 'Bilinmeyen Hata';

  @override
  String get contact_error =>
      'Discord üzerinden Alexis61 ile iletişime geçin (İngilizce görüşmeniz önerilir)';

  @override
  String get game_patch_unavailable => 'Yama mevcut değil';

  @override
  String get game_patch_available => 'Bir yama mevcut';

  @override
  String get game_patch_installed => 'Yama güncel';

  @override
  String get game_patch_outdated => 'Bu yama için bir güncelleme mevcuttur';

  @override
  String get players => 'oyuncular';

  @override
  String get search_game => 'Bir Oyun Ara';

  @override
  String get search => 'Ara';

  @override
  String get all_games => 'Tüm Oyunlar';

  @override
  String get all_games_description =>
      'Bütün Jackbox oyunlarını tek yerde bulun.';

  @override
  String get search_by_pack => 'Paket Olarak Ara';

  @override
  String get search_by_type => 'Tür Olarak Ara';

  @override
  String get search_by_translation => 'Çeviri Olarak Ara';

  @override
  String get search_by_tags => 'Etiket Olarak Ara';

  @override
  String get select_server_subtitle => 'Mevcut olan sunuculardan birini seçin';

  @override
  String get select_server_loading => 'Sunucular Yükleniyor...';

  @override
  String get select_server_button => 'Seç';

  @override
  String connected_to_server(String server) {
    return '$server sunucusuna bağlandı';
  }

  @override
  String get connected_to_server_change => 'Değiştir';

  @override
  String get connection_to_server_failed => 'Sunucuya Bağlanma Başarısız Oldu';

  @override
  String get connection_to_main_server_failed =>
      'Mevcut sunucuları listelerken bir hata oluştu.';

  @override
  String get quit_while_downloading_title => 'İndirme Devam Ediyor';

  @override
  String get quit_while_downloading_description =>
      'Bir indirme işlemi devam ediyor. Şimdi çıkmak istediğinizden emin misiniz?';

  @override
  String get automatic_game_finder_title => 'Otomatik Oyun Bulucu';

  @override
  String get automatic_game_finder_description =>
      'Jackbox İzlencesi, Steam ve Epic Games kullanılarak bu bilgisayarda yüklenen oyunları bulabilir.\nBu özelliği kullanmak ister misiniz?';

  @override
  String get automatic_game_finder_in_progress =>
      'Oyunlar bulunuyor, lütfen bekleyin';

  @override
  String automatic_game_finder_finish(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyun bulundu',
      one: '1 oyun bulundu',
      zero: 'Oyun Bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String get automatic_server_finder_found => 'Sunucu Bulundu';

  @override
  String automatic_server_finder_found_description(String server) {
    return '$server sunucusu, dilinize göre seçildi.';
  }

  @override
  String get show_all_packs => 'Sahip Olmadığım Oyunları Göster';

  @override
  String get show_owned_packs_only => 'Sadece Sahip Olduğum Oyunları Göster';

  @override
  String get all_patches => 'Tüm yamalar';

  @override
  String get error_happened => 'Bir hata oluştu';

  @override
  String get jackbox_utility_description =>
      'Jackbox oyunlarının yamalarını indiren ve çalıştıran bir açık kaynak uygulaması.';

  @override
  String get server_information => 'Sunucu Bilgisi (Dil)';

  @override
  String get selected_server => 'Seçilmiş Sunucu';

  @override
  String get change_server => 'Sunucu Değiştir';

  @override
  String get app_information => 'Uygulama Bilgisi';

  @override
  String get automatic_game_finder_button => 'Yüklenmiş oyunları otomatik bul';

  @override
  String games_available(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oyun mevcut',
      one: '1 oyun mevcut',
      zero: 'Mevcut oyun bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String get author => 'Yazar';

  @override
  String get contributors => 'Katkı Sağlayanlar';

  @override
  String in_language(String language) {
    return '$language Dilinde';
  }

  @override
  String in_language_description(String language) {
    return 'Bu oyunlar $language dilinde mevcuttur (orijinal olarak ya da topluluk çevirisi olarak.)';
  }

  @override
  String get game_community_dubbed => 'Topluluk Dublajı';

  @override
  String get game_community_dubbed_description =>
      'Bu oyunlar topluluk tarafından dublajlanmıştır.';

  @override
  String game_dubbed(String language) {
    return '$language Dilinde Dublajlandı';
  }

  @override
  String get game_dubbed_description =>
      'Bu oyunlar topluluk tarafından ya da Jackbox tarafından dublajlanmıştır.';

  @override
  String get no_game_in_this_category_title => 'Bu kategoride bir oyun yok';

  @override
  String get no_game_in_this_category_description =>
      'Bu kategoride bir oyun yok. Ayarlar menüsünden birkaç tane ekleyin.';

  @override
  String select_game_location(String game) {
    return '$game oyununun konumunu seçin';
  }

  @override
  String get download_error => 'İndirirken bir hata oluştu';

  @override
  String get download_error_description =>
      'Oyunu indirirken bir hata oluştu. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get extracting_error => 'Çıkartırken hata oluştu';

  @override
  String get extracting_error_description =>
      'Oyunu çıkartırken bir hata oluştu. Yeterince boş depolama alanı olduğundan emin olun ve yeniden deneyin.';

  @override
  String get game_reset => 'Oyunu Sıfırla';

  @override
  String get game_reset_description =>
      'Bu oyunun tüm dosyalarını doğrular. Eğer herhangi bir yama indirdiyseniz, oyununuzdan silinecektir. Devam etmek istediğinizden emin misiniz?';

  @override
  String get small_description => 'Açıklama';

  @override
  String get patreon_subscribers => 'Patreon Aboneleri';

  @override
  String get audience => 'Seyirciler';

  @override
  String get confirmation => 'İşlem Onayı';

  @override
  String confirmation_description(String action) {
    return '$action işlemini yapmak istediğinizden emin misiniz? Bu işlem geri alınamaz.';
  }

  @override
  String get fix => 'Düzeltme';

  @override
  String get fixes_available => 'Jack\'i Bilmiyorsun Vol. 6 Düzeltmesi';

  @override
  String get fixes_available_description =>
      'Jack\'i Bilmiyorsun Vol.6 Kayıp Altın yüklenmiş bir oyun olarak tespit edildi. Bu oyun normalde Windows 10/11 ve Linux işletim sistemlerine çalışmıyor. Bu sorunu düzelten yamayı indirip yüklemek istiyor musunuz? Her zaman belirtilen oyunun menüsünde yamayı yükleyebilirsiniz.';

  @override
  String get filter_players_number => 'Oyuncu Sayısı';

  @override
  String get family_friendly => 'Aile Dostu';

  @override
  String get optional => 'İsteğe Bağlı';

  @override
  String get subtitles => 'Altyazılar';

  @override
  String get stream_friendly => 'Yayın Dostu';

  @override
  String get moderation => 'Moderasyon';

  @override
  String get randomize_button_text => 'Başka Bir Tane Dene!';

  @override
  String get feeling_lucky => 'Kendimi Şanslı Hissediyorum';

  @override
  String sort_by(String type) {
    return '$type ile Sırala';
  }

  @override
  String get filter => 'Filtre';

  @override
  String get show_games_hidden => 'Gizlediğiniz Oyunları Göster';

  @override
  String get hide_games_hidden => 'Gizlediğiniz Oyunları Gizle';

  @override
  String get max_playtime => 'Maksimum Oynama Süresi';

  @override
  String get search_by_ranking => 'Puanlama ile Sırala';

  @override
  String get random_game => 'Rastgele Oyun';

  @override
  String get personal_ranking => 'Kişisel Puanlama';

  @override
  String get ranked_by_stars => 'Yıldızlarla Sıralama';

  @override
  String get games_ranked_by_stars_from_personal_ranking =>
      'Kişisel puanlarınızda verilen yıldızlara göre sıralanan oyunlar.';

  @override
  String get unranked => 'Puanlanmamış';

  @override
  String get app_behavior => 'Uygulama Davranışı';

  @override
  String get settings_app_startup_category => 'Uygulama Başlangıcı';

  @override
  String get settings_app_startup_title =>
      'Uygulama Başlangıcında Başlatıcıyı Aç';

  @override
  String get settings_app_startup_description =>
      'Uygulamayı açınca oyun listesini açar.';

  @override
  String get settings_discord_rich_presence_category =>
      'Discord Detaylı Etkinlik Ayarları';

  @override
  String get settings_discord_rich_presence_title => 'Discord Detaylı Etkinlik';

  @override
  String get settings_discord_rich_presence_description =>
      'Discord\'da ne oynadığınızı gösterir. Yalnızca Discord\'u açık tuttuğunuz zaman çalışır.';

  @override
  String get settings_discord_rich_presence_buttons_title =>
      'Destek Düğmelerini Göster';

  @override
  String get settings_discord_rich_presence_buttons_description =>
      'Uygulamanın GitHub ve Discord linklerini Discord Detaylı Etkinliğinizde düğmeler olarak gösterir.';

  @override
  String get settings_audio_category => 'Ses';

  @override
  String get settings_sfx_title => 'Ses Efektlerini Etkinleştir';

  @override
  String get settings_sfx_description =>
      'Uygulamada ses efektlerini etkinleştirir.';

  @override
  String get settings_app_saves_category => 'Uygulama Kayıtları';

  @override
  String get settings_app_reset_stars_title => 'Yıldızları Sıfırla';

  @override
  String get settings_app_reset_stars_description =>
      'Her oyun için yıldızları sıfırlar.';

  @override
  String get settings_app_reset_stars_button_text => 'Yıldızları Sıfırla';

  @override
  String get settings_app_reset_stars_action =>
      'her oyun için yıldızları sıfırlar';

  @override
  String get settings_app_reset_hidden_title => 'Gizli Oyunları Sıfırla';

  @override
  String get settings_app_reset_hidden_description =>
      'Tüm gizli oyunları görünür hâle getirir.';

  @override
  String get settings_app_reset_hidden_button_text => 'Gizli Oyunları Sıfırla';

  @override
  String get settings_app_reset_hidden_action =>
      'tüm gizli oyunları görünür hâle getirir';

  @override
  String get rich_presence_application_start_details =>
      'Şimdi Uygulamayı Başlattı';

  @override
  String get rich_presence_application_start_state => 'Menüde';

  @override
  String get rich_presence_game_menu_details => 'Bir Oyun Seçiyor';

  @override
  String get rich_presence_game_menu_state => 'Oyun Listesinde';

  @override
  String get rich_presence_game_information_details =>
      'Bir Oyun Hakkında Bilgileri Okuyor';

  @override
  String get rich_presence_game_information_state => 'Bir Oyun Seçiyor';

  @override
  String get rich_presence_patcher_details => 'Bir Oyun Yamalıyor';

  @override
  String get rich_presence_patcher_state => 'Yama Listesinde';

  @override
  String get rich_presence_settings_details =>
      'Uygulamanın Ayarlarını Değiştiriyor';

  @override
  String get rich_presence_settings_state => 'Ayarlarda';

  @override
  String get rich_presence_in_game_details => 'Oyunda';

  @override
  String get open_launcher_on_startup_title_tip => 'Başlangıçta Başlatıcıyı Aç';

  @override
  String get open_launcher_on_startup_description_tip =>
      'Bu uygulama açıldığı zaman otomatik olarak bu ekran hâlinde açılabilir. Bu özelliği etkinleştirmek ister misiniz? (Bu özellik her zaman ayarlardan değiştirilebilir.)';

  @override
  String get minutes => 'dakika';

  @override
  String get translation => 'Çeviri';

  @override
  String get using_beta_version_text =>
      'Uygulamanın beta sürümünü kullanıyorsunuz. Eğer herhangi bir sorunla karşılaşırsanız, lütfen Discord sunucusunda ya da GitHub sayfasında bildirin.';

  @override
  String get pack => 'Paket';

  @override
  String get stars => 'Yıldızlar';

  @override
  String get name => 'İsim';

  @override
  String get players_number => 'Oyuncu Sayısı';

  @override
  String get donate => 'Bağış Yap';

  @override
  String get installed_version => 'Yüklenmiş Sürüm';

  @override
  String get filter_available => 'Mevcut';

  @override
  String get filter_fully_playable => 'Tam Uygun';

  @override
  String get filter_midly_playable => 'Kısmen Uygun';

  @override
  String get filter_playable => 'Uygun';

  @override
  String get filter_full_moderation => 'Tam Moderasyon';

  @override
  String get filter_censoring => 'Sansürleme';

  @override
  String get filter_moderation_censoring => 'Moderasyon & Sansürleme';

  @override
  String get filter_dubbed => 'Dublajlı';

  @override
  String get filter_translated => 'Çevirildi';

  @override
  String get special_thanks => 'Özel Teşekkürler';

  @override
  String get stream_friendly_tooltip =>
      'Bu oyunu bir yayın platformundaki bir yayında ya da Discord, Zoom, Google Meet aramasındaki ekran paylaşımında oynanabileceği ya da oynanamayacağı gösterilir.';

  @override
  String get family_friendly_tooltip =>
      'Bu oyunun tüm aile bireyleri (çocuklar dahil) tarafından oynanabileceği ya da oynanamayacağı gösterilir.';

  @override
  String get moderation_tooltip =>
      'Bu oyunun bir moderasyon (oyuncu yanıtlarını kabul eden, reddeden ya da sansürleyen) sisteminin olduğu ya da olmadığı gösterilir.';

  @override
  String get audience_tooltip =>
      'Bu oyunun oyuncular katıldıktan sonra seyirci üyelerini (eğer aksi bahsedilmezse 10,000\'e kadar) kabul ettiği ya da etmediği gösterilir.';

  @override
  String get subtitles_tooltip =>
      'Eğer oyunun ekranda görünen altyazıların olduğu ya da olmadığı gösterilir.';

  @override
  String get custom_server_title => 'Özel Sunucu';

  @override
  String get custom_server_description =>
      'Özel bir sunucuya bağlanmak için bir link kullanın.';

  @override
  String get custom_server_explanation =>
      'Özel bir sunucuda bulunan info.json dosyasına giden bir link kullanın.';

  @override
  String get custom_server_error => 'Linkten bir sunucu bulunamadı.';

  @override
  String get custom_server_warning =>
      'Eğer birisi size oraya bir link eklemesini istediyse, bir dolandırıcı olabilir. Eğer bu sunucunun sahibine güvenmiyorsanız devam etmeyin.';

  @override
  String get custom_server_add_question =>
      'Bu sunucuyu kullanmak istiyor musunuz?';

  @override
  String get custom_server_link => 'Özel sunucu linki';

  @override
  String get loading_initialization_failed => 'Uygulama başlatılamadı.';

  @override
  String get loading_connection_failed => 'Sunucuya bağlanılamadı.';

  @override
  String get loading_save_failed => 'Kayıt dosyalarınız alınamadı.';

  @override
  String get loading_open_issue_discord =>
      'Lütfen GitHub\'da bir problem oluşturun ya da Discord\'da bildirin.';

  @override
  String get loading_check_internet_connection =>
      'Lütfen internet bağlantınızı kontrol edin ve yeniden deneyin.';

  @override
  String get loading_try_again => 'Yeniden Dene';

  @override
  String get settings_anonymous_data_title => 'Anonim veri toplaması';

  @override
  String get settings_anonymous_data_description =>
      'Bu uygulamanın kullanımını anonim olarak göndererek bu uygulamayı daha iyi hale getirmemize yardım edin.';

  @override
  String get privacy_info => 'Gizlilik notu';

  @override
  String get privacy_description =>
      'Bu uygulamayı iyileştirme sebebiyle, bu uygulama anonim istatistik topluyor. Bunu ayarlarda devre dışı bırakabilirsiniz.';

  @override
  String get hidden_button_tooltip =>
      'Bu oyunu listeden gizlemek için tıklayın.';

  @override
  String get hidden_button_hidden_tooltip =>
      'Bu oyunu listede göstermek için tıklayın.';

  @override
  String get patch_missing_before_launching_title => 'Yama Eksik';

  @override
  String get patch_missing_before_launching_description =>
      'Bu oyun için bir yama mevcut. Oyunu başlatmadan önce kurmak ister misiniz?';

  @override
  String get patch_missing_before_launching_install => 'Yamayı Kur';

  @override
  String get patch_missing_before_launching_launch => 'Oyunu Başlat';
}
