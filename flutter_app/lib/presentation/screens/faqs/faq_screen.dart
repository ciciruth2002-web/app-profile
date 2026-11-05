import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/faq_model.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<QuestionTopicModel> _topics = [];
  List<FaqModel> _faqs = [];
  String? _selectedTopicSlug;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFaqs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchFaqs() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final topics = await _apiService.getQuestionTopics(locale: locale);
      final faqs = await _apiService.getFaqs(
        locale: locale,
        topicSlug: _selectedTopicSlug,
        search: _searchController.text.trim(),
      );

      setState(() {
        _topics = topics;
        _faqs = faqs;
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

  Future<void> _filterFaqs() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final faqs = await _apiService.getFaqs(
        locale: locale,
        topicSlug: _selectedTopicSlug,
        search: _searchController.text.trim(),
      );
      setState(() {
        _faqs = faqs;
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
        title: Text(l10n.translate('faq_title')),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _filterFaqs(),
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint_faq'),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _filterFaqs();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 2. Topic horizontal filter
          if (_topics.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _selectedTopicSlug == null,
                      label: Text(l10n.translate('all_categories')),
                      onSelected: (_) {
                        setState(() => _selectedTopicSlug = null);
                        _filterFaqs();
                      },
                      selectedColor: AppTheme.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedTopicSlug == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedTopicSlug == null
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  ..._topics.map((t) {
                    final isSelected = _selectedTopicSlug == t.slug;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(t.name),
                        onSelected: (_) {
                          setState(() => _selectedTopicSlug = t.slug);
                          _filterFaqs();
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

          // 3. FAQ List
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const LoadingStateWidget();
                }

                if (_errorMessage != null) {
                  return ErrorStateWidget(
                    message: _errorMessage,
                    onRetry: _fetchFaqs,
                  );
                }

                if (_faqs.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.help_outline_rounded,
                    message: l10n.translate('no_data'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _filterFaqs,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _faqs.length,
                    itemBuilder: (context, index) {
                      final faq = _faqs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          leading: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFFEEF2FF),
                            child: Icon(Icons.help_rounded,
                                size: 16, color: AppTheme.primary),
                          ),
                          title: Text(
                            faq.question,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                              child: Text(
                                _stripHtml(faq.answer),
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.6,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
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
