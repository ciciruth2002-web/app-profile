import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('id'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('id', 'ID'),
    Locale('en', 'US'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'app_title': 'Portal Profil & Layanan Publik',
      'nav_home': 'Beranda',
      'nav_news': 'Berita',
      'nav_questions': 'Tanya Jawab',
      'nav_faq': 'FAQ',
      'nav_settings': 'Pengaturan',
      'language': 'Bahasa',
      'change_language': 'Ganti Bahasa',
      'indonesian': 'Bahasa Indonesia',
      'english': 'English',
      'latest_news': 'Berita & Artikel Terkini',
      'featured_news': 'Berita Utama',
      'view_all': 'Lihat Semua',
      'read_more': 'Baca Selengkapnya',
      'quick_menu': 'Menu Layanan',
      'categories': 'Kategori',
      'all_categories': 'Semua',
      'search_hint_news': 'Cari berita, pengumuman...',
      'search_hint_faq': 'Cari pertanyaan umum...',
      'search_hint_question': 'Cari topik atau pertanyaan...',
      'no_data': 'Belum ada data tersedia',
      'retry': 'Coba Lagi',
      'loading': 'Memuat data...',
      'error_loading': 'Gagal memuat data. Periksa koneksi backend Anda.',
      'public_questions': 'Kanal Aspirasi & Tanya Jawab',
      'submit_question': 'Kirim Pertanyaan',
      'submit_question_desc': 'Sampaikan permohonan informasi, masukan, atau pertanyaan langsung ke instansi.',
      'question_form_title': 'Formulir Pertanyaan Masyarakat',
      'field_name': 'Nama Lengkap',
      'field_name_hint': 'Masukkan nama lengkap Anda',
      'field_email': 'Alamat Email',
      'field_email_hint': 'contoh@domain.com',
      'field_phone': 'Nomor Telepon / WhatsApp',
      'field_phone_hint': '0812xxxxxxxx',
      'field_topic': 'Topik Pertanyaan',
      'field_select_topic': 'Pilih topik yang sesuai',
      'field_subject': 'Subjek Pertanyaan',
      'field_subject_hint': 'Ringkasan pertanyaan atau judul',
      'field_body': 'Isi Pertanyaan / Aspirasi',
      'field_body_hint': 'Jelaskan pertanyaan atau informasi yang dibutuhkan secara rinci...',
      'btn_submit': 'Kirimkan Sekarang',
      'sending': 'Mengirimkan...',
      'success_submit': 'Pertanyaan Anda berhasil dikirim! Tim kami akan meninjau dan menjawab pertanyaan Anda.',
      'error_submit': 'Gagal mengirim pertanyaan. Silakan periksa formulir Anda.',
      'answered_status': 'Sudah Dijawab',
      'pending_status': 'Sedang Diproses',
      'official_answer': 'Tanggapan Resmi Instansi',
      'answered_by': 'Dijawab oleh Admin Instansi',
      'faq_title': 'Frequently Asked Questions (FAQ)',
      'faq_subtitle': 'Jawaban cepat untuk pertanyaan yang sering ditanyakan masyarakat.',
      'about_institution': 'Profil Instansi',
      'vision_mission': 'Visi & Misi',
      'org_structure': 'Struktur Organisasi',
      'contact_us': 'Hubungi Kami',
      'share': 'Bagikan',
      'published_at': 'Diterbitkan',
      'views': 'dibaca',
      'system_settings': 'Preferensi Aplikasi',
      'theme_mode': 'Tampilan / Tema',
      'app_version': 'Versi Aplikasi',
      'backend_status': 'Status Backend API',
    },
    'en': {
      'app_title': 'Institutional Profile & Public Portal',
      'nav_home': 'Home',
      'nav_news': 'News',
      'nav_questions': 'Q&A',
      'nav_faq': 'FAQ',
      'nav_settings': 'Settings',
      'language': 'Language',
      'change_language': 'Change Language',
      'indonesian': 'Indonesian',
      'english': 'English',
      'latest_news': 'Latest News & Articles',
      'featured_news': 'Featured News',
      'view_all': 'View All',
      'read_more': 'Read More',
      'quick_menu': 'Services Menu',
      'categories': 'Categories',
      'all_categories': 'All',
      'search_hint_news': 'Search news, announcements...',
      'search_hint_faq': 'Search common questions...',
      'search_hint_question': 'Search topics or questions...',
      'no_data': 'No data available yet',
      'retry': 'Retry',
      'loading': 'Loading data...',
      'error_loading': 'Failed to load data. Please check your backend connection.',
      'public_questions': 'Public Aspirations & Inquiries',
      'submit_question': 'Ask a Question',
      'submit_question_desc': 'Submit information requests, feedback, or inquiries directly to our institution.',
      'question_form_title': 'Public Inquiry Form',
      'field_name': 'Full Name',
      'field_name_hint': 'Enter your full name',
      'field_email': 'Email Address',
      'field_email_hint': 'example@domain.com',
      'field_phone': 'Phone Number / WhatsApp',
      'field_phone_hint': '+62xxxxxxxx',
      'field_topic': 'Inquiry Topic',
      'field_select_topic': 'Select appropriate topic',
      'field_subject': 'Subject',
      'field_subject_hint': 'Summary or title of your inquiry',
      'field_body': 'Inquiry Details',
      'field_body_hint': 'Describe your question or needed information in detail...',
      'btn_submit': 'Submit Now',
      'sending': 'Submitting...',
      'success_submit': 'Your inquiry has been submitted! Our team will review and respond soon.',
      'error_submit': 'Failed to submit inquiry. Please review your form entries.',
      'answered_status': 'Answered',
      'pending_status': 'Pending Review',
      'official_answer': 'Official Institutional Response',
      'answered_by': 'Answered by Institutional Admin',
      'faq_title': 'Frequently Asked Questions (FAQ)',
      'faq_subtitle': 'Quick answers to the most common public inquiries.',
      'about_institution': 'Institutional Profile',
      'vision_mission': 'Vision & Mission',
      'org_structure': 'Organizational Structure',
      'contact_us': 'Contact Us',
      'share': 'Share',
      'published_at': 'Published',
      'views': 'views',
      'system_settings': 'App Preferences',
      'theme_mode': 'Theme / Appearance',
      'app_version': 'App Version',
      'backend_status': 'Backend API Status',
    },
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ??
        _localizedValues['id']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['id', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

