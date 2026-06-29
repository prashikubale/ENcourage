import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

/// Create first reflection onboarding page
class CreateFirstReflectionPage extends StatefulWidget {
  const CreateFirstReflectionPage({super.key});

  @override
  State<CreateFirstReflectionPage> createState() =>
      _CreateFirstReflectionPageState();
}

class _CreateFirstReflectionPageState
    extends State<CreateFirstReflectionPage> {
  final _controller = TextEditingController();
  bool _isFocused = false;
  bool _isLoading = false;

  final _prompt =
      'What is one small thing that brought you peace today?';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OnboardingProgress(current: 3, total: 4),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Write Your First\nReflection',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Prompt card (matches code.html daily prompt card)
              NeoBrutalCard(
                backgroundColor: AppColors.brandPrimary,
                borderRadius: AppRadius.md,
                shadowOffset: 8,
                animateOnHover: false,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: AppColors.onSurface,
                              width: AppSpacing.borderWidth,
                            ),
                          ),
                          child: Text(
                            'DAILY PROMPT',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.spa,
                          color: AppColors.onPrimary,
                          size: 36,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _prompt,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Text input
              Focus(
                onFocusChange: (focused) =>
                    setState(() => _isFocused = focused),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                    border: Border.all(
                      color: _isFocused
                          ? AppColors.primary
                          : AppColors.onSurface,
                      width: AppSpacing.borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isFocused
                            ? AppColors.primary
                            : AppColors.shadow,
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 6,
                    maxLength: 500,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.onSurface,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Start writing here...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.outlineVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      counterStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  OutlinedNeoBrutalButton(
                    label: 'Back',
                    onPressed: () => context.go(AppRoutes.howPostingWorks),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Start Exploring',
                      icon: Icons.rocket_launch,
                      isFullWidth: true,
                      isLoading: _isLoading,
                      backgroundColor: AppColors.primary,
                      onPressed: _complete,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
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
