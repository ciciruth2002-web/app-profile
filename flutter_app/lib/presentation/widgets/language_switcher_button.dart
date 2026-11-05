import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';

class LanguageSwitcherButton extends StatelessWidget {
  final bool compact;

  const LanguageSwitcherButton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isId = localeProvider.isIndonesian;

    if (compact) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => localeProvider.toggleLocale(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    isId ? 'ID' : 'EN',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SegmentedButton<String>(
      segments: const [
        ButtonSegment<String>(
          value: 'id',
          label: Text('Bahasa Indonesia'),
          icon: Icon(Icons.flag_outlined, size: 16),
        ),
        ButtonSegment<String>(
          value: 'en',
          label: Text('English'),
          icon: Icon(Icons.language, size: 16),
        ),
      ],
      selected: {localeProvider.languageCode},
      onSelectionChanged: (newSelection) {
        localeProvider.setLocale(Locale(newSelection.first));
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
