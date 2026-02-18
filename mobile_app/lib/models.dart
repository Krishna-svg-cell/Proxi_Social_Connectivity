class User {
  final String username;
  final String avatarFormal; // NEW
  final String avatarCasual; // NEW
  final String bio;
  final String bleUuid;
  final List<String> followers;
  final List<String> following;

  User(
      {required this.username,
      required this.avatarFormal,
      required this.avatarCasual,
      required this.bio,
      required this.bleUuid,
      required this.followers,
      required this.following});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      avatarFormal: json['avatar_formal'] ?? '',
      avatarCasual: json['avatar_casual'] ?? '',
      bio: json['bio'] ?? '',
      bleUuid: json['ble_uuid'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }

  // Helper to get current avatar based on mode
  String getAvatar(bool isFormal) => isFormal ? avatarFormal : avatarCasual;
}

class Post {
  final String id;
  final String username;
  final String authorAvatar; // NEW: The avatar to show on the post
  final String text;
  final String? mediaUrl;
  final List<String> likes;
  final List<Comment> comments;

  Post(
      {required this.id,
      required this.username,
      required this.authorAvatar,
      required this.text,
      this.mediaUrl,
      required this.likes,
      required this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      username: json['username'],
      authorAvatar: json['author_avatar'] ?? '', // Backend sends this
      text: json['text'],
      mediaUrl: json['media_url'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}

class Comment {
  final String user;
  final String text;
  Comment({required this.user, required this.text});
  factory Comment.fromJson(Map<String, dynamic> json) =>
      Comment(user: json['user'], text: json['text']);
}

class NotificationItem {
  final String fromUser;
  final String type;
  final String text;
  NotificationItem(
      {required this.fromUser, required this.type, required this.text});
  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
          fromUser: json['from'], type: json['type'], text: json['text']);
}
