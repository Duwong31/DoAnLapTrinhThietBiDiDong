import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../../../data/sources/source_songs.dart';
import '../../../routes/app_pages.dart';
import '../bindings/audio_service.dart';
import 'MiniPlayer.dart';

class AllSongsView extends StatefulWidget {
  const AllSongsView({super.key});

  @override
  State<AllSongsView> createState() => _AllSongsViewState();
}

class _AllSongsViewState extends State<AllSongsView> {
  late List<Song> _songs = [];
  bool _isLoading = false;          // để biết app có đang tải dữ liệu hay không
  bool _hasMore = true;             //  dùng để xác định xem còn dữ liệu để tải tiếp không
  int _currentPage = 1;
  final int _perPage = 20;

  final AudioService _audioService = AudioService();     // quản lý logic phát nhạc
  late final AudioPlayer _player;               // Đối tượng từ thư viện phát nhạc, như just_audio
  Song? _currentlyPlaying;                      // Lưu bài hát hiện đang phát. null nếu chưa phát bài nào.
  final ScrollController _scrollController = ScrollController();      // Điều khiển scroll của ListView, dùng để detect người dùng cuộn đến cuối danh sách để tải thêm bài mới.

  @override
  void initState() {
    super.initState();
    _loadMoreSongs();
    _scrollController.addListener(_scrollListener);
    _player = _audioService.player;
    _currentlyPlaying = _audioService.currentSong;

    _loadMoreSongs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreSongs();
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreSongs();
    }
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

  // Khởi tạo và tải dữ liệu
  Future<void> _navigateToMiniPlayer(Song song, List<Song> allSongs) async {
    await _audioService.setPlaylist(allSongs, startIndex: allSongs.indexOf(song));
    await _audioService.player.play();
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
      onTap: () => _navigateToMiniPlayer(song, allSongs),
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
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'Songs',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
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
              itemExtent: 70, // Đặt chiều cao cố định cho mỗi item
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

          StreamBuilder<Song>(
            stream: AudioService().currentSongStream,
            builder: (context, snapshot) {
              final current = snapshot.data ?? AudioService().currentSong;
              if (current == null) return const SizedBox.shrink();
              return Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: MiniPlayer(
                  key: ValueKey(current.id),
                  song: current,
                  songs: _songs,
                  onTap: () async {
                    final returnedSong = await Get.toNamed(
                      Routes.songs_view,
                      arguments: {
                        'playingSong': current,
                        'songs': _songs,
                      },
                    );
                    setState(() {
                      _currentlyPlaying = returnedSong ?? AudioService().currentSong;     // cập nhật lại bài hát hiện tại đang phát
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
