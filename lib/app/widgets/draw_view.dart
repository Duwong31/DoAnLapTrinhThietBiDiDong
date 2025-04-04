import 'package:get/get.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';
import '../data/repositories/repositories.dart';
import '../data/services/firebase_analytics_service.dart';

import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../routes/app_pages.dart';
import 'custom_switch.dart';
import 'user_avatar.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key, required this.drawerKey});
  final GlobalKey<ScaffoldState> drawerKey;
  DashboardController get ctr => Get.find();
  ProfileController get profileCtr => Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: context.padding.top),
            child: Column(
              children: [
                const SizedBox(
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                    child: UserAvatar(width: 76),
                  ),
                ),
                Dimes.height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Flexible(
                        child: (profileCtr.user.value?.fullName ?? 'Unknown')
                            .text
                            .ellipsis
                            .maxLines(1)
                            .size(16)
                            .medium
                            .color(AppTheme.primary)
                            .make(),
                      ),
                    ),
                    Dimes.width5,
                    Image.asset(
                      AppImage.edit,
                      color: AppTheme.secondary,
                      height: 15,
                    ).onInkTap(() {
                      drawerKey.currentState!.openEndDrawer();
                      Get.toNamed(Routes.profile);
                    })
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 30),

          ListTile(
            minLeadingWidth: 0,
            title: 'Notifications'.text.size(16).make(),
            leading: 'alert'.icon,
            trailing: Obx(
              () => CustomSwitch(
                value: profileCtr.user.value?.isEnableNotification ?? false,
                onChanged: (isOn) {
                  profileCtr.toggleNotify(isOn);
                  FirebaseAnalyticService.logEvent(
                      'Left_Menu_Notification_Switch',
                      params: {'Notification_Switch': isOn ? 'On' : 'Off'});
                },
              ),
            ),
          ),
          /*
          ListTile(
            minLeadingWidth: 0,
            title: 'Shop Order History'.text.size(16).make(),
            leading: SizedBox(
              child: 'history'.icon,
              width: 20,
            ),
            onTap: () {
              // drawerKey.currentState!.openEndDrawer();
              // if (cart.currentCustomerAccessToken == null) {
              //   LoginShopBottom.show(
              //     success: () async {
              //       await cart.getCurrentCustomerAccessToken();
              //       Get.to(() => const CartOrderHistory());
              //     },
              //   );
              // } else {
              //   Get.to(() => const CartOrderHistory());
              // }
              Get.to(() => const CartOrderHistoryView(),
                  binding: CartOrderHistoryBinding());
              FirebaseAnalyticService.logEvent(
                'Left_Menu_Shop_Order_History',
              );
            },
          ),
          */
          ListTile(
            minLeadingWidth: 0,
            title: 'Profile'.text.size(16).make(),
            leading: const Icon(Icons.person_outline, color: Colors.black),
            onTap: () {
              drawerKey.currentState!.openEndDrawer();
              Get.toNamed(Routes.profile);
              FirebaseAnalyticService.logEvent(
                'Left_Menu_Profile',
              );
            },
          ),

          // ListTile(
          //   minLeadingWidth: 0,
          //   title: 'Privacy Policy'.text.size(16).make(),
          //   leading: 'privacy'.icon,
          //   onTap: () {
          //     drawerKey.currentState!.openEndDrawer();
          //     WebViewPicker.show(ApiUrl.policy, title: 'PRIVACY POLICY');
          //   },
          // ),
          ListTile(
            minLeadingWidth: 0,
            title: 'Log  Out'.text.color(Colors.red).size(16).make(),
            leading: Image.asset(AppImage.logout, width: 24, color: Colors.red),
            onTap: () {
              drawerKey.currentState!.openEndDrawer();
              Repo.auth.logout();
              FirebaseAnalyticService.logEvent(
                'Left_Menu_Log_Out',
              );
            },
          ),
          const Spacer(),
        ],
      ),
    ));
  }
}

extension StringIconExt on String {
  Widget get icon => Image.asset(
        'assets/drawer/$this.png',
        color: AppTheme.labelColor,
        width: 24,
        height: 24,
      );
}
