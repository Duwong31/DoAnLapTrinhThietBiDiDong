import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../data/services/firebase_analytics_service.dart';

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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ctr.getUserDetail,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: Obx(
                  () => ctr.user.value == null
                  ? const Loading()
                  : Wrap(
                runSpacing: 10,
                children: [
                  BoxContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileAvatar(avatar: ctr.user.value?.avatar)
                            .centered(),
                        ListTitleCustom(
                          title: 'Full Name',
                          content: ctr.user.value?.fullName,
                        ),
                        ListTitleCustom(
                          title: 'Gender',
                          content: ctr.user.value?.gender,
                        ),
                        ListTitleCustom(
                          title: 'Date of Birth',
                          content: ctr.user.value?.birthDay,
                        ),
                        ListTitleCustom(
                          title: 'Phone Number',
                          content: ctr.user.value?.phone,
                        ),
                        ListTitleCustom(
                          title: 'Email',
                          content: ctr.user.value?.email,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            'Emergency Contact Info'
                                .text
                                .size(16)
                                .maxFontSize(14)
                                .medium
                                .maxLines(1)
                                .color(AppTheme.secondary)
                                .make()
                                .pSymmetric(v: 10)
                                .expand(),
                          ],
                        ),
                        Dimes.height10,
                        AppButton(
                          'EDIT PROFILE',
                          onPressed: () {
                            EditProfileBottom.showBottom();
                            FirebaseAnalyticService.logEvent(
                                'Profile_Edit_Profile_Button');
                          },
                        )
                      ],
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