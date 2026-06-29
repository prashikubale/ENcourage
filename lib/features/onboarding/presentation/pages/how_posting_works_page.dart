import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

/// How posting works onboarding page
class HowPostingWorksPage extends StatelessWidget {
  const HowPostingWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryFixed,
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
                onPressed: () => context.go(AppRoutes.introduction),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Next',
                  icon: Icons.arrow_forward,
                  isFullWidth: true,
                  backgroundColor: AppColors.primary,
                  onPressed: () =>
                      context.go(AppRoutes.createFirstReflection),
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
              _OnboardingProgress(current: 2, total: 4),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'How Posting Works',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onBackground,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Share your thoughts in 3 simple steps.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              _StepCard(
                step: '01',
                title: 'Choose a Community',
                description:
                    'Pick a topic area that your reflection belongs to.',
                color: AppColors.secondaryContainer,
              ),
              const SizedBox(height: AppSpacing.sm),
              _StepCard(
                step: '02',
                title: 'Write Your Reflection',
                description:
                    'Share your thought, experience, or encouraging insight.',
                color: AppColors.primaryFixed,
              ),
              const SizedBox(height: AppSpacing.sm),
              _StepCard(
                step: '03',
                title: 'Encourage Others',
                description:
                    'React with "I Hear You" and leave supportive comments.',
                color: AppColors.surfaceContainerLowest,
              ),

              const SizedBox(height: AppSpacing.md),
              NeoBrutalCard(
                backgroundColor: AppColors.primary,
                borderRadius: AppRadius.defaultRadius,
                shadowOffset: 4,
                animateOnHover: false,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.onPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'All posts must be encouraging and constructive. Negativity is not welcome in our sanctuary.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.onPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
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

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.color,
  });

  final String step;
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
          Text(
            step,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              height: 1,
            ),
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
