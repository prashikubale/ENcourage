import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/radius.dart';

/// Neo-Brutalist card with thick black border and hard shadow
class NeoBrutalCard extends StatefulWidget {
  const NeoBrutalCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.surfaceContainerLowest,
    this.shadowOffset = AppSpacing.shadowOffsetLg,
    this.borderRadius = AppRadius.md,
    this.padding,
    this.onTap,
    this.animateOnHover = true,
  });

  final Widget child;
  final Color backgroundColor;
  final double shadowOffset;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool animateOnHover;

  @override
  State<NeoBrutalCard> createState() => _NeoBrutalCardState();
}

class _NeoBrutalCardState extends State<NeoBrutalCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double currentOffset = widget.shadowOffset;
    double translateX = 0;
    double translateY = 0;

    if (_isPressed) {
      currentOffset = 0;
      translateX = widget.shadowOffset;
      translateY = widget.shadowOffset;
    } else if (_isHovered) {
      currentOffset = widget.shadowOffset / 2;
      translateX = widget.shadowOffset / 2;
      translateY = widget.shadowOffset / 2;
    }

    return MouseRegion(
      onEnter: widget.animateOnHover
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.animateOnHover
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: GestureDetector(
        onTapDown: widget.onTap != null
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: widget.onTap != null
            ? (_) => setState(() => _isPressed = false)
            : null,
        onTapCancel: widget.onTap != null
            ? () => setState(() => _isPressed = false)
            : null,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(translateX, translateY, 0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: AppColors.onSurface,
              width: AppSpacing.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(currentOffset, currentOffset),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: widget.padding != null
              ? Padding(padding: widget.padding!, child: widget.child)
              : widget.child,
        ),
      ),
    );
  }
}
