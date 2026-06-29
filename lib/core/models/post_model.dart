/// Post model representing an encouraging post/reflection
class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.categoryColor,
    required this.author,
    required this.authorId,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.hasImage,
    required this.imageUrl,
    required this.communityId,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final String categoryColor;
  final String author;
  final String authorId;
  final String timestamp;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool hasImage;
  final String imageUrl;
  final String communityId;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      categoryColor: json['categoryColor'] as String,
      author: json['author'] as String,
      authorId: json['authorId'] as String,
      timestamp: json['timestamp'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      isLiked: json['isLiked'] as bool,
      hasImage: json['hasImage'] as bool,
      imageUrl: json['imageUrl'] as String,
      communityId: json['communityId'] as String,
    );
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    String? categoryColor,
    String? author,
    String? authorId,
    String? timestamp,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? hasImage,
    String? imageUrl,
    String? communityId,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      hasImage: hasImage ?? this.hasImage,
      imageUrl: imageUrl ?? this.imageUrl,
      communityId: communityId ?? this.communityId,
    );
  }
}
