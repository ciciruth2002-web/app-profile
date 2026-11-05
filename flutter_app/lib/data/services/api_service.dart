import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_profile_mobile/core/config/api_config.dart';
import 'package:app_profile_mobile/data/models/slide_model.dart';
import 'package:app_profile_mobile/data/models/category_model.dart';
import 'package:app_profile_mobile/data/models/post_model.dart';
import 'package:app_profile_mobile/data/models/page_model.dart';
import 'package:app_profile_mobile/data/models/menu_model.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/models/faq_model.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Helper to get localized headers
  Map<String, String> _headers(String locale) => ApiConfig.headers(locale: locale);

  // 1. Settings
  Future<Map<String, dynamic>> getSettings({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.settings}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'] as Map<String, dynamic>? ?? {};
    }
    throw Exception('Failed to load settings (${response.statusCode})');
  }

  // 2. Slides
  Future<List<SlideModel>> getSlides({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.slides}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => SlideModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load slides (${response.statusCode})');
  }

  // 3. Categories
  Future<List<CategoryModel>> getCategories({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => CategoryModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load categories (${response.statusCode})');
  }

  // 4. Posts
  Future<List<PostModel>> getPosts({
    String locale = 'id',
    String? categorySlug,
    String? search,
    int page = 1,
  }) async {
    final queryParams = <String, String>{'page': page.toString()};
    if (categorySlug != null && categorySlug.isNotEmpty) {
      queryParams['category'] = categorySlug;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}')
        .replace(queryParameters: queryParams);

    final response = await _client.get(uri, headers: _headers(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => PostModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load posts (${response.statusCode})');
  }

  Future<List<PostModel>> getFeaturedPosts({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.featuredPosts}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => PostModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load featured posts');
  }

  Future<PostModel> getPostBySlug(String slug, {String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}/$slug'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PostModel.fromJson(json['data']);
    }
    throw Exception('Failed to load post ($slug)');
  }

  // 5. Pages
  Future<List<PageModel>> getPages({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pages}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => PageModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load pages');
  }

  Future<PageModel> getPageBySlug(String slug, {String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pages}/$slug'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PageModel.fromJson(json['data']);
    }
    throw Exception('Failed to load page ($slug)');
  }

  // 6. Menus
  Future<MenuModel?> getMenu(String location, {String locale = 'id'}) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.menus}/$location'),
        headers: _headers(locale),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return MenuModel.fromJson(json['data']);
      }
    } catch (_) {}
    return null;
  }

  // 7. Question Topics
  Future<List<QuestionTopicModel>> getQuestionTopics({String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.questionTopics}'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => QuestionTopicModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load question topics');
  }

  // 8. Questions (Community Q&A)
  Future<List<QuestionModel>> getQuestions({
    String locale = 'id',
    String? topicSlug,
    String? search,
    int page = 1,
  }) async {
    final queryParams = <String, String>{'page': page.toString()};
    if (topicSlug != null && topicSlug.isNotEmpty) {
      queryParams['topic'] = topicSlug;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.questions}')
        .replace(queryParameters: queryParams);

    final response = await _client.get(uri, headers: _headers(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => QuestionModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load questions');
  }

  Future<QuestionModel> getQuestionById(int id, {String locale = 'id'}) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.questions}/$id'),
      headers: _headers(locale),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return QuestionModel.fromJson(json['data']);
    }
    throw Exception('Failed to load question (#$id)');
  }

  /// Submit question by citizen
  Future<Map<String, dynamic>> submitQuestion({
    required String name,
    required String email,
    String? phone,
    int? topicId,
    required String subject,
    required String body,
    String locale = 'id',
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.questions}'),
      headers: _headers(locale),
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'topic_id': topicId,
        'subject': subject,
        'body': body,
      }),
    );

    final json = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json;
    }

    throw Exception(json['message'] ?? 'Failed to submit question');
  }

  // 9. FAQs
  Future<List<FaqModel>> getFaqs({
    String locale = 'id',
    String? topicSlug,
    String? search,
  }) async {
    final queryParams = <String, String>{};
    if (topicSlug != null && topicSlug.isNotEmpty) {
      queryParams['topic'] = topicSlug;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.faqs}')
        .replace(queryParameters: queryParams);

    final response = await _client.get(uri, headers: _headers(locale));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((item) => FaqModel.fromJson(item)).toList();
    }
    throw Exception('Failed to load FAQs');
  }
}
