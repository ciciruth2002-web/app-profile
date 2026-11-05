import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/data/models/question_model.dart';
import 'package:app_profile_mobile/data/services/api_service.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  List<QuestionTopicModel> _topics = [];
  int? _selectedTopicId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _fetchTopics() async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    try {
      final topics = await _apiService.getQuestionTopics(locale: locale);
      setState(() {
        _topics = topics;
        if (topics.isNotEmpty) {
          _selectedTopicId = topics.first.id;
        }
      });
    } catch (_) {}
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context, listen: false).languageCode;

    setState(() => _isSubmitting = true);

    try {
      await _apiService.submitQuestion(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        topicId: _selectedTopicId,
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
        locale: locale,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('success_submit')),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 4),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.translate('error_submit')} (${e.toString()})'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('question_form_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('submit_question_desc'),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Full Name
              _label(l10n.translate('field_name')),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.translate('field_name_hint'),
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Email Address
              _label(l10n.translate('field_email')),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: l10n.translate('field_email_hint'),
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Phone Number (Optional)
              _label(l10n.translate('field_phone')),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: l10n.translate('field_phone_hint'),
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Topic Dropdown
              if (_topics.isNotEmpty) ...[
                _label(l10n.translate('field_topic')),
                DropdownButtonFormField<int>(
                  initialValue: _selectedTopicId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined, size: 20),
                  ),
                  items: _topics.map((t) {
                    return DropdownMenuItem<int>(
                      value: t.id,
                      child: Text(t.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedTopicId = val);
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 5. Subject
              _label(l10n.translate('field_subject')),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: l10n.translate('field_subject_hint'),
                  prefixIcon: const Icon(Icons.title_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Subjek pertanyaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Question Body
              _label(l10n.translate('field_body')),
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: l10n.translate('field_body_hint'),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Isi pertanyaan tidak boleh kosong';
                  }
                  if (val.trim().length < 10) {
                    return 'Jelaskan pertanyaan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // 7. Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    _isSubmitting
                        ? l10n.translate('sending')
                        : l10n.translate('btn_submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
