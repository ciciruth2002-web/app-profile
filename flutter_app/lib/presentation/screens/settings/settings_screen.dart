import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/config/api_config.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/presentation/providers/portal_provider.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final portal = Provider.of<PortalProvider>(context);

    final siteName = portal.settings['site_name']?.toString() ?? 'Portal Instansi';
    final email = portal.settings['contact_email']?.toString() ?? 'kontak@instansi.go.id';
    final phone = portal.settings['contact_phone']?.toString() ?? '(021) 12345678';
    final address = portal.settings['address']?.toString() ?? 'Kompleks Kantor Pemda';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('nav_settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Language Switcher Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded,
                          color: AppTheme.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        l10n.translate('change_language'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localeProvider.isIndonesian
                        ? 'Pilih bahasa antarmuka dan konten yang Anda inginkan.'
                        : 'Choose your preferred app interface and content language.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: LanguageSwitcherButton()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Institutional Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business_rounded,
                          color: AppTheme.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        l10n.translate('about_institution'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _infoTile(Icons.account_balance, 'Instansi', siteName),
                  _infoTile(Icons.email_outlined, 'Email', email),
                  _infoTile(Icons.phone_outlined, 'Telepon', phone),
                  _infoTile(Icons.location_on_outlined, 'Alamat', address),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Technical & API Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.code_rounded,
                          color: AppTheme.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        l10n.translate('system_settings'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _infoTile(Icons.api_rounded, 'Backend API Endpoint', ApiConfig.baseUrl),
                  _infoTile(Icons.info_outline, l10n.translate('app_version'), 'v1.0.0 (Flutter + GoRouter)'),
                  _infoTile(
                    Icons.translate_rounded,
                    'Multilingual Driver',
                    'Spatie Translatable (Accept-Language: ${localeProvider.languageCode})',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
