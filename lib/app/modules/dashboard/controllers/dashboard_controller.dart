import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/http_client/http_client.dart';
import '../../../data/providers/notification_provider.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../profile/controllers/profile_controller.dart';

class BottomBarModel {
  final String image, title, appBarTitle;
  int notify;
  IconData? iconData;
  BottomBarModel(this.image, this.title, this.notify,
      {this.iconData, this.appBarTitle = ''});
}

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin, StateMixin<List<BottomBarModel>> {
  final drawerKey = GlobalKey<ScaffoldState>();

  ProfileController get profile => Get.find();
  StreamSubscription? _sub;
  late TabController tabController;

  late List<BottomBarModel> items;

  String get titleAppBar => items[currentIndex.value].appBarTitle.isNotEmpty
      ? items[currentIndex.value].appBarTitle.toUpperCase()
      : items[currentIndex.value].title.toUpperCase();
  final currentIndex = 0.obs;
  final isNotify = false.obs;
  final numberUnread = 0.obs;
  final messageUnread = 0.obs;

  @override
  void onInit() {
    items = [
      BottomBarModel(AppImage.home, 'Home', 0),
      BottomBarModel(AppImage.search, 'Search', 0),
      BottomBarModel(AppImage.library, 'Library', 0),
      BottomBarModel(AppImage.user, 'Personal', 0),
    ];

    change(items, status: RxStatus.success());
    ever(numberUnread, (int val) {
      final index = items.indexWhere((e) => e.title == 'Notifications');
      if (index != -1) {
        items[index].notify = val;
        change(items, status: RxStatus.success());
      }
    });
    ever(messageUnread, (int val) {
      final index = items.indexWhere((e) => e.title == 'Messages');
      if (index != -1) {
        items[index].notify = val;
        change(items, status: RxStatus.success());
      }
    });
    tabController = TabController(length: items.length, vsync: this);
    _initialize();
    super.onInit();
  }

  void _initialize() {
    FirebaseMessaging.instance.getToken().then((value) {
      AppUtils.log(value, tag: 'FirebaseMessaging');
    });
  }

  @override
  void onReady() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        navigatorPage(message.data);
      }
    });
    getNumberNotify();

    super.onReady();
  }

  Future<void> getNumberNotify() async {
    try {
      final res = await ApiClient.connect(ApiUrl.numberUnread);
      numberUnread.value = res.data['data']['unread_notifications'] ?? 0;
      messageUnread.value = res.data['data']['unread_messages'] ?? 0;
    } catch (e) {
      AppUtils.log(e);
    }
  }

  void changeTab(int index, {int? orderTab, int? shopOtcTab}) {
    tabController.animateTo(index);
    currentIndex.value = index;
    switch (index) {
      case 0:
        FirebaseAnalyticService.logEvent('FooterMenu_Home');
        break;
      case 1:
        FirebaseAnalyticService.logEvent('FooterMenu_Search');
        break;
      case 2:
        FirebaseAnalyticService.logEvent('FooterMenu_Library');
        break;
      case 3:
        FirebaseAnalyticService.logEvent('FooterMenu_Profile');
        break;
      default:
    }
    if (orderTab != null) {}
  }

  void readNotify() {
    numberUnread.value = numberUnread.value - 1;
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
