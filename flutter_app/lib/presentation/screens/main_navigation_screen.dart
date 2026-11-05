import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';

class MainNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        indicatorColor: AppTheme.primary.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppTheme.primary),
            label: l10n.translate('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.newspaper_outlined),
            selectedIcon: const Icon(Icons.newspaper, color: AppTheme.primary),
            label: l10n.translate('nav_news'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.question_answer_outlined),
            selectedIcon: const Icon(Icons.question_answer, color: AppTheme.primary),
            label: l10n.translate('nav_questions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline_rounded),
            selectedIcon: const Icon(Icons.help_rounded, color: AppTheme.primary),
            label: l10n.translate('nav_faq'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings, color: AppTheme.primary),
            label: l10n.translate('nav_settings'),
          ),
        ],
      ),
    );
  }
}
