enum MusicSource { youtube, spotify, tiktok, soundcloud, instagram }

class MusicModel {
  final String id;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String title;
  final String artist;
  final String musicUrl;
  final MusicSource source;
  final String? videoId; // For YouTube
  final String? albumId;
  final String? description;
  final double rating; // Average rating (0-5)
  final int ratingCount;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final int commentCount;

  MusicModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.title,
    required this.artist,
    required this.musicUrl,
    required this.source,
    this.videoId,
    this.albumId,
    this.description,
    this.rating = 0,
    this.ratingCount = 0,
    this.likes = 0,
    this.likedBy = const [],
    required this.createdAt,
    this.commentCount = 0,
  });

  // Extract video ID from YouTube URL
  static String? extractYouTubeId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  // Detect source from URL
  static MusicSource detectSource(String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return MusicSource.youtube;
    } else if (url.contains('spotify.com')) {
      return MusicSource.spotify;
    } else if (url.contains('tiktok.com')) {
      return MusicSource.tiktok;
    } else if (url.contains('soundcloud.com')) {
      return MusicSource.soundcloud;
    } else if (url.contains('instagram.com')) {
      return MusicSource.instagram;
    }
    return MusicSource.youtube; // Default
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'title': title,
      'artist': artist,
      'musicUrl': musicUrl,
      'source': source.name,
      'videoId': videoId,
      'albumId': albumId,
      'description': description,
      'rating': rating,
      'ratingCount': ratingCount,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'commentCount': commentCount,
    };
  }

  // Create from JSON
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Unknown',
      userPhotoUrl: json['userPhotoUrl'],
      title: json['title'] ?? 'Untitled',
      artist: json['artist'] ?? 'Unknown Artist',
      musicUrl: json['musicUrl'] ?? '',
      source: MusicSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => MusicSource.youtube,
      ),
      videoId: json['videoId'],
      albumId: json['albumId'],
      description: json['description'],
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      commentCount: json['commentCount'] ?? 0,
    );
  }

  // Copy with modifications
  MusicModel copyWith({
    double? rating,
    int? ratingCount,
    int? likes,
    List<String>? likedBy,
    int? commentCount,
  }) {
    return MusicModel(
      id: id,
      userId: userId,
      username: username,
      userPhotoUrl: userPhotoUrl,
      title: title,
      artist: artist,
      musicUrl: musicUrl,
      source: source,
      videoId: videoId,
      albumId: albumId,
      description: description,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
