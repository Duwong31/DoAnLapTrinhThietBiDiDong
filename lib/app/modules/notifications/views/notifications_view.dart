import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../widgets/widgets.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_item.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with AutomaticKeepAliveClientMixin {
  NotificationsController get ctr => Get.find();
  @override
  void initState() {
    FirebaseAnalyticService.logEvent('Notifications');
    Get.lazyPut(() => NotificationsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ctr.onRefresh,
        child: Stack(
          children: [
            ctr.obx(
              (state) => SlidableAutoCloseBehavior(
                child: ListView.separated(
                  controller: ctr.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: state!.length + 1,
                  separatorBuilder: (_, int index) {
                    return const Divider(height: 1);
                  },
                  itemBuilder: (_, int index) {
                    if (index == state.length) {
                      return ctr.status.isLoadingMore
                          ? const Loading()
                          : Dimes.empty;
                    }
                    final item = state[index];
                    return NotificationItem(
                      item: state[index],
                      onTap: () {
                        switch (item.targetType) {
                          default:
                        }
                        if (!item.isRead) {
                          _unRead(item.id);
                        }
                      },
                    );
                  },
                ),
              ),
              onError: (e) => Center(child: '$e'.text.make()),
              onLoading: const AppLoadingListContent(10),
              onEmpty: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: context.screenHeight * 0.2,
                      color: Colors.grey,
                    ),
                    'Pharmacy notifications will appear here.'
                        .text
                        .gray400
                        .size(16)
                        .make(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _unRead(String id) {
    Repo.notify.markRead(id).then((value) {
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().markRead(id);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({super.key, required this.id});
  final String id;
  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  NotificationModel? item;
  bool isLoading = true;
  @override
  void initState() {
    Repo.notify.detailNotify(widget.id).then((res) {
      setState(() {
        isLoading = false;
        item = res;
        if (!res.isRead) {
          unRead();
        }
      });
    });
    super.initState();
  }

  void unRead() {
    Repo.notify.markRead(widget.id).then((value) {
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().markRead(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: item?.title ?? '',
      body: isLoading
          ? const Loading()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              child: item == null
                  ? Dimes.empty
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              (item?.promote ?? false)
                                  ? AppImage.promo
                                  : AppImage.remind,
                              width: 28,
                              height: 28,
                            ),
                            Dimes.width10,
                            (item?.promote ?? false
                                    ? 'Promotion'
                                    : 'Order Remind')
                                .text
                                .size(16)
                                .color(AppTheme.primary)
                                .medium
                                .make(),
                            const Spacer(),
                            (item?.date ?? '').text.medium.make(),
                          ],
                        ),
                        const Divider(height: 30),
                        (item?.description ?? '').text.justify.make(),
                      ],
                    ),
            ),
    );
  }
}
