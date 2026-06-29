/// Profile model representing the user's profile data
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.username,
    required this.bio,
    required this.role,
    required this.avatarUrl,
    required this.reflectionsWritten,
    required this.communitiesJoined,
    required this.dayStreak,
    required this.personalBest,
    required this.weeklyActivity,
    required this.joinedCommunities,
    required this.recentPosts,
  });

  final String id;
  final String username;
  final String bio;
  final String role;
  final String avatarUrl;
  final int reflectionsWritten;
  final int communitiesJoined;
  final int dayStreak;
  final int personalBest;
  final List<int> weeklyActivity;
  final List<String> joinedCommunities;
  final List<RecentPostModel> recentPosts;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String,
      reflectionsWritten: json['reflectionsWritten'] as int,
      communitiesJoined: json['communitiesJoined'] as int,
      dayStreak: json['dayStreak'] as int,
      personalBest: json['personalBest'] as int,
      weeklyActivity: (json['weeklyActivity'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      joinedCommunities: (json['joinedCommunities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recentPosts: (json['recentPosts'] as List<dynamic>)
          .map((e) => RecentPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ProfileModel copyWith({
    String? id,
    String? username,
    String? bio,
    String? role,
    String? avatarUrl,
    int? reflectionsWritten,
    int? communitiesJoined,
    int? dayStreak,
    int? personalBest,
    List<int>? weeklyActivity,
    List<String>? joinedCommunities,
    List<RecentPostModel>? recentPosts,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reflectionsWritten: reflectionsWritten ?? this.reflectionsWritten,
      communitiesJoined: communitiesJoined ?? this.communitiesJoined,
      dayStreak: dayStreak ?? this.dayStreak,
      personalBest: personalBest ?? this.personalBest,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      joinedCommunities: joinedCommunities ?? this.joinedCommunities,
      recentPosts: recentPosts ?? this.recentPosts,
    );
  }
}

class RecentPostModel {
  const RecentPostModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.timestamp,
  });

  final String id;
  final String title;
  final String excerpt;
  final String category;
  final String timestamp;

  factory RecentPostModel.fromJson(Map<String, dynamic> json) {
    return RecentPostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      category: json['category'] as String,
      timestamp: json['timestamp'] as String,
    );
  }
}
