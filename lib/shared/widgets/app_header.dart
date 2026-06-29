import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

/// App header / top app bar with neo-brutalist style
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title = 'Encourage',
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.showSearch = true,
    this.onSearch,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showSearch;
  final VoidCallback? onSearch;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.base,
          ),
          child: Row(
            children: [
              if (showBack)
                _HeaderIconButton(
                  icon: Icons.arrow_back,
                  onTap: onBack ?? () => Navigator.of(context).pop(),
                )
              else
                _HeaderIconButton(
                  icon: Icons.menu,
                  onTap: () {},
                ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              if (trailing != null)
                trailing!
              else if (showSearch)
                _HeaderIconButton(
                  icon: Icons.search,
                  onTap: onSearch ?? () {},
                )
              else
                const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isHovered
              ? (Matrix4.translationValues(-2, -2, 0))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.base),
            boxShadow: _isHovered
                ? const [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: AppColors.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Section header with divider lines
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.onSurface,
            thickness: AppSpacing.borderWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.onSurface,
            thickness: AppSpacing.borderWidth,
          ),
        ),
      ],
    );
  }
}
