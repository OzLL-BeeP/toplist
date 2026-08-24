import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/music_service.dart';
import '../models/music_model.dart';
import '../models/user_model.dart';
import 'music_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final MusicService _musicService = MusicService();
  late UserModel? _currentUser;
  late List<MusicModel> _musicFeed = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserAndMusic();
  }

  Future<void> _loadUserAndMusic() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        _currentUser = await _authService.getUserModel(currentUser.uid);
        _musicFeed = await _musicService.getMusicFeed();
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopList'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: _showAddMusicDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            onPressed: () {
              // TODO: Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 24),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _musicFeed.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_note, size: 64, color: Color(0xFF666666)),
                      const SizedBox(height: 16),
                      Text(
                        'No music shared yet',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to share your favorite music!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _musicFeed.length,
                  itemBuilder: (context, index) {
                    final music = _musicFeed[index];
                    return MusicCard(
                      music: music,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MusicDetailScreen(music: music),
                          ),
                        );
                      },
                      onLike: () {
                        // TODO: Handle like
                      },
                    );
                  },
                ),
    );
  }

  void _showAddMusicDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddMusicBottomSheet(
        onAdd: (title, artist, url) {
          // TODO: Add music to database
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Music added!')),
          );
        },
      ),
    );
  }
}

// Music Card Widget
class MusicCard extends StatelessWidget {
  final MusicModel music;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const MusicCard({
    Key? key,
    required this.music,
    required this.onTap,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: music.userPhotoUrl != null
                        ? NetworkImage(music.userPhotoUrl!)
                        : null,
                    child: music.userPhotoUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music.username,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Posted ${_timeAgo(music.createdAt)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () {
                      // TODO: Show options menu
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Music info
              Text(
                music.title,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                music.artist,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (music.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  music.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),

              // Engagement stats
              Row(
                children: [
                  _StatWidget(
                    icon: Icons.favorite_border,
                    count: music.likes,
                    onTap: onLike,
                  ),
                  const SizedBox(width: 16),
                  _StatWidget(
                    icon: Icons.comment_outlined,
                    count: music.commentCount,
                    onTap: onTap,
                  ),
                  const SizedBox(width: 16),
                  _StatWidget(
                    icon: Icons.star_border,
                    count: music.ratingCount,
                    label: '${music.rating.toStringAsFixed(1)}★',
                  ),
                ],
              ),
            ],
          ),
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
}

// Stat Widget
class _StatWidget extends StatelessWidget {
  final IconData icon;
  final int count;
  final String? label;
  final VoidCallback? onTap;

  const _StatWidget({
    Key? key,
    required this.icon,
    required this.count,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFff5722)),
          const SizedBox(width: 4),
          Text(
            label ?? count.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFff5722),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// Add Music Bottom Sheet
class AddMusicBottomSheet extends StatefulWidget {
  final Function(String title, String artist, String url) onAdd;

  const AddMusicBottomSheet({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  State<AddMusicBottomSheet> createState() => _AddMusicBottomSheetState();
}

class _AddMusicBottomSheetState extends State<AddMusicBottomSheet> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Music',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Song Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _artistController,
            decoration: InputDecoration(
              hintText: 'Artist Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'YouTube/Spotify URL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _addMusic,
              child: Text(_isLoading ? 'Adding...' : 'Add Music'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMusic() async {
    if (_titleController.text.isEmpty ||
        _artistController.text.isEmpty ||
        _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      widget.onAdd(
        _titleController.text,
        _artistController.text,
        _urlController.text,
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
