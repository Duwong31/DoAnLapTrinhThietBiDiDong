import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/mixins/load_more_mixin.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class NotificationsController extends GetxController
    with
        StateMixin<List<NotificationModel>>,
        GetTickerProviderStateMixin,
        LoadMoreState {
  final notifications = <NotificationModel>[];
  final duration = const Duration(seconds: 3);
  final int limit = 20;

  late AnimationController toastCtr;
  late int _pageCount;

  int _page = 1;
  int removeIndex = 0;
  Timer? _timer;
  NotificationModel? removeItem;

  @override
  void onInit() {
    toastCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  @override
  void onReady() {
    getList();
    super.onReady();
  }

  Future<void> onRefresh() async {
    await getList();
    await Get.find<DashboardController>().getNumberNotify();
  }

  Future<void> getList() async {
    try {
      _page = 1;
      final query = {'page': _page, 'limit': limit};
      final res = await Repo.notify.getList(query: query);
      _pageCount = res.meta.pages;
      notifications
        ..clear()
        ..addAll(res.data as List<NotificationModel>);
      change(
        notifications,
        status: notifications.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (e) {
      change(state, status: RxStatus.error(e.toString()));
      AppUtils.log(e);
    }
  }

  void remove(id) {
    BottomWellSuccess.show(
      'Do you want to delete it?',
      image: AppImage.confirmDelete,
      enableDrag: true,
      callback: () {
        removeIndex = notifications.indexWhere((e) => e.id == id);
        removeItem = notifications[removeIndex];
        notifications.remove(removeItem);
        toastCtr.forward();
        change(notifications, status: RxStatus.success());
        _timer?.cancel();
        _timer = Timer.periodic(duration, (_) {
          _timer?.cancel();
          _delete(removeItem);
        });
      },
    );
  }

  void changNumberUnreadBottom() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().readNotify();
    }
  }

  void markRead(String id) {
    for (var e in notifications) {
      if (e.id == id) {
        e.isRead = true;
      }
    }
    changNumberUnreadBottom();
    change(notifications, status: RxStatus.success());
  }

  void undo() {
    _timer?.cancel();
    toastCtr.reverse();
    if (removeItem != null) {
      notifications.insert(removeIndex, removeItem!);
      change(notifications, status: RxStatus.success());
    }
    removeItem = null;
  }

  void _delete(NotificationModel? item) async {
    if (item != null) {
      await Repo.notify.deleteNotify(item.id);
      if (!item.isRead) {
        changNumberUnreadBottom();
      }
    }
  }

  @override
  Future<void> onLoadMore() async {
    if (_pageCount == _page) {
      return;
    }
    change(notifications, status: RxStatus.loadingMore());
    _page++;
    final query = {'page': _page, 'limit': limit};
    final res = await Repo.notify.getList(query: query);
    final data = [...state!, ...res.data as List<NotificationModel>];
    notifications
      ..clear()
      ..addAll(data);
    change(notifications, status: RxStatus.success());
  }
}
