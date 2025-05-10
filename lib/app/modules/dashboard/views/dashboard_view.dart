import 'package:flutter/material.dart';
import 'package:flutter_badged/badge_position.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:get/get.dart';

import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/widgets.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../library/views/library_view.dart';
import '../../premium/views/premium_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = Get.find<DashboardController>();
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>();
  late List<Song> _songs;

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
      ),
      drawer: DrawerView(drawerKey: controller.drawerKey),
      body: Stack(
        children: [
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: const [
              HomeView(),
              SearchView(),
              LibraryView(),
              PremiumView(),
            ],
          ),
          Obx(() {
            // Cập nhật _songs một cách phản ứng khi HomeController.songs thay đổi
            _songs = homeController.songs.toList();
            return StreamBuilder<Song?>(
              stream: _audioService.currentSongStream,
              builder: (context, snapshot) {
                // Cơ chế dự phòng: Nếu StreamBuilder không có dữ liệu, kiểm tra trực tiếp AudioService.currentSong
                Song? currentSong = snapshot.hasData && snapshot.data != null
                    ? snapshot.data
                    : _audioService.currentSong;

                if (currentSong == null) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Dismissible(
                    key: Key('miniplayer_${currentSong.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      try {
                        await _audioService.stop();
                        _audioService.clearCurrentSong();
                      } catch (e) {
                        debugPrint('SearchView: Lỗi khi dừng âm thanh: $e');
                      }
                    },
                    child: MiniPlayer(
                      song: currentSong,
                      songs: _songs, // Sử dụng danh sách _songs đã cập nhật
                      onTap: () async {
                        final returnedSong = await Get.toNamed(
                          Routes.songs_view,
                          arguments: {'playingSong': currentSong, 'songs': _songs},
                        );
                        if (returnedSong != null) {
                          _audioService.currentSong = returnedSong;
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }),
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