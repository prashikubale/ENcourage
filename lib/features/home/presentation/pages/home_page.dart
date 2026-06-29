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
import '../../../../shared/widgets/neo_brutal_card.dart';
import '../../../../shared/widgets/post_card.dart';
import '../../../../shared/widgets/app_button.dart';

/// Home feed page showing encouraging posts
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final jsonStr = await rootBundle.loadString('assets/mock/posts.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    final posts = (data['posts'] as List<dynamic>)
        .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
        .toList();
    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'Encourage'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildFeed(),
    );
  }

  Widget _buildFeed() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Greeting section
              _GreetingSection(),
              const SizedBox(height: AppSpacing.md),

              // Daily prompt card
              _DailyPromptCard(),
              const SizedBox(height: AppSpacing.md),

              // Section divider
              _FeedDivider(label: 'Recent Thoughts'),
              const SizedBox(height: AppSpacing.md),
            ]),
          ),
        ),

        // Posts feed
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: _posts.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final post = _posts[index];
              return PostCard(
                post: post,
                onTap: () => context.push('/post/${post.id}'),
                onLike: () {
                  setState(() {
                    _posts[index] = post.copyWith(
                      isLiked: !post.isLiked,
                      likes: post.isLiked ? post.likes - 1 : post.likes + 1,
                    );
                  });
                },
              );
            },
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Alex.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Take a deep breath. Here is your sanctuary for today.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DailyPromptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeoBrutalCard(
      backgroundColor: AppColors.brandPrimary,
      borderRadius: AppRadius.md,
      shadowOffset: 8,
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
            'What is one small thing that brought you peace today?',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Write Reflection',
            icon: Icons.edit_outlined,
            backgroundColor: AppColors.surfaceContainerLowest,
            textColor: AppColors.onSurface,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _FeedDivider extends StatelessWidget {
  const _FeedDivider({required this.label});
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
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: 2.5,
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
