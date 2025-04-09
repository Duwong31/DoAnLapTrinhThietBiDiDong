// import 'dart:async';

// import 'package:get/get.dart';

// import '../../../core/mixins/load_more_mixin.dart';
// import '../../../core/utilities/utilities.dart';
// import '../../../data/models/models.dart';
// import '../../../data/providers/notification_provider.dart';

// class MessagesController extends GetxController
//     with StateMixin<List<MessageModel>>, LoadMoreState {
//   late int _pageCount;
//   int _page = 1;
//   List<MessageModel> conversations = [];
//   StreamSubscription? _subscription;
//   @override
//   void onInit() {
//     getList();
//     _subscription = NotificationProvider.onDataReceived.listen((res) {
//       // updateMessage(res['message_thread_id'], res['message'] ?? 'Hình ảnh');
//     });
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     _subscription?.cancel();
//     super.onClose();
//   }

//   Future<void> getList() async {
//     try {
//       _page = 1;
//       //final res = await Repo.chat.getConversation(_page);
//       // _pageCount = res.meta.pages;
//       // change(res.data,
//       //     status: res.data.isEmpty ? RxStatus.empty() : RxStatus.success());
//       // conversations
//       //   ..clear()
//       //   ..addAll(res.data);
//     } catch (e) {
//       AppUtils.log(e);
//     }
//   }

//   @override
//   void onLoadMore() async {
//     if (_pageCount == _page) {
//       return;
//     }
//     change(conversations, status: RxStatus.loadingMore());
//     _page++;
//     // final res = await Repo.chat.getConversation(_page);
//     // conversations.addAll(res.data);
//     change(conversations, status: RxStatus.success());
//   }
// }
