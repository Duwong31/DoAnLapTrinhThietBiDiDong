import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/widgets.dart';
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
                            (ctr.user.value?.fullName ?? 'Guest')
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
                          'Edit',
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
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          // handle more
                        },
                      ),
                    ],
                  ),
                  24.heightBox,

                  // Playlist Section
                  'Playlists'.text.lg.bold.make(),
                  Dimes.height10,

                  // Playlist demo item
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Image.asset(AppImage.testImage),
                        ),
                        Dimes.width10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'Người ta nghe gì'.text.medium.make(),
                            Text(
                              '0 saves',
                              style: textTheme.bodySmall?.copyWith(
                                color: textTheme.bodySmall?.color
                                    ?.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Dimes.height10,

                  // See all playlists button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // navigate to playlists
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        side:
                        BorderSide(color: colorScheme.onSurface),
                      ),
                      child: Text(
                        'See all playlists',
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
