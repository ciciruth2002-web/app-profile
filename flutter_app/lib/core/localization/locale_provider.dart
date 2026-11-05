import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_locale';

  Locale _locale = const Locale('id', 'ID');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isIndonesian => _locale.languageCode == 'id';

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null && (savedCode == 'id' || savedCode == 'en')) {
        _locale = Locale(savedCode);
        notifyListeners();
      }
    } catch (_) {
      // Fallback to default Indonesian
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (_) {}
  }

  Future<void> toggleLocale() async {
    final nextCode = _locale.languageCode == 'id' ? 'en' : 'id';
    await setLocale(Locale(nextCode));
  }
}

