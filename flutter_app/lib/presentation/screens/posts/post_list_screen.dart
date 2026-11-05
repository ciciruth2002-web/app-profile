import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/category_model.dart';
import 'package:app_profile_mobile/data/models/post_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/post_card.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<CategoryModel> _categories = [];
  List<PostModel> _posts = [];
  String? _selectedCategorySlug;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoriesAndPosts() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final cats = await _apiService.getCategories(locale: locale);
      final posts = await _apiService.getPosts(
        locale: locale,
        categorySlug: _selectedCategorySlug,
        search: _searchController.text.trim(),
      );

      setState(() {
        _categories = cats;
        _posts = posts;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _filterPosts() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final posts = await _apiService.getPosts(
        locale: locale,
        categorySlug: _selectedCategorySlug,
        search: _searchController.text.trim(),
      );
      setState(() {
        _posts = posts;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('latest_news')),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Column(
        children: [
          // 1. Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _filterPosts(),
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint_news'),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _filterPosts();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 2. Category horizontal pills
          if (_categories.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _selectedCategorySlug == null,
                      label: Text(l10n.translate('all_categories')),
                      onSelected: (_) {
                        setState(() => _selectedCategorySlug = null);
                        _filterPosts();
                      },
                      selectedColor: AppTheme.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedCategorySlug == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedCategorySlug == null
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  ..._categories.map((cat) {
                    final isSelected = _selectedCategorySlug == cat.slug;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat.name),
                        onSelected: (_) {
                          setState(() => _selectedCategorySlug = cat.slug);
                          _filterPosts();
                        },
                        selectedColor: AppTheme.primary.withValues(alpha: 0.15),
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // 3. Post List
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const LoadingStateWidget();
                }

                if (_errorMessage != null) {
                  return ErrorStateWidget(
                    message: _errorMessage,
                    onRetry: _fetchCategoriesAndPosts,
                  );
                }

                if (_posts.isEmpty) {
                  return const EmptyStateWidget(icon: Icons.newspaper_outlined);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _filterPosts();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return PostCard(
                        post: post,
                        onTap: () => context.push('/posts/${post.slug}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
