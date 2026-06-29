import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/post_model.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/radius.dart';
import 'neo_brutal_card.dart';
import 'tag_chip.dart';

/// Post card widget matching the reference home feed design
class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
  });

  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likes;
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
    widget.onLike?.call();
  }

  Color _getCategoryBgColor(String colorKey) {
    return switch (colorKey) {
      'tertiary' => AppColors.tertiaryContainer,
      'secondary' => AppColors.secondaryContainer,
      'primary' => AppColors.primaryContainer,
      'tertiary_fixed' => AppColors.tertiaryFixed,
      _ => AppColors.surfaceContainerHigh,
    };
  }

  Color _getCategoryTextColor(String colorKey) {
    return switch (colorKey) {
      'tertiary' => AppColors.onTertiaryContainer,
      'secondary' => AppColors.onSecondaryContainer,
      'primary' => AppColors.onPrimaryContainer,
      'tertiary_fixed' => AppColors.onTertiaryFixed,
      _ => AppColors.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.post.category == 'NATURE'
        ? AppColors.surfaceContainerHigh
        : AppColors.surfaceContainerLowest;

    return NeoBrutalCard(
      backgroundColor: bgColor,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and timestamp row
            Row(
              children: [
                TagChip(
                  label: widget.post.category,
                  backgroundColor: _getCategoryBgColor(
                    widget.post.categoryColor,
                  ),
                  textColor: _getCategoryTextColor(widget.post.categoryColor),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.post.timestamp,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),

            // Title
            Text(
              widget.post.title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // Optional image
            if (widget.post.hasImage && widget.post.imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                child: Container(
                  width: double.infinity,
                  height: 192,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(
                      AppRadius.defaultRadius,
                    ),
                    border: Border.all(
                      color: AppColors.onSurface,
                      width: AppSpacing.borderWidth,
                    ),
                  ),
                  child: Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
            ],

            // Body text
            Text(
              widget.post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Divider
            const Divider(
              color: AppColors.onSurface,
              thickness: AppSpacing.borderWidth,
              height: AppSpacing.md,
            ),

            // Action buttons
            Row(
              children: [
                _ActionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_outline,
                  label: 'I Hear You ($_likeCount)',
                  isActive: _isLiked,
                  onTap: _handleLike,
                ),
                const SizedBox(width: AppSpacing.md),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Comment (${widget.post.comments})',
                  onTap: widget.onComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive || _isHovered
        ? AppColors.brandPrimary
        : AppColors.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              widget.label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
