import 'package:flutter/material.dart';
import 'package:soundflow/data/models/songs/all_songs.dart';
import 'package:soundflow/data/sources/songs/source_songs.dart';
import 'now_playing/playing.dart';

class AllSongsView extends StatefulWidget {
  const AllSongsView({super.key});

  @override
  State<AllSongsView> createState() => _AllSongsViewState();
}

class _AllSongsViewState extends State<AllSongsView> {
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = _fetchSongs();
  }

  Future<List<Song>> _fetchSongs() async {
    try {
      final songs = await RemoteDataSource().loadData();
      return songs ?? [];
    } catch (e) {
      debugPrint('Error fetching songs: $e');
      throw Exception('Failed to load songs'); // Better error handling
    }
  }

  void _refreshSongs() {
    setState(() {
      _songsFuture = _fetchSongs();
    });
  }

  // Hàm chuyển sang trang NowPlaying
  void _navigateToNowPlaying(Song song, List<Song> allSongs, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlaying(
          playingSong: song,
          songs: allSongs,
        ),
      ),
    );
  }

  Widget _buildSongItem(Song song, List<Song> allSongs, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.image.isNotEmpty
            ? Image.network(
          song.image,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
        )
            : _buildPlaceholderImage(),
      ),
      title: Text(
        song.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {}, // Add menu functionality later
      ),
      onTap: () => _navigateToNowPlaying(song, allSongs, context),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 56,
      height: 56,
      color: Colors.grey[200],
      child: const Icon(Icons.music_note, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _refreshSongs(),
        child: FutureBuilder<List<Song>>(
          future: _songsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) => _buildSongItem(
                songs[index],
                songs, // Truyền toàn bộ danh sách bài hát
                context,
              ),
            );
          },
        ),
      ),
    );
  }
}