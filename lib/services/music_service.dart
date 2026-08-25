import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/music_model.dart';

class MusicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Whitelist of allowed music sources
  static const List<String> allowedSources = [
    'youtube.com',
    'youtu.be',
    'spotify.com',
    'tiktok.com',
    'soundcloud.com',
  ];

  // Validate URL source
  bool isValidMusicUrl(String url) {
    return allowedSources.any((source) => url.contains(source));
  }

  // Add new music post
  Future<String?> addMusic({
    required String userId,
    required String username,
    required String? userPhotoUrl,
    String? userBadge,
    required String title,
    required String artist,
    required String musicUrl,
    required String source,
    String? videoId,
    String? albumId,
    String? description,
  }) async {
    try {
      if (!isValidMusicUrl(musicUrl)) {
        throw Exception('Music source not supported');
      }

      final music = MusicModel(
        id: _firestore.collection('music').doc().id,
        userId: userId,
        username: username,
        userPhotoUrl: userPhotoUrl,
        userBadge: userBadge,
        title: title,
        artist: artist,
        musicUrl: musicUrl,
        source: MusicSource.values.firstWhere(
          (e) => e.name == source,
          orElse: () => MusicSource.youtube,
        ),
        videoId: videoId,
        albumId: albumId,
        description: description,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('music')
          .doc(music.id)
          .set(music.toJson());

      return music.id;
    } catch (e) {
      print('Error adding music: $e');
      return null;
    }
  }

  // Get all music feed (paginated)
  Future<List<MusicModel>> getMusicFeed({
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore
          .collection('music')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => MusicModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting music feed: $e');
      return [];
    }
  }

  // Get music by user
  Future<List<MusicModel>> getUserMusic(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('music')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MusicModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user music: $e');
      return [];
    }
  }

  // Get music by album
  Future<List<MusicModel>> getAlbumMusic(String albumId) async {
    try {
      final snapshot = await _firestore
          .collection('music')
          .where('albumId', isEqualTo: albumId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MusicModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting album music: $e');
      return [];
    }
  }

  // Get single music
  Future<MusicModel?> getMusic(String musicId) async {
    try {
      final doc = await _firestore.collection('music').doc(musicId).get();
      if (doc.exists) {
        return MusicModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting music: $e');
      return null;
    }
  }

  // Rate music
  Future<void> rateMusic({
    required String musicId,
    required double rating,
  }) async {
    try {
      final music = await getMusic(musicId);
      if (music != null) {
        final newRatingCount = music.ratingCount + 1;
        final newRating =
            ((music.rating * music.ratingCount) + rating) / newRatingCount;

        await _firestore.collection('music').doc(musicId).update({
          'rating': newRating,
          'ratingCount': newRatingCount,
        });
      }
    } catch (e) {
      print('Error rating music: $e');
    }
  }

  // Like music
  Future<void> likeMusic({
    required String musicId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('music').doc(musicId).update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error liking music: $e');
    }
  }

  // Unlike music
  Future<void> unlikeMusic({
    required String musicId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('music').doc(musicId).update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error unliking music: $e');
    }
  }

  // Delete music
  Future<void> deleteMusic(String musicId) async {
    try {
      await _firestore.collection('music').doc(musicId).delete();
    } catch (e) {
      print('Error deleting music: $e');
    }
  }

  // Search music
  Future<List<MusicModel>> searchMusic(String query) async {
    try {
      // Simple search - bisa di-improve dengan Algolia nanti
      final snapshot = await _firestore.collection('music').get();

      final results = snapshot.docs
          .map((doc) => MusicModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((music) =>
              music.title.toLowerCase().contains(query.toLowerCase()) ||
              music.artist.toLowerCase().contains(query.toLowerCase()) ||
              music.username.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return results;
    } catch (e) {
      print('Error searching music: $e');
      return [];
    }
  }
}
