import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/post_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  final String slug;

  const PostDetailScreen({super.key, required this.slug});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ApiService _apiService = ApiService();
  PostModel? _post;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final post = await _apiService.getPostBySlug(widget.slug, locale: locale);
      setState(() {
        _post = post;
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
        title: Text(l10n.translate('nav_news')),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingStateWidget();
          }

          if (_errorMessage != null || _post == null) {
            return ErrorStateWidget(
              message: _errorMessage,
              onRetry: _fetchPost,
            );
          }

          final post = _post!;

          return RefreshIndicator(
            onRefresh: _fetchPost,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Featured Header Image
                if (post.imageUrl != null)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.border,
                        child: const Icon(Icons.image_not_supported,
                            size: 48, color: Colors.grey),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Category badge & date
                      Row(
                        children: [
                          if (post.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                post.category!.name,
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const Spacer(),
                          const Icon(Icons.schedule,
                              size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(post.publishedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // 3. Post Title
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 4. Author & View Count Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                            child: const Icon(Icons.person,
                                size: 16, color: AppTheme.primary),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            post.authorName ?? 'Admin Instansi',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.visibility_outlined,
                              size: 15, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${post.viewCount} ${l10n.translate('views')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(color: AppTheme.border),
                      const SizedBox(height: 16),

                      // 5. Summary / Lead paragraph
                      if (post.summary != null && post.summary!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: const Border(
                              left: BorderSide(color: AppTheme.primary, width: 4),
                            ),
                          ),
                          child: Text(
                            post.summary!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF334155),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // 6. Main Content Body
                      Text(
                        _stripHtml(post.content ?? ''),
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return '';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return isoString;
    }
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<p>'), '')
        .replaceAll(RegExp(r'</p>'), '\n\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
