/// Community model representing a domain/category community
class CommunityModel {
  const CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.memberCount,
    required this.postCount,
    required this.isJoined,
  });

  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int memberCount;
  final int postCount;
  final bool isJoined;

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      memberCount: json['memberCount'] as int,
      postCount: json['postCount'] as int,
      isJoined: json['isJoined'] as bool,
    );
  }

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    int? memberCount,
    int? postCount,
    bool? isJoined,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      memberCount: memberCount ?? this.memberCount,
      postCount: postCount ?? this.postCount,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
