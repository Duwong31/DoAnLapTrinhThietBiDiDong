import 'package:get/get_navigation/src/root/internacionalization.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // home
      'we_think_you_like': "We think you'll like",
      'music_genre': "Music genre",
      'artists': "Artists",
      'you_might_want_to_hear': "You might want to hear",
      'chill': "Chill",
      'more': "More",
      // search
      'search_hint': "Search for songs, artists...",
      'recent_searches': "Recent searches",
      'clear_all': "Clear all",
      'no_recent_searches': "No recent searches",
      'enter_keyword_to_show_suggestions': "Enter keyword to show suggestions",
    },
    'vi_VN': {
      // home
      'we_think_you_like': "Chúng tôi nghĩ bạn sẽ thích",
      'music_genre': "Thể loại nhạc",
      'artists': "Nghệ sĩ",
      'you_might_want_to_hear': "Bạn có thể muốn nghe",
      'chill': "Thư giãn",
      'more': "Thêm",
      // search
      'search_hint': "Tìm kiếm bài hát, nghệ sĩ...",
      'recent_searches': "Tìm kiếm gần đây",
      'clear_all': "Xóa tất cả",
      'no_recent_searches': "Không có tìm kiếm gần đây",
      'enter_keyword_to_show_suggestions': "Nhập từ khóa để hiển thị gọi ý",
    },
  };
}
