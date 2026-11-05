import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/page_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class PageDetailScreen extends StatefulWidget {
  final String slug;

  const PageDetailScreen({super.key, required this.slug});

  @override
  State<PageDetailScreen> createState() => _PageDetailScreenState();
}

class _PageDetailScreenState extends State<PageDetailScreen> {
  final ApiService _apiService = ApiService();
  PageModel? _page;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  Future<void> _fetchPage() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final page = await _apiService.getPageBySlug(widget.slug, locale: locale);
      setState(() {
        _page = page;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_page?.title ?? 'Profil Instansi'),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingStateWidget();
          }

          if (_errorMessage != null || _page == null) {
            return ErrorStateWidget(
              message: _errorMessage,
              onRetry: _fetchPage,
            );
          }

          final page = _page!;

          return RefreshIndicator(
            onRefresh: _fetchPage,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (page.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        page.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppTheme.border),
                const SizedBox(height: 14),
                Text(
                  _stripHtml(page.content ?? ''),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<h3>'), '\n\n')
        .replaceAll(RegExp(r'</h3>'), '\n')
        .replaceAll(RegExp(r'<li>'), '• ')
        .replaceAll(RegExp(r'</li>'), '\n')
        .replaceAll(RegExp(r'<p>'), '')
        .replaceAll(RegExp(r'</p>'), '\n\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
