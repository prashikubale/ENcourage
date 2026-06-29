import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/radius.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/post_card.dart';
import '../../../../shared/widgets/neo_brutal_card.dart';

/// My Feed page - shows posts from joined communities
class MyFeedPage extends StatefulWidget {
  const MyFeedPage({super.key});

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<PostModel> _allPosts = [];
  final List<String> _joinedCommunities = ['study', 'mental_health', 'books'];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  final _filters = ['All', 'Mental Health', 'Study', 'Books'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final postsJson = await rootBundle.loadString('assets/mock/posts.json');
    final postsData = json.decode(postsJson) as Map<String, dynamic>;
    final allPosts = (postsData['posts'] as List<dynamic>)
        .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
        .toList();

    if (mounted) {
      setState(() {
        _allPosts = allPosts;
        _isLoading = false;
      });
    }
  }

  List<PostModel> get _filteredPosts {
    final joined = _allPosts
        .where((p) => _joinedCommunities.contains(p.communityId))
        .toList();

    if (_selectedFilter == 'All') return joined;
    return joined
        .where(
          (p) =>
              p.category.toLowerCase().contains(
                _selectedFilter.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'My Feed'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final filtered = _filteredPosts;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'My Feed',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Posts from your joined communities.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Joined communities banner
              _JoinedCommunitiesBar(joined: _joinedCommunities),
              const SizedBox(height: AppSpacing.md),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final isSelected = f == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.base),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.base,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: AppColors.onSurface,
                              width: AppSpacing.borderWidth,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                offset: isSelected
                                    ? const Offset(2, 2)
                                    : const Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ]),
          ),
        ),
        if (filtered.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: _EmptyFeedCard(),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final post = filtered[index];
                return PostCard(
                  post: post,
                  onTap: () => context.push('/post/${post.id}'),
                );
              },
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.lg)),
      ],
    );
  }
}

class _JoinedCommunitiesBar extends StatelessWidget {
  const _JoinedCommunitiesBar({required this.joined});
  final List<String> joined;

  @override
  Widget build(BuildContext context) {
    final labels = {
      'study': ('Study', AppColors.secondaryContainer),
      'mental_health': ('Mental Health', AppColors.primaryFixed),
      'books': ('Books', AppColors.tertiaryFixed),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: joined.map((id) {
          final (name, color) = labels[id] ?? (id, AppColors.surfaceContainerHigh);
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.base),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.onSurface,
                  width: AppSpacing.borderWidth,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    name,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyFeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      backgroundColor: AppColors.primaryFixed,
      borderRadius: AppRadius.defaultRadius,
      shadowOffset: 8,
      animateOnHover: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(
            Icons.article_outlined,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No posts yet',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Join more communities to see posts in your feed.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
