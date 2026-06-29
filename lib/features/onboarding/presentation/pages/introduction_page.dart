import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

/// Introduction onboarding page
class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryFixed,
      // Fixed footer — never overlaps content
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              OutlinedNeoBrutalButton(
                label: 'Back',
                onPressed: () => context.go(AppRoutes.welcome),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Next',
                  icon: Icons.arrow_forward,
                  isFullWidth: true,
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.go(AppRoutes.howPostingWorks),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              _OnboardingProgress(current: 1, total: 4),
              const SizedBox(height: AppSpacing.lg),

              // Heading
              Text(
                'What is\nEncourage?',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onBackground,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'A community-driven platform where positivity is the foundation.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Feature cards
              _FeatureCard(
                icon: Icons.explore_outlined,
                title: 'Discover Reflections',
                description:
                    'Browse a curated feed of uplifting thoughts from people just like you.',
                color: AppColors.secondaryContainer,
              ),
              const SizedBox(height: AppSpacing.sm),
              _FeatureCard(
                icon: Icons.people_outline,
                title: 'Join Communities',
                description:
                    'Connect with communities around topics that matter most to you.',
                color: AppColors.tertiaryFixed,
              ),
              const SizedBox(height: AppSpacing.sm),
              _FeatureCard(
                icon: Icons.edit_outlined,
                title: 'Share Your Thoughts',
                description:
                    'Write and share your own encouraging reflections with others.',
                color: AppColors.primaryContainer,
              ),
              // Bottom breathing room
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      backgroundColor: color,
      shadowOffset: 4,
      borderRadius: AppRadius.defaultRadius,
      padding: const EdgeInsets.all(AppSpacing.md),
      animateOnHover: false,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.onSurface,
                width: AppSpacing.borderWidth,
              ),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
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

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Step $current of $total',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }
}
