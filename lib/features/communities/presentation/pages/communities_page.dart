import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../shared/widgets/app_header.dart';

/// Communities page - matches reference 1.html "Explore Domains"
class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  List<CommunityModel> _communities = [];
  List<CommunityModel> _filtered = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCommunities();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunities() async {
    final jsonStr =
        await rootBundle.loadString('assets/mock/communities.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    final communities = (data['communities'] as List<dynamic>)
        .map((c) => CommunityModel.fromJson(c as Map<String, dynamic>))
        .toList();
    if (mounted) {
      setState(() {
        _communities = communities;
        _filtered = communities;
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _communities
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.description.toLowerCase().contains(q),
          )
          .toList();
    });
  }

  void _toggleJoin(int index) {
    final realIndex = _communities.indexOf(_filtered[index]);
    setState(() {
      _communities[realIndex] = _communities[realIndex].copyWith(
        isJoined: !_communities[realIndex].isJoined,
      );
      _filtered[index] = _communities[realIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'Communities'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header section
              Text(
                'Explore Domains',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isWide ? 48 : 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: isWide ? -1 : -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Dive into curated spaces designed for focus, relaxation, and growth.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Search bar
              _SearchBar(controller: _searchController),
              const SizedBox(height: AppSpacing.md),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: isWide
              ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CommunityCard(
                      community: _filtered[index],
                      onJoin: () => _toggleJoin(index),
                    ),
                    childCount: _filtered.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.9,
                  ),
                )
              : SliverList.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => CommunityCard(
                    community: _filtered[index],
                    onJoin: () => _toggleJoin(index),
                  ),
                ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.lg)),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _isFocused ? AppColors.primary : AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused ? AppColors.primary : AppColors.shadow,
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: Icon(
                Icons.search,
                color: _isFocused
                    ? AppColors.primary
                    : AppColors.outline,
              ),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search domains, topics, or keywords...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.outlineVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _SearchButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchButton extends StatefulWidget {
  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: _isPressed
            ? Matrix4.translationValues(4, 4, 0)
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
          boxShadow: _isPressed
              ? []
              : const [
                  BoxShadow(
                    color: AppColors.shadow,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Text(
          'Search',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// Community card widget
class CommunityCard extends StatefulWidget {
  const CommunityCard({
    super.key,
    required this.community,
    this.onJoin,
    this.onTap,
  });

  final CommunityModel community;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool _isHovered = false;

  Color _getCardColor() {
    return switch (widget.community.color) {
      'secondary_container' => AppColors.secondaryContainer,
      'tertiary_container' => AppColors.tertiaryContainer,
      'primary_fixed' => AppColors.primaryFixed,
      'surface_container_high' => AppColors.surfaceContainerHigh,
      'tertiary_fixed' => AppColors.tertiaryFixed,
      'primary_container' => AppColors.primaryContainer,
      _ => AppColors.surfaceContainerLow,
    };
  }

  IconData _getIcon() {
    return switch (widget.community.icon) {
      'local_library' => Icons.local_library_outlined,
      'movie' => Icons.movie_outlined,
      'psychology' => Icons.psychology_outlined,
      'fitness_center' => Icons.fitness_center,
      'book' => Icons.book_outlined,
      'music_note' => Icons.music_note_outlined,
      'photo_camera' => Icons.photo_camera_outlined,
      'travel_explore' => Icons.travel_explore,
      _ => Icons.explore_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor();
    final icon = _getIcon();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered
              ? (Matrix4.translationValues(4, 4, 0))
              : Matrix4.identity(),
          height: 256,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.defaultRadius),
            border: Border.all(
              color: AppColors.onSurface,
              width: AppSpacing.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: _isHovered
                    ? const Offset(4, 4)
                    : const Offset(8, 8),
                blurRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decorative element
              Positioned(
                top: -16,
                right: -16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 96,
                  height: 96,
                  transform: _isHovered
                      ? (Matrix4.diagonal3Values(1.1, 1.1, 1.0))
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.onSurface,
                      width: AppSpacing.borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, size: 48, color: AppColors.onSurface),
                  ),
                ),
              ),

              // Content at bottom
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Column(
                  children: [
                    // Info card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.community.name,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              _JoinButton(
                                isJoined: widget.community.isJoined,
                                onTap: widget.onJoin,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.community.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                '${_formatCount(widget.community.memberCount)} members',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '·',
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.outline,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${_formatCount(widget.community.postCount)} posts',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.isJoined, this.onTap});
  final bool isJoined;
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
          color: isJoined ? AppColors.surfaceContainerHigh : AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: AppColors.onSurface,
            width: AppSpacing.borderWidth,
          ),
        ),
        child: Text(
          isJoined ? 'Joined' : 'Join',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isJoined ? AppColors.onSurface : AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}
