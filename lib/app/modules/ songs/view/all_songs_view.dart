import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../../../data/sources/source_songs.dart';
import '../bindings/audio_service.dart';
import '../bindings/songs_binding.dart';
import 'MiniPlayer.dart';
import 'songs_view.dart';

class AllSongsView extends StatefulWidget {
  const AllSongsView({super.key});

  @override
  State<AllSongsView> createState() => _AllSongsViewState();
}

class _AllSongsViewState extends State<AllSongsView> {
  final List<Song> _songs = [];
  bool _isLoading = false;          // để biết app có đang tải dữ liệu hay không
  bool _hasMore = true;             //  dùng để xác định xem còn dữ liệu để tải tiếp không
  int _currentPage = 1;
  final int _perPage = 20;

  late final AudioService _audioService;        // quản lý logic phát nhạc
  late final AudioPlayer _player;               // Đối tượng từ thư viện phát nhạc, như just_audio
  Song? _currentlyPlaying;                      // Lưu bài hát hiện đang phát. null nếu chưa phát bài nào.
  final ScrollController _scrollController = ScrollController();      // Điều khiển scroll của ListView, dùng để detect người dùng cuộn đến cuối danh sách để tải thêm bài mới.

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _player = _audioService.player;
    _currentlyPlaying = _audioService.currentSong;

    _loadMoreSongs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreSongs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreSongs() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    try {
      final newSongs = await RemoteDataSource().loadData(
        page: _currentPage,
        perPage: _perPage,
      );
      if (newSongs == null || newSongs.isEmpty) {
        setState(() => _hasMore = false);
      } else {
        setState(() {
          _songs.addAll(newSongs);
          _currentPage++;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load songs: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _refreshSongs() async {
    setState(() {
      _currentPage = 1;
      _songs.clear();
      _hasMore = true;
      _isLoading = false;
    });
    await _loadMoreSongs();
  }

  // hàm sẽ chuyển qua màn NowPlaying
  Future<void> _navigateToNowPlaying(Song song, List<Song> allSongs) async {
    final audioService = AudioService();

    await audioService.setSong(song.source, song: song);

    // Sử dụng Get.offAll để xử lý đúng navigation stack
    final returnedSong = await Get.to<Song>(
          () => NowPlaying(playingSong: song, songs: allSongs),
      binding: NowPlayingBinding(),
      arguments: {
        'songs': allSongs,
        'currentSong': song,
      },
    );

    setState(() {
      _currentlyPlaying = returnedSong ?? audioService.currentSong;
    });
  }

  Widget _buildSongItem(Song song, List<Song> allSongs) {
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
      onTap: () => _navigateToNowPlaying(song, allSongs),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      width: 56,
      height: 56,
      child: const Icon(Icons.music_note, color: Colors.grey),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _hasMore
            ? const CircularProgressIndicator()
            : const Text('No more songs to load'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Text(
            "Songs",
            style: TextStyle(
              color: Colors.orange[500],
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshSongs,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: _songs.length + 1,
              itemBuilder: (context, index) {
                if (index < _songs.length) {
                  return _buildSongItem(_songs[index], _songs);
                } else {
                  return _buildProgressIndicator();
                }
              },
            ),
          ),
          if (_currentlyPlaying != null)
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: MiniPlayer(
                key: ValueKey(_currentlyPlaying!.id),
                song: _currentlyPlaying!,
                songs: _songs,
                onTap: () async {
                  final returnedSong = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlaying(
                        playingSong: _currentlyPlaying!,
                        songs: _songs,
                      ),
                    ),
                  );
                  setState(() {
                    _currentlyPlaying = returnedSong ?? AudioService().currentSong;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
