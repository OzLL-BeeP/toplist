import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/music_model.dart';

class MusicDetailScreen extends StatefulWidget {
  final MusicModel music;

  const MusicDetailScreen({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  State<MusicDetailScreen> createState() => _MusicDetailScreenState();
}

class _MusicDetailScreenState extends State<MusicDetailScreen> {
  late YoutubePlayerController _youtubeController;
  double _userRating = 0;
  bool _isLiked = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
  }

  void _initializeYoutubePlayer() {
    final videoId = MusicModel.extractYouTubeId(widget.music.musicUrl);
    
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareMusic,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // YouTube Player
            if (widget.music.source == MusicSource.youtube)
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: const Color(0xFFff5722),
                onReady: () {
                  print('Player is ready');
                },
              )
            else
              Container(
                height: 250,
                color: const Color(0xFF1E1E1E),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_note, size: 64, color: Color(0xFF666666)),
                      const SizedBox(height: 16),
                      Text(
                        'Open in ${widget.music.source.name}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Open URL in browser
                        },
                        child: const Text('Open Link'),
                      ),
                    ],
                  ),
                ),
              ),

            // Music Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.music.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),

                  // Artist
                  Text(
                    widget.music.artist,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFb0b0b0),
                        ),
                  ),
                  const SizedBox(height: 16),

                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: widget.music.userPhotoUrl != null
                            ? NetworkImage(widget.music.userPhotoUrl!)
                            : null,
                        child: widget.music.userPhotoUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.music.username,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Posted ${_timeAgo(widget.music.createdAt)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Follow user
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff5722),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  if (widget.music.description != null) ...[
                    Text(
                      widget.music.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Rating Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate this music',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: List.generate(
                                  5,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      setState(() => _userRating = index + 1.0);
                                      // TODO: Submit rating
                                    },
                                    child: Icon(
                                      Icons.star,
                                      color: index < _userRating
                                          ? const Color(0xFFffc107)
                                          : const Color(0xFF666666),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${widget.music.rating.toStringAsFixed(1)}★',
                              style:
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFffc107),
                                      ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.music.ratingCount} ratings',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Engagement Stats
                  Row(
                    children: [
                      Expanded(
                        child: _EngagementStat(
                          icon: Icons.favorite_border,
                          count: widget.music.likes,
                          label: 'Likes',
                          isActive: _isLiked,
                          onTap: () {
                            setState(() => _isLiked = !_isLiked);
                            // TODO: Like/unlike
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _EngagementStat(
                          icon: Icons.comment_outlined,
                          count: widget.music.commentCount,
                          label: 'Comments',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Comments Section
                  Text(
                    'Comments (${widget.music.commentCount})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),

                  // Comment Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFFff5722)),
                        onPressed: () {
                          // TODO: Submit comment
                          _commentController.clear();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Comments List (TODO: Load from Firestore)
                  const Text('No comments yet'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'now';
  }

  void _shareMusic() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share coming soon!')),
    );
  }
}

class _EngagementStat extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _EngagementStat({
    Key? key,
    required this.icon,
    required this.count,
    required this.label,
    this.isActive = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFFff5722) : const Color(0xFF333333),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFFff5722) : const Color(0xFFb0b0b0),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? const Color(0xFFff5722)
                        : const Color(0xFFe0e0e0),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
