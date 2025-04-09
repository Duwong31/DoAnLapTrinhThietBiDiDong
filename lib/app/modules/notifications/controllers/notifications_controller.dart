import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';



class NotificationsController extends GetxController {
  var groupList = <GroupNotificationModel>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoading = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        onLoadMore();
      }
    });
    groupList.add(GroupNotificationModel("Hôm nay", []));
    groupList.add(GroupNotificationModel("Trước đó", []));
    isLoading.value = true;
    _loadData();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadData() async {
    try {
      final response = await Repo.notify.getList(query: {
        "page":currentPage.value
      });
      final currentDate = DateTime.now();
      final today = DateTime(currentDate.year,currentDate.month,currentDate.day);
      for (var item in response) {
        final notificationDate = DateTime(item.createdAt.year,item.createdAt.month,item.createdAt.day);
        if(notificationDate.isAtSameMomentAs(today)){
          groupList[0].notificationList.add(item);
        }else{
          groupList[1].notificationList.add(item);
        }
      }
      if(response.isNotEmpty){
        currentPage.value++;
      }
    } catch (e) {
      log('Error loading notification: $e');
    } finally {
      isLoadingMore.value = false;
      isLoading.value = false;
    }
  }



  Future<void> onRefresh() async {
    for (var item in groupList) {
      item.notificationList.clear();
    }
    currentPage.value = 1;
    isLoading.value = true;
    await _loadData();
  }

  void onLoadMore() {
    isLoadingMore.value = true;
    _loadData();
  }

  void onRead(NotificationModel notification) {
    notification.isRead = true;
    Repo.notify.markRead(notification.id);
    groupList.refresh();
    if(notification.carId!= null){
      Get.toNamed(Routes.carDetail, arguments: {
        'carId': notification.carId.toString(),
      });
    }
  }

  
}
 
