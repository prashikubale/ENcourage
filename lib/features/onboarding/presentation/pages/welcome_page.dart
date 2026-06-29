import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';

/// Welcome onboarding page
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;

    return Scaffold(
      backgroundColor: AppColors.secondaryContainer,
      // Pinned footer button on mobile, none on desktop
      bottomNavigationBar: isWide
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: PrimaryButton(
                  label: "Let's Begin",
                  icon: Icons.arrow_forward,
                  isFullWidth: true,
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.go(AppRoutes.introduction),
                ),
              ),
            ),
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: isWide
                ? _buildDesktop(context)
                : _buildMobile(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        // Header banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.onSurface,
                width: AppSpacing.borderWidth,
              ),
            ),
          ),
          child: Text(
            'ENCOURAGE',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.onSecondaryContainer,
              letterSpacing: 4,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _IllustrationBox(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your sanctuary for positive thoughts.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSecondaryContainer,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Discover encouraging reflections, join uplifting communities, and share your positive energy with the world.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSecondaryContainer.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
                ),
                // Bottom breathing room
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      children: [
        // Left panel
        Expanded(
          flex: 5,
          child: Container(
            color: AppColors.secondaryContainer,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: AppColors.onSurface,
                      width: AppSpacing.borderWidth,
                    ),
                  ),
                  child: Text(
                    'ENCOURAGE',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your sanctuary for positive thoughts.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSecondaryContainer,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Discover encouraging reflections, join uplifting communities, and share your positive energy with the world.',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: AppColors.onSecondaryContainer.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: "Let's Begin",
                  icon: Icons.arrow_forward,
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.go(AppRoutes.introduction),
                ),
              ],
            ),
          ),
        ),
        // Right panel
        Expanded(
          flex: 4,
          child: Container(
            color: AppColors.primary,
            child: Center(child: _IllustrationBox(large: true)),
          ),
        ),
      ],
    );
  }
}

class _IllustrationBox extends StatelessWidget {
  const _IllustrationBox({this.large = false});
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 280.0 : 200.0;
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(8, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.onSurface,
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.onSurface,
                    width: 2,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.self_improvement,
              size: large ? 120 : 80,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
