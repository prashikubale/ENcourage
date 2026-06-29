import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/radius.dart';

/// Tag/chip component with neo-brutalist border
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.secondaryContainer,
    this.textColor = AppColors.onSecondaryContainer,
    this.isUppercase = true,
    this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isUppercase;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
        ),
        child: Text(
          isUppercase ? label.toUpperCase() : label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: isUppercase ? 1.0 : 0,
          ),
        ),
      ),
    );
  }
}
