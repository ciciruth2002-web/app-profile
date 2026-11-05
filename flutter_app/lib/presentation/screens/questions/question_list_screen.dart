import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<QuestionTopicModel> _topics = [];
  List<QuestionModel> _questions = [];
  String? _selectedTopicSlug;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTopicsAndQuestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTopicsAndQuestions() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final topics = await _apiService.getQuestionTopics(locale: locale);
      final questions = await _apiService.getQuestions(
        locale: locale,
        topicSlug: _selectedTopicSlug,
        search: _searchController.text.trim(),
      );

      setState(() {
        _topics = topics;
        _questions = questions;
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

  Future<void> _filterQuestions() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final questions = await _apiService.getQuestions(
        locale: locale,
        topicSlug: _selectedTopicSlug,
        search: _searchController.text.trim(),
      );
      setState(() {
        _questions = questions;
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
        title: Text(l10n.translate('public_questions')),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/questions/create'),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: Text(
          l10n.translate('submit_question'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _filterQuestions(),
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint_question'),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _filterQuestions();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 2. Topic chips
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
                        _filterQuestions();
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
                  ..._topics.map((topic) {
                    final isSelected = _selectedTopicSlug == topic.slug;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(topic.name),
                        onSelected: (_) {
                          setState(() => _selectedTopicSlug = topic.slug);
                          _filterQuestions();
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

          // 3. Question List
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const LoadingStateWidget();
                }

                if (_errorMessage != null) {
                  return ErrorStateWidget(
                    message: _errorMessage,
                    onRetry: _fetchTopicsAndQuestions,
                  );
                }

                if (_questions.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.question_answer_outlined,
                    message: l10n.translate('no_data'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _filterQuestions,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final item = _questions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/questions/${item.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (item.topic != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.topic!.name,
                                          style: const TextStyle(
                                            color: Color(0xFF475569),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: item.isAnswered
                                            ? const Color(0xFFDCFCE7)
                                            : const Color(0xFFFEF3C7),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.isAnswered
                                            ? l10n.translate('answered_status')
                                            : l10n.translate('pending_status'),
                                        style: TextStyle(
                                          color: item.isAnswered
                                              ? const Color(0xFF15803D)
                                              : const Color(0xFFB45309),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.subject,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline,
                                        size: 14, color: Color(0xFF94A3B8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
}
