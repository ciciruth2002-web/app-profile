import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_profile_mobile/core/localization/app_localizations.dart';
import 'package:app_profile_mobile/core/localization/locale_provider.dart';
import 'package:app_profile_mobile/core/theme/app_theme.dart';
import 'package:app_profile_mobile/presentation/providers/portal_provider.dart';
import 'package:app_profile_mobile/presentation/widgets/language_switcher_button.dart';
import 'package:app_profile_mobile/presentation/widgets/post_card.dart';
import 'package:app_profile_mobile/presentation/widgets/slide_carousel.dart';
import 'package:app_profile_mobile/presentation/widgets/state_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      Provider.of<PortalProvider>(context, listen: false)
          .fetchHomeData(localeProvider.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final portal = Provider.of<PortalProvider>(context);

    // React to locale change
    portal.onLocaleChanged(localeProvider.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance_rounded,
                  color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    portal.settings['site_name']?.toString() ??
                        l10n.translate('app_title'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    portal.settings['site_tagline']?.toString() ??
                        'Portal Resmi Pelayanan Terpadu',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          LanguageSwitcherButton(compact: true),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (portal.homeStatus == LoadingStatus.loading &&
              portal.slides.isEmpty &&
              portal.latestPosts.isEmpty) {
            return const LoadingStateWidget();
          }

          if (portal.homeStatus == LoadingStatus.error &&
              portal.slides.isEmpty &&
              portal.latestPosts.isEmpty) {
            return ErrorStateWidget(
              message: portal.homeError,
              onRetry: () => portal.fetchHomeData(localeProvider.languageCode,
                  force: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => portal.fetchHomeData(localeProvider.languageCode,
                force: true),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // 1. Slides Banner
                if (portal.slides.isNotEmpty) ...[
                  SlideCarousel(
                    slides: portal.slides,
                    onSlideTap: (slide) {
                      if (slide.linkUrl != null && slide.linkUrl!.isNotEmpty) {
                        context.push(slide.linkUrl!);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // 2. Quick Services Menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('quick_menu'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _quickMenuItem(
                            context,
                            icon: Icons.info_outline_rounded,
                            color: const Color(0xFF3B82F6),
                            label: l10n.translate('about_institution'),
                            onTap: () => context.push('/pages/tentang-kami'),
                          ),
                          _quickMenuItem(
                            context,
                            icon: Icons.flag_circle_outlined,
                            color: const Color(0xFF10B981),
                            label: l10n.translate('vision_mission'),
                            onTap: () => context.push('/pages/visi-misi'),
                          ),
                          _quickMenuItem(
                            context,
                            icon: Icons.question_answer_outlined,
                            color: const Color(0xFFF59E0B),
                            label: l10n.translate('nav_questions'),
                            onTap: () => context.push('/questions'),
                          ),
                          _quickMenuItem(
                            context,
                            icon: Icons.help_outline_rounded,
                            color: const Color(0xFF8B5CF6),
                            label: l10n.translate('nav_faq'),
                            onTap: () => context.push('/faqs'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Citizen Inquiries Call To Action Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.campaign_outlined,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              l10n.translate('public_questions'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.translate('submit_question_desc'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/questions/create'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.edit_note, size: 18),
                          label: Text(
                            l10n.translate('submit_question'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Featured News (if available)
                if (portal.featuredPosts.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.translate('featured_news'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PostCard(
                      post: portal.featuredPosts.first,
                      onTap: () => context.push('/posts/${portal.featuredPosts.first.slug}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // 5. Latest News List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.translate('latest_news'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/posts'),
                        child: Text(l10n.translate('view_all')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                if (portal.latestPosts.isEmpty)
                  const EmptyStateWidget(icon: Icons.article_outlined)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: portal.latestPosts.take(4).map((post) {
                        return PostCard(
                          post: post,
                          compact: true,
                          onTap: () => context.push('/posts/${post.slug}'),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quickMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
