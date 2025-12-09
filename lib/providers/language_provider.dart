import 'package:flutter/material.dart';
import 'package:pressly/models/language.dart';

class LanguageProvider extends ChangeNotifier{
  final List<AppLanguage> supportedLanguages = [
    AppLanguage(codd: 'en', name: 'English', flag: '🇺🇸'),
    AppLanguage(codd: 'id', name: 'Indonesia', flag: "id")
  ];

  late AppLanguage currentLanguage = supportedLanguages.first;

  void changelanguage() {
    currentLanguage = currentLanguage == supportedLanguages.first ? supportedLanguages.last : supportedLanguages.first;
  }
}
