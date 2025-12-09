import 'package:flutter/material.dart';
import 'package:pressly/models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  final List<AppLanguage> supportedLanguages = [
    AppLanguage(codd: 'en', name: 'English', flag: '🇺🇸'),
    AppLanguage(codd: 'id', name: 'Indonesia', flag: "id")
  ];

  late AppLanguage currentLanguage = supportedLanguages.first;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCode = prefs.getString('language_code');
    if (savedCode != null) {
      final found = supportedLanguages.where((element) => element.codd == savedCode);
      if (found.isNotEmpty) {
        currentLanguage = found.first;
        notifyListeners();
      }
    }
  }

  Future<void> changeLanguage(String code) async {
    final found = supportedLanguages.where((element) => element.codd == code);
    if (found.isNotEmpty) {
      currentLanguage = found.first;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', code);
    }
  }

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'menu': 'Menu',
      'login_message': 'Login To Get More Experience',
      'login': 'Login',
      'home': 'Home',
      'select_language': 'Select Language',
      'dark_mode': 'Dark Mode',
      'version': 'Version',
      'news': 'News',
      'video': 'Video',
      'search': 'Search',
      'login_subtitle': 'Use the service below to log in to Pressly',
      'login_google': 'Login With Google',
      'or': 'or',
      'login_email_title': 'Login With Your Email :',
      'email': 'Email',
      'email_hint': 'input your email Here...',
      'password': 'Password',
      'password_hint': 'input your password here...',
      'no_account': 'Don\'t Have an Account Yet? ',
      'register_here': 'Register here',
      'register': 'Register',
      'register_subtitle': 'Use the service below to register for Pressly.',
      'register_google': 'Register With Google',
      'register_email_title': 'Register Using Your Email (FREE) :',
      'enter_email_hint': 'Enter your account email...',
      'enter_password_hint': 'Enter your account password...',
      'repeat_password': 'Repeat Password',
      'repeat_password_hint': 'Enter Previous Password...',
      'i_agree': 'I agree ',
      'terms_conditions': 'Terms and Conditions',
      'and': ' and\n',
      'privacy_policy': 'Privacy Policy',
    },
    'id': {
      'menu': 'Menu',
      'login_message': 'Masuk Untuk Pengalaman Lebih',
      'login': 'Masuk',
      'home': 'Beranda',
      'select_language': 'Pilih Bahasa',
      'dark_mode': 'Mode Gelap',
      'version': 'Versi',
      'news': 'Berita',
      'video': 'Video',
      'search': 'Cari',
      'login_subtitle': 'Gunakan layanan di bawah ini untuk masuk ke Pressly',
      'login_google': 'Masuk Dengan Google',
      'or': 'atau',
      'login_email_title': 'Masuk Dengan Email Anda :',
      'email': 'Email',
      'email_hint': 'masukkan email Anda Disini...',
      'password': 'Kata Sandi',
      'password_hint': 'masukkan kata sandi anda disini...',
      'no_account': 'Belum Punya Akun? ',
      'register_here': 'Daftar disini',
      'register': 'Daftar',
      'register_subtitle': 'Gunakan layanan di bawah untuk mendaftar ke Pressly.',
      'register_google': 'Daftar Dengan Google',
      'register_email_title': 'Daftar Menggunakan Email Anda (GRATIS) :',
      'enter_email_hint': 'Masukkan email akun Anda...',
      'enter_password_hint': 'Masukkan kata sandi akun Anda...',
      'repeat_password': 'Ulangi Kata Sandi',
      'repeat_password_hint': 'Masukkan Kata Sandi Sebelumnya...',
      'i_agree': 'Saya menyetujui ',
      'terms_conditions': 'Syarat dan Ketentuan',
      'and': ' dan\n',
      'privacy_policy': 'Kebijakan Privasi',
    },
  };

  String getText(String key) {
    return _localizedValues[currentLanguage.codd]?[key] ?? key;
  }
}
