import 'package:get/get_navigation/src/root/internacionalization.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // English
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

      // library
      'favorite_songs': 'Favorite songs',
      'playlists': 'Playlists',
      'following': 'Following',
      'stations': 'Stations',
      'uploads': 'Uploads',
      'my_playlist': 'My Playlist',
      'see_all': 'See All',
      'best_song_of_jack': 'Best song of Jack - J97',
      'your_uploads': 'Your Uploads',

      'no_liked_song': 'No liked songs',

      // premium
      'elevate_music': 'Elevate Your Music Experience',
      'why_premium': 'Why Premium?',
      'ad_free': 'Ad-Free Listening',
      'offline_playback': 'Download & Offline Playback',
      'high_quality': 'Highest Audio Quality',
      'unlimited_skips': 'Unlimited Skips',
      'get_premium_now': 'GET PREMIUM NOW',
      'restore': 'Restore',
      'terms': 'Terms',
      'privacy': 'Privacy',

      // draw
      'guest': "Guest",
      'notifications': 'Notifications',
      'profile': 'Profile',
      'setting': 'Setting',
      'log_out': 'Log out',

      // profile & edit profile
      'edit': 'Edit',
      'see_all_playlists': 'See all playlist',
      'edit_profile': 'Edit Profile',
      'save': 'Save',
      'change_photo': 'Change photo',
      'name': 'Name',

      // setting
      'themes': 'Themes',
      'audio_quality': 'Audio Quality',
      'video_quality': 'Video Quality',
      'apps_and_devices': 'Apps and Devices',
      'languages': 'Languages',
      'about': 'About',
      'switch_to_light_mode': 'Switch to Light Mode',
      'switch_to_dark_mode': 'Switch to Dark Mode',
      'select_language': 'Select language',
      'english': 'English',
      'vietnamese': 'Vietnamese',

      // login
      'log_in_to_soundFlow': 'Log in to SoundFlow',
      'password': 'Password',
      'forgot_password?': 'Forgot Password?',
      'login': 'Login',
      'form_validation_failed': 'Form validation failed',
      'or': 'or',
      "don't_have_an_account?": "Don't have an account?",
      'sign_up': 'Sign up',
      'continue_with_phone': 'Continue with phone',
      'continue_with_google': 'Continue with Google',

      // forgot password
      'forgot_your_password?': 'Forgot Your Password?',
      'enter_your_email_or_phone_number_below_to_receive_your_password_reset_instructions.': 'Enter your email or phone number below to receive your password reset instructions.',
      'enter_email_or_phone_number': 'Enter Email or Phone Number',
      'send_code': 'Send Code',

      // register
      'sign_up_to_soundflow': 'Sign up to SoundFlow',
      'user_name': 'UserName',
      'confirm_password': 'Confirm Password',
      'already_have_an_account?': 'Already have an account?',
      'processing...': 'processing...',

      // otp
      'enter_verification_code': 'Enter Verification Code',
      'enter_code': 'Enter Code',
      'verify': 'Verify',
      'resend': 'Resend',
    },

    // Tiếng Việt
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

      // library
      'playlists': 'Danh sách phát',
      'following': 'Đang theo dõi',
      'stations': 'Đài phát',
      'uploads': 'Tải lên',
      'my_playlist': 'Danh sách phát của tôi',
      'see_all': 'Tất cả',
      'best_song_of_jack': 'Những bài hát hay nhất của Jack - J97',
      'your_uploads': 'Tải lên của bạn',

      'no_liked_song': 'Không có bài hát nào được thích',

      // premium
      'elevate_music': 'Nâng tầm trải nghiệm âm nhạc',
      'why_premium': 'Tại sao chọn Cao cấp?',
      'ad_free': 'Nghe nhạc không quảng cáo',
      'offline_playback': 'Tải xuống & Nghe ngoại tuyến',
      'high_quality': 'Chất lượng âm thanh cao nhất',
      'unlimited_skips': 'Bỏ qua không giới hạn',
      'get_premium_now': 'NÂNG CẤP NGAY',
      'restore': 'Khôi phục',
      'terms': 'Điều khoản',
      'privacy': 'Bảo mật',

      // draw
      'guest': 'Khách',
      'notifications': 'Thông báo',
      'profile': 'Hồ sơ',
      'setting': 'Cài đặt',
      'log_out': 'Đăng xuất',

      // profile & edit profile
      'edit': 'Chỉnh sửa',
      'see_all_playlists': 'Xem tất cả danh sách phát',
      'edit_profile': 'Chỉnh sửa Hồ sơ',
      'save': 'Lưu',
      'change_photo': 'Chọn ảnh',
      'name': 'Tên',

      // setting
      'themes': 'Chủ đề',
      'audio_quality': 'Chất lượng âm thanh',
      'video_quality': 'Chất lượng video',
      'apps_and_devices': 'Ứng dụng và thiết bị',
      'languages': 'Ngôn ngữ',
      'about': 'Khác',
      'switch_to_light_mode': 'Chuyển sang chế độ sáng',
      'switch_to_dark_mode': 'Chuyển sang chế độ tối',
      'select_language': 'Chọn ngôn ngữ',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',

      // login
      'log_in_to_soundFlow': 'Đăng nhập vào SoundFlow',
      'password': 'Mật khẩu',
      'forgot_password?': 'Quên mật khẩu?',
      'login': 'Đăng nhập',
      'form_validation_failed': 'Xác thực biểu mẫu thất bại',
      'or': 'hoặc',
      "don't_have_an_account?": "Chưa có tài khoản?",
      'sign_up': 'Đăng ký',
      'continue_with_phone': 'Tiếp tục với điện thoại',
      'continue_with_google': 'Tiếp tục với Google',

      // forgot password
      'forgot_your_password?': 'Quên mật khẩu?',
      'enter_your_email_or_phone_number_below_to_receive_your_password_reset_instructions.': 'Nhập email hoặc số điện thoại của bạn bên dưới để nhận hướng dẫn đặt lại mật khẩu.',
      'enter_email_or_phone_number': 'Nhập email hoặc số điện thoại',
      'send_code': 'Gửi mã',

      // register
      'sign_up_to_soundflow': 'Đăng ký vào SoundFlow',
      'user_name': 'Tên người dùng',
      'confirm_password': 'Xác nhận mật khẩu',
      'already_have_an_account?': 'Đã có tài khoản?',
      'processing...': 'Đang xử lý...',

      // otp
      'enter_verification_code': 'Nhập mã xác minh',
      'enter_code': 'Nhập mã',
      'verify': 'Xác minh',
      'resend': 'Gửi lại',

    },
  };
}
