import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Default base URL pointing to the Laravel backend.
  /// Android Emulator uses 10.0.2.2 to access host machine localhost.
  /// Web / Windows desktop / iOS simulator uses 127.0.0.1:8000.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://127.0.0.1:8000/api/v1';
  }

  // Endpoints
  static const String settings = '/settings';
  static const String slides = '/slides';
  static const String categories = '/categories';
  static const String posts = '/posts';
  static const String featuredPosts = '/posts/featured';
  static const String pages = '/pages';
  static const String menus = '/menus';
  static const String questionTopics = '/question-topics';
  static const String questions = '/questions';
  static const String faqs = '/faqs';

  /// Generates common headers including Accept-Language for Spatie Translatable
  static Map<String, String> headers({String locale = 'id', String? token}) {
    final map = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': locale,
    };
    if (token != null) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }
}

