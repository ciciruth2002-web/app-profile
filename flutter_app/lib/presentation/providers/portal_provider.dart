import 'package:flutter/material.dart';
import 'package:app_profile_mobile/data/models/slide_model.dart';
import 'package:app_profile_mobile/data/models/category_model.dart';
import 'package:app_profile_mobile/data/models/post_model.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';

enum LoadingStatus { initial, loading, success, error }

class PortalProvider extends ChangeNotifier {
  final ApiService _apiService;

  PortalProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  LoadingStatus _homeStatus = LoadingStatus.initial;
  LoadingStatus get homeStatus => _homeStatus;
  String _homeError = '';
  String get homeError => _homeError;

  List<SlideModel> _slides = [];
  List<SlideModel> get slides => _slides;

  List<PostModel> _featuredPosts = [];
  List<PostModel> get featuredPosts => _featuredPosts;

  List<PostModel> _latestPosts = [];
  List<PostModel> get latestPosts => _latestPosts;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  Map<String, dynamic> _settings = {};
  Map<String, dynamic> get settings => _settings;

  List<QuestionTopicModel> _topics = [];
  List<QuestionTopicModel> get topics => _topics;

  String _currentLocale = 'id';

  Future<void> fetchHomeData(String locale, {bool force = false}) async {
    if (!force && _homeStatus == LoadingStatus.success && _currentLocale == locale) {
      return;
    }

    _currentLocale = locale;
    _homeStatus = LoadingStatus.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getSlides(locale: locale).catchError((_) => <SlideModel>[]),
        _apiService.getFeaturedPosts(locale: locale).catchError((_) => <PostModel>[]),
        _apiService.getPosts(locale: locale).catchError((_) => <PostModel>[]),
        _apiService.getCategories(locale: locale).catchError((_) => <CategoryModel>[]),
        _apiService.getSettings(locale: locale).catchError((_) => <String, dynamic>{}),
        _apiService.getQuestionTopics(locale: locale).catchError((_) => <QuestionTopicModel>[]),
      ]);

      _slides = results[0] as List<SlideModel>;
      _featuredPosts = results[1] as List<PostModel>;
      _latestPosts = results[2] as List<PostModel>;
      _categories = results[3] as List<CategoryModel>;
      _settings = results[4] as Map<String, dynamic>;
      _topics = results[5] as List<QuestionTopicModel>;

      _homeStatus = LoadingStatus.success;
      notifyListeners();
    } catch (e) {
      _homeError = e.toString();
      _homeStatus = LoadingStatus.error;
      notifyListeners();
    }
  }

  void onLocaleChanged(String newLocale) {
    if (_currentLocale != newLocale) {
      fetchHomeData(newLocale, force: true);
    }
  }
}
