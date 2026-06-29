import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';


/// Post detail page - matches reference 3.html
class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.postId});
  final String postId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostModel? _post;
  bool _isLiked = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    final jsonStr = await rootBundle.loadString('assets/mock/posts.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    final posts = (data['posts'] as List<dynamic>)
        .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
        .toList();
    final post = posts.firstWhere(
      (p) => p.id == widget.postId,
      orElse: () => posts.first,
    );
    if (mounted) {
      setState(() {
        _post = post;
        _isLiked = post.isLiked;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: 'MindReflect',
        showBack: true,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: _post == null
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final post = _post!;
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Stack(
      children: [
        if (isWide)
          _buildDesktopLayout(context, post)
        else
          _buildMobileLayout(context, post),
        // Bottom input (mobile only)
        if (!isWide)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomInputBar(controller: _commentController),
          ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, PostModel post) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        100, // account for bottom bar
      ),
      child: _ArticleContent(post: post, isLiked: _isLiked, onLike: () {
        setState(() => _isLiked = !_isLiked);
      }),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, PostModel post) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _ArticleContent(
                  post: post,
                  isLiked: _isLiked,
                  onLike: () => setState(() => _isLiked = !_isLiked),
                ),
                const SizedBox(height: AppSpacing.lg),
                _DesktopInputBar(controller: _commentController),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 320,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _AuthorCard(author: post.author),
                const SizedBox(height: AppSpacing.md),
                _TagsCard(category: post.category),
                const SizedBox(height: AppSpacing.md),
                _ShareCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({
    required this.post,
    required this.isLiked,
    required this.onLike,
  });
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      shadowOffset: 8,
      borderRadius: AppRadius.defaultRadius,
      animateOnHover: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.onSurface,
                width: AppSpacing.borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              post.category,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title
          Text(
            post.title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Author/Date
          Row(
            children: [
              Text(
                'By ${post.author}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.onSurface,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                post.timestamp,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Image if available
          if (post.hasImage && post.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
              child: Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                  border: Border.all(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.image_not_supported,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Body text
          Text(
            post.body,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: AppColors.onBackground,
              height: 1.7,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Quote (if long post)
          Container(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.primary,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              '"Every morning is a fresh beginning, a chance to start again."',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Divider
          const Divider(color: AppColors.onSurface, thickness: AppSpacing.borderWidth),
          const SizedBox(height: AppSpacing.md),

          // I Hear You button
          Center(
            child: _IHearYouButton(isLiked: isLiked, onTap: onLike),
          ),

          const SizedBox(height: AppSpacing.md),
          // Comments section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                child: const Icon(
                  Icons.forum,
                  color: AppColors.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                'Community Reflections',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Comments
          _CommentBubble(
            author: 'Marcus T.',
            text:
                'I needed to read this today. Reframing it as scaffolding makes so much sense.',
            time: '2 hours ago',
            isRight: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          _CommentBubble(
            author: 'Sarah J.',
            text:
                'My routine is just making my bed. It\'s the one thing I can control even if the rest of the day goes sideways.',
            time: '5 hours ago',
            isRight: true,
          ),
        ],
      ),
    );
  }
}

class _IHearYouButton extends StatefulWidget {
  const _IHearYouButton({required this.isLiked, required this.onTap});
  final bool isLiked;
  final VoidCallback onTap;

  @override
  State<_IHearYouButton> createState() => _IHearYouButtonState();
}

class _IHearYouButtonState extends State<_IHearYouButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double shadowOffset = 4.0;
    double tx = 0, ty = 0;
    if (_isPressed) {
      shadowOffset = 0; tx = 4; ty = 4;
    } else if (_isHovered) {
      shadowOffset = 8; tx = -4; ty = -4;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(tx, ty, 0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: widget.isLiked ? AppColors.secondary : AppColors.secondary,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: AppColors.onSurface,
              width: AppSpacing.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(shadowOffset, shadowOffset),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_outline,
                color: AppColors.onSecondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                'I Hear You',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  const _CommentBubble({
    required this.author,
    required this.text,
    required this.time,
    required this.isRight,
  });

  final String author;
  final String text;
  final String time;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    final bg = isRight ? AppColors.tertiaryFixed : AppColors.surfaceContainerLow;
    return Align(
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: EdgeInsets.only(
          left: isRight ? 24 : 0,
          right: isRight ? 0 : 24,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRight) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      author[0],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Column(
                  crossAxisAlignment: isRight
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (isRight) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.tertiaryContainer,
                    child: Text(
                      author[0],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurface,
                height: 1.5,
              ),
              textAlign: isRight ? TextAlign.end : TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomInputBar extends StatelessWidget {
  const _BottomInputBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.onSurface, width: AppSpacing.borderWidth),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, -4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Add a reflection...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.outline,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                  borderSide: const BorderSide(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                  borderSide: const BorderSide(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: AppSpacing.borderWidth,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.brandPrimary,
              borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
              border: Border.all(
                color: AppColors.onSurface,
                width: AppSpacing.borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopInputBar extends StatelessWidget {
  const _DesktopInputBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
        border: Border.all(
          color: AppColors.onSurface,
          width: AppSpacing.borderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Share your own reflection...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.outline,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: AppSpacing.borderWidth,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary,
              borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
              border: Border.all(
                color: AppColors.onSurface,
                width: AppSpacing.borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'Post',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.send, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorCard extends StatelessWidget {
  const _AuthorCard({required this.author});
  final String author;

  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      shadowOffset: 4,
      borderRadius: AppRadius.defaultRadius,
      animateOnHover: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Author',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.secondaryContainer,
                child: Text(
                  author[0],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Mindfulness Guide',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _FollowButton(),
        ],
      ),
    );
  }
}

class _FollowButton extends StatefulWidget {
  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _following = !_following),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _following ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _following ? 'Following' : 'Follow',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _following ? AppColors.onPrimary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _TagsCard extends StatelessWidget {
  const _TagsCard({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final tags = ['#routine', '#mindfulness', '#mornings', '#growth'];
    final colors = [
      AppColors.primaryContainer,
      AppColors.surfaceContainerHigh,
      AppColors.tertiaryFixed,
      AppColors.secondaryContainer,
    ];

    return NeoBrutalCard(
      shadowOffset: 4,
      borderRadius: AppRadius.defaultRadius,
      animateOnHover: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 20),
              const SizedBox(width: AppSpacing.base),
              Text(
                'Tags',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.base,
            runSpacing: AppSpacing.base,
            children: List.generate(
              tags.length,
              (i) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: AppColors.onSurface,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                child: Text(
                  tags[i],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      backgroundColor: AppColors.primary,
      shadowOffset: 4,
      borderRadius: AppRadius.defaultRadius,
      animateOnHover: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const Icon(Icons.share, color: AppColors.onPrimary, size: 36),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Share this reflection',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Know someone who needs a little structure today?',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.onPrimary.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShareButton(label: 'X'),
              const SizedBox(width: AppSpacing.base),
              _ShareButton(label: 'in'),
              const SizedBox(width: AppSpacing.base),
              _ShareButton(icon: Icons.link),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({this.label, this.icon});
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.onSurface,
          width: AppSpacing.borderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, size: 18, color: AppColors.primary)
            : Text(
                label!,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
      ),
    );
  }
}
