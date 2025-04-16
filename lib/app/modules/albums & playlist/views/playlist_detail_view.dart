// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_now_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import model, controller, style và widget bottom sheet
import '../../../data/models/playlist.dart';           // <-- Điều chỉnh đường dẫn nếu cần
import '../controllers/playlist_page_controller.dart';  // <-- Điều chỉnh đường dẫn
import '../../../core/styles/style.dart';           // <-- Điều chỉnh đường dẫn nếu cần (cho Dimes)
import '../../../widgets/bottom_song_options.dart';  // <-- Điều chỉnh đường dẫn nếu cần

class PlayListNow extends StatefulWidget {
  // Giữ constructor gốc
  const PlayListNow({Key? key}) : super(key: key);

  @override
  State<PlayListNow> createState() => _PlayListNowState();
}

class _PlayListNowState extends State<PlayListNow> {
  // Giữ lại state variables và việc lấy controller instance
  final scrollController = ScrollController();
  bool showTitle = false;
  final PlayListController _controller = Get.find<PlayListController>();
  Playlist? _playlistData;

  @override
  void initState() {
    super.initState();
    // Giữ lại logic lấy arguments và xử lý lỗi
    try {
       _playlistData = Get.arguments as Playlist?;
    } catch (e) {
       print("Error getting playlist arguments: $e");
       // Đảm bảo an toàn khi gọi Get.back và Get.snackbar sau khi frame được build
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) { // Kiểm tra widget còn tồn tại không
           Get.back();
           Get.snackbar(
             "Error",
             "Could not load playlist details.",
             snackPosition: SnackPosition.BOTTOM,
             backgroundColor: Colors.redAccent,
             colorText: Colors.white
           );
         }
       });
    }

    // Giữ lại logic của scroll listener với threshold gốc
    scrollController.addListener(() {
      const double threshold = 200.0; // Ngưỡng gốc
      if (scrollController.offset > threshold && !showTitle) {
         if (mounted) { // Luôn kiểm tra mounted trước khi gọi setState trong listener
           setState(() {
             showTitle = true;
           });
         }
      } else if (scrollController.offset <= threshold && showTitle) {
        if (mounted) {
           setState(() {
             showTitle = false;
           });
         }
      }
    });
  }

  @override
  void dispose() {
    // Giữ lại logic dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Giữ lại kiểm tra null cho _playlistData
    if (_playlistData == null) {
      // Cung cấp một màn hình lỗi cơ bản nếu dữ liệu không load được
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: Get.back),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: Text("Playlist details not available.")),
      );
    }

    // Sử dụng dữ liệu playlist đã được xác thực là không null
    final playlist = _playlistData!;

    // *** Sử dụng cấu trúc Scaffold và CustomScrollView gốc ***
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // *** SliverAppBar với cấu hình gốc ***
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,         // Chiều cao gốc
            backgroundColor: Colors.white, // Màu nền gốc
            elevation: 0,                // Elevation gốc
            leading: IconButton(
              // Icon và hành động gốc
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            // Logic hiển thị title gốc
            title: showTitle
                ? Text(
                    playlist.title, // Sử dụng title động từ data
                    style: const TextStyle(color: Colors.black),
                  )
                : null,
            centerTitle: true, // Giữ căn giữa title khi nó xuất hiện
            // FlexibleSpaceBar gốc, trỏ tới _buildHeader gốc
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, playlist), // Sử dụng header đã revert
              collapseMode: CollapseMode.parallax,        // Giữ hiệu ứng parallax
              // Không có title trong FlexibleSpaceBar ở code gốc
            ),
          ),
          // *** SliverToBoxAdapter cho các nút action với cấu trúc gốc ***
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16), // Padding gốc
              child: Column(
                children: [
                  SizedBox(height: 10), // Khoảng cách gốc
                  // Row chứa các nút với cấu trúc và icon gốc
                  Row( // Có thể dùng const vì children là const Icons
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.download_for_offline_outlined, size: 30, color: Colors.blue),
                          SizedBox(width: 10),
                          Icon(Icons.more_horiz_outlined, size: 30, color: Colors.blue),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.shuffle, size: 30, color: Colors.blue),
                          SizedBox(width: 10),
                          Icon(Icons.play_circle_outline, size: 30, color: Colors.blue), // Sử dụng play icon thay vì pause gốc
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 16), // Khoảng cách gốc
                ],
              ),
            ),
          ),
          // *** SliverList với cấu trúc ListTile gốc ***
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // TODO: Thay thế bằng dữ liệu bài hát thật từ controller hoặc state khác
                final songTitle = 'Bài hát mẫu ${index + 1}'; 
                final songArtist = 'Nghệ sĩ mẫu';         

                final songImageUrl = playlist.imageUrl;

                // ListTile với cấu trúc gốc
                return ListTile(
                  leading: ClipRRect( // Bo tròn ảnh bài hát
                     borderRadius: BorderRadius.circular(4),
                     child: Image.network(
                       songImageUrl, // Ảnh gốc hoặc ảnh bài hát thật
                       width: 50, height: 50, fit: BoxFit.cover,
                       // Error builder cho ảnh bài hát
                       errorBuilder: (c,e,s) => Container(
                         width: 50, height: 50,
                         color: Colors.grey[200],
                         child: const Icon(Icons.music_note, color: Colors.grey)
                       ),
                       // Loading builder cho ảnh bài hát
                        loadingBuilder: (context, child, loadingProgress) {
                         if (loadingProgress == null) return child;
                         return Container(
                            width: 50, height: 50,
                            color: Colors.grey[200],
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0, value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)),
                         );
                       },
                     ),
                  ),
                  title: Text(songTitle, maxLines: 1, overflow: TextOverflow.ellipsis), // Title gốc
                  subtitle: Text(songArtist, maxLines: 1, overflow: TextOverflow.ellipsis), // Subtitle gốc
                   onTap: () {
                     // TODO: Implement logic phát nhạc khi nhấn vào bài hát
                     print('Play song: $songTitle');
                   },
                  trailing: IconButton( // Trailing gốc
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Tùy chọn bài hát',
                    onPressed: () {
                      // *** QUAN TRỌNG: Gọi hàm show bottom sheet từ controller ***
                      // Bạn có thể truyền dữ liệu bài hát (khi có) vào đây
                      _controller.showSongOptionsBottomSheet(context /*, songData */);
                    },
                  ),
                );
              },
              childCount: 20, // Số lượng bài hát gốc (TODO: thay bằng số lượng thật)
            ),
          ),
        ],
      ),
    );
  }

  // *** Widget _buildHeader đã được revert về cấu trúc gốc ***
  // Nó nhận dữ liệu Playlist để hiển thị động
  Widget _buildHeader(BuildContext context, Playlist playlist) {
    // Cấu trúc Container gốc
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      color: Colors.white, // Màu nền gốc
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa gốc
        children: [
          // SizedBox và Image gốc
          SizedBox(
            width: 200, // Chiều rộng gốc
            height: 200, // Chiều cao gốc
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // Radius gốc
              child: Image.network(
                playlist.imageUrl, // Sử dụng URL ảnh động từ playlist
                fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300], // Placeholder màu xám
                    child: const Icon(Icons.music_note, size: 100, color: Colors.grey) // Icon nhạc
                  ),
                 loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    // Hiển thị loading indicator trong khi tải ảnh
                    return Container(
                       color: Colors.grey[300],
                       child: Center(
                          child: CircularProgressIndicator(
                             value: loadingProgress.expectedTotalBytes != null
                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                               : null, // Hiển thị tiến trình nếu có
                           )
                        )
                     );
                 },
              ),
            ),
          ),
          // Khoảng cách gốc (Sử dụng Dimes nếu có, không thì SizedBox)
          // Giả sử Dimes chưa được setup, dùng SizedBox
          const SizedBox(height: 15), // Hoặc Dimes.height15
          // Text title gốc
          Align( // Giữ Align gốc
            alignment: Alignment.centerLeft, // Căn giữa text
            child: Text(
              playlist.title, // Sử dụng title động từ playlist
              style: const TextStyle(
                fontSize: 20, // Cỡ chữ gốc
                fontWeight: FontWeight.bold, // Độ đậm gốc
              ),
              textAlign: TextAlign.left, // Đảm bảo text căn giữa
              maxLines: 2,                 // Giới hạn 2 dòng
              overflow: TextOverflow.ellipsis, // Hiển thị ... nếu quá dài
            ),
          ),
          // Có thể thêm các Text khác ở đây nếu cần (mô tả, người tạo...)
        ],
      ),
    );
  }
}