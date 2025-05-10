import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/widgets.dart';
import '../../../widgets/playlist_cover_widget.dart';
import '../controllers/profile_controller.dart';
import '../widgets/widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  ProfileController get ctr => Get.find();

  @override
  void initState() {
    FirebaseAnalyticService.logEvent('Profile');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor:
        Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
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
      ),
      body: RefreshIndicator(
        onRefresh: ctr.getUserDetail,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Obx(
                  () => ctr.user.value == null
                  ? const Loading()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Avatar + Info + Actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileAvatar(
                        avatar: ctr.user.value?.avatar,
                      ),
                      12.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (ctr.user.value?.fullName ?? 'guest'.tr)
                                .text
                                .xl
                                .semiBold
                                .make(),
                            6.heightBox,
                          ],
                        ),
                      ),
                    ],
                  ),
                  Dimes.height10,
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ctr.goToEditProfileView();
                          FirebaseAnalyticService.logEvent(
                              'Profile_Edit_Profile_Button');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(60, 32),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text(
                          'edit'.tr,
                          style: TextStyle(
                            color: textTheme.bodyMedium?.color,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      6.widthBox,
                      IconButton(
                        icon: const Icon(Icons.file_upload_outlined),
                        onPressed: () {},
                      ),
                      4.widthBox,
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          try {
                         
                            if (ctr.user.value == null) {
                        
                              AppUtils.toast('User information not available');
                              return;
                            }
                            
                
                            if (ctr.user.value?.id == null || ctr.user.value?.id?.isEmpty == true) {
                          
                              AppUtils.toast('User ID not available');
                              return;
                            }
                            
                            // ctr.shareProfile();
                          } catch (e) {
                            AppUtils.toast('Failed to share: ${e.toString()}');
                          }
                        },
                      ),
                    ],
                  ),
                  24.heightBox,

                  // Playlist Section
                  'playlists'.tr.text.lg.bold.make(),
                  Dimes.height10,

                  // Playlist list
                  Obx(() {
                    if (ctr.isLoadingPlaylists.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (ctr.playlists.isEmpty) {
                      return Center(
                        child: Text(
                          'No playlists found',
                          style: textTheme.bodyMedium?.copyWith(
                            color: textTheme.bodySmall?.color,
                          ),
                        ),
                      );
                    }

                    // Show up to 3 playlists
                    final displayPlaylists = ctr.playlists.take(3).toList();
                    
                    return Column(
                      children: displayPlaylists.map((playlist) => GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.playlistnow, arguments: playlist);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 44,
                                height: 44,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: PlaylistCoverWidget(
                                    firstTrackId: playlist.trackIds.isNotEmpty ? playlist.trackIds.first.toString() : null,
                                  ),
                                ),
                              ),
                              Dimes.width10,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    playlist.name.text.medium.make(),
                                    Text(
                                      '${playlist.trackCount} saves',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.share),
                              //   onPressed: () => ctr.sharePlaylist(playlist),
                              // ),
                            ],
                          ),
                        ),
                      )).toList(),
                    );
                  }),

                  Dimes.height10,

                  // See all playlists button
                  Center(
                    child: ElevatedButton(
                      onPressed: () => ctr.goToPlaylistsPage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        side: BorderSide(color: colorScheme.onSurface),
                      ),
                      child: Text(
                        'see_all_playlists'.tr,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
