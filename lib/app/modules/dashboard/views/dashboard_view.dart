import 'package:flutter_badged/badge_position.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../widgets/widgets.dart';
import '../../home/views/home_view.dart';
import '../../library/views/library_view.dart';
import '../../premium/views/premium_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  // ignore: use_super_parameters
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: controller.drawerKey,
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const UserAvatar(),
          onPressed: () {
            controller.drawerKey.currentState?.openDrawer();
            FirebaseAnalyticService.logEvent('BTN_Show_Left_Menu');
          },
        ),
        actions: [
          Obx(() {
            if (controller.currentIndex.value == 2) {
              return IconButton(
                icon: const Icon(Icons.add, size: 32, color: AppTheme.primary),
                onPressed: () {
                  controller.showCreatePlaylistDialog();
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ],
        // title: Obx(() {
        //   return Text(
        //     controller.currentIndex.value == 0
        //         ? 'Welcome, ${controller.profile.user.value?.fullName ?? ''}!'
        //         : controller.titleAppBar,
        //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
        //       color: Theme.of(context).textTheme.titleLarge?.color,
        //     ),
        //   );
        // }),
      ),
      drawer: DrawerView(drawerKey: controller.drawerKey),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: const [
          HomeView(),
          SearchView(),
          LibraryView(),
          // MessagesView(),
          // NotificationsView(),
          PremiumView(),
        ],
      ),
      bottomNavigationBar: const _BottomNavigator(),
    );
  }
}

class _BottomNavigator extends StatelessWidget {
  const _BottomNavigator();
  DashboardController get to => Get.find();
  @override
  Widget build(BuildContext context) {
    return to.obx(
          (state) => Obx(
            () => Material(
          elevation: 4,
          child: Container(
            padding: EdgeInsets.only(bottom: context.padding.bottom),
            height: kBottomNavigationBarHeight + context.padding.bottom,
            child: Row(
              children: state!
                  .asMap()
                  .map(
                    (index, e) => MapEntry(
                  index,
                  _BottomBarItem(
                    currentIndex: to.currentIndex.value,
                    index: index,
                    item: e,
                    onTap: to.changeTab,
                  ),
                ),
              )
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.currentIndex,
    required this.index,
    required this.item,
    required this.onTap,
  });
  final Function(int) onTap;
  final int currentIndex, index;
  final BottomBarModel item;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterBadge(
              itemCount: item.notify,
              badgeColor: Colors.redAccent,
              position: const BadgePosition(top: 1, right: -10),
              borderRadius: 20.0,
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              textSize: 8,
              icon: item.iconData != null
                  ? Icon(
                Icons.store_outlined,
                color: index == currentIndex
                    ? AppTheme.primary
                    : AppTheme.deactivate,
              )
                  : Image.asset(
                item.image,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                color: index == currentIndex
                    ? AppTheme.primary
                    : AppTheme.deactivate,
              ),
            ),
            item.title.text
                .size(12)
                .color(
              index == currentIndex
                  ? AppTheme.primary
                  : AppTheme.deactivate,
            )
                .make(),
          ],
        ),
      ),
    );
  }
}
