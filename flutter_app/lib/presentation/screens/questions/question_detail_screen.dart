import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class QuestionDetailScreen extends StatefulWidget {
  final int id;

  const QuestionDetailScreen({super.key, required this.id});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final ApiService _apiService = ApiService();
  QuestionModel? _question;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    setState(() => _isLoading = true);

    try {
      final question = await _apiService.getQuestionById(widget.id, locale: locale);
      setState(() {
        _question = question;
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
        title: Text(l10n.translate('nav_questions')),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingStateWidget();
          }

          if (_errorMessage != null || _question == null) {
            return ErrorStateWidget(
              message: _errorMessage,
              onRetry: _fetchDetail,
            );
          }

          final q = _question!;

          return RefreshIndicator(
            onRefresh: _fetchDetail,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Question Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (q.topic != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  q.topic!.name,
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: q.isAnswered
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                q.isAnswered
                                    ? l10n.translate('answered_status')
                                    : l10n.translate('pending_status'),
                                style: TextStyle(
                                  color: q.isAnswered
                                      ? const Color(0xFF15803D)
                                      : const Color(0xFFB45309),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          q.subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          q.body,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: AppTheme.border),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person,
                                size: 16, color: AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              q.name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 2. Official Institution Answer Card
                if (q.answer != null) ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF86EFAC),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified,
                                color: Color(0xFF16A34A), size: 22),
                            const SizedBox(width: 8),
                            Text(
                              l10n.translate('official_answer'),
                              style: const TextStyle(
                                color: Color(0xFF15803D),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q.answer!.body,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF166534),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFBBF7D0)),
                        const SizedBox(height: 6),
                        Text(
                          l10n.translate('answered_by'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF15803D),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.hourglass_top,
                            color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.translate('pending_status'),
                            style: const TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
