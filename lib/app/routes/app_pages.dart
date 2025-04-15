import 'package:get/get.dart';
import '../modules/ songs/bindings/songs_binding.dart';
import '../modules/ songs/view/all_songs_view.dart';
import '../modules/ songs/view/songs_view.dart';
import '../modules/albums & playlist/bindings/album_page_binding.dart';
import '../modules/albums & playlist/bindings/playlist_page_binding.dart';
import '../modules/albums & playlist/views/album_page_view.dart';
import '../modules/albums & playlist/views/playlist_page_view.dart';
import '../modules/change-password/bindings/change_password_binding.dart';
import '../modules/change-password/views/change_password_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/forgot-password/bindings/forgot_password_binding.dart';
import '../modules/forgot-password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/library/bindings/library_binding.dart';
import '../modules/library/views/library_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/edit_profile_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile.dart';
import '../modules/register/bindings/otp_binding.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/otp_view.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../widgets/success_splash.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.changePassword,
    //   page: () => const ChangePasswordView(),
    //   binding: ChangePasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.detailNotify,
    //   page: () => NotificationDetail(id: Get.parameters['id'] as String),
    // ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: _Paths.search,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.outstanding,
      page: () => const LibraryView(),
      binding: LibraryBinding(),
    ),
    GetPage(
        name: _Paths.forgotPassword,
        page: () => const ForgotPasswordView(),
        binding: ForgotPasswordBinding()),
    GetPage(
        name: _Paths.otpLogin,
        page: () => const OtpLoginView(),
        binding: OtpLoginBinding()),
    GetPage(
        name: _Paths.resetPassword,
        page: () => const ResetPasswordView(),
        binding: ResetPasswordBinding()),
    GetPage(
        name: _Paths.successSplash,
        page: () => const LottieSplashView(
            animationPath: 'assets/animations/success.json',
            duration: Duration(milliseconds: 1300),
            nextRoute: Routes.resetPassword)),
    GetPage(
        name: _Paths.setting,
        page: () => const SettingView(),
        binding: SettingBinding()),
    GetPage(
        name: _Paths.album,
        page: () => const AlbumView(),
        binding: AlbumBinding()),
    GetPage(
        name: _Paths.albumnow,
        page: () => AlbumNow(),
        binding: AlbumBinding()),
    GetPage(
        name: _Paths.playlist,
        page: () => const PlayListView(),
        binding: PlayListBinding()),
    GetPage(
        name: _Paths.playlistnow,
        page: () => const PlayListNow(),
        binding: PlayListBinding()),
    GetPage(
        name: _Paths.all_song_view,
        page: () => const AllSongsView(),
        ),
    GetPage(
        name: _Paths.songs_view,
        page: () => NowPlaying.fromRoute(),
        binding: NowPlayingBinding()),
    GetPage(
      name: _Paths.editProfile,
      page: () => EditProfilePage(),
      binding: EditProfileBinding()) 
  ];
}
