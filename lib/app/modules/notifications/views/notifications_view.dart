// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';

// import '../../../core/styles/style.dart';
// import '../../../core/utilities/utilities.dart';
// import '../../../data/models/models.dart';
// import '../../../data/repositories/repositories.dart';
// import '../../../data/services/firebase_analytics_service.dart';
// import '../../../widgets/widgets.dart';
// import '../controllers/notifications_controller.dart';
// import '../widgets/notification_item.dart';

// class NotificationsView extends GetView<NotificationsController> {
//   const NotificationsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Thông báo",
//           style: GoogleFonts.notoSans(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: AppTheme.labelColor),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: controller.onRefresh,
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                     controller: controller.scrollController,
//                     itemCount: controller.groupList.length,
//                     itemBuilder: (item, indexParent) {
//                       GroupNotificationModel group =
//                           controller.groupList[indexParent];
//                       return buildNotificationItem(group);
//                     }),
//               ),
//               if(controller.isLoadingMore.value) const Center(child: CircularProgressIndicator())
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Column buildNotificationItem(GroupNotificationModel group) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(Dimes.size16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 group.groupName,
//                 style: GoogleFonts.notoSans(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppTheme.labelColor),
//               ),
//               Builder(builder: (context) {
//                 int countUnreadNotification = group.notificationList
//                     .where((item) => item.isRead == false)
//                     .length;
//                 if (countUnreadNotification == 0) {
//                   return Container();
//                 }
//                 return Text(
//                   "${group.notificationList.where((item) => item.isRead == false).length} tin chưa đọc",
//                   style: GoogleFonts.notoSans(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: AppTheme.labelColor),
//                 );
//               }),
//             ],
//           ),
//         ),
//         ListView.builder(
//             shrinkWrap: true,
//             primary: false,
//             itemCount: group.notificationList.length,
//             itemBuilder: (context, indexChild) {
//               NotificationModel notification =
//                   group.notificationList[indexChild];
//               return Column(
//                 children: [
//                   InkWell(
//                     onTap: (){
//                       controller.onRead(notification);
//                     },
//                     child: Container(
//                         color: notification.isRead
//                             ? Colors.white
//                             : const Color(0xFF004AAD).withValues(alpha: .2),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: Dimes.size16, vertical: Dimes.size10),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(Dimes.size44),
//                                 child: Builder(builder: (context) {
//                                   String icon = "";
//                                   switch(notification.event){
//                                     case EventType.bookingCreatedEvent:
//                                       icon = "assets/svg/dat_xe_thanh_cong.svg";
//                                       break;
//                                     case EventType.bookingUpdatedEvent:
//                                       icon = "assets/svg/cap_nhat_xe_da_dat.svg";
//                                       break;
//                                     case EventType.bookingCancelledEvent:
//                                       icon = "assets/svg/thong_bao_huy_bo.svg";
//                                       break;
//                                     case EventType.bookingPickupTimeEvent:
//                                       icon = "assets/svg/thoi_gian_don_tra.svg";
//                                       break;
//                                     case EventType.bookingReturnLateEvent:
//                                       icon = "assets/svg/canh_bao_tra_tre.svg";
//                                       break;
//                                     case EventType.bookingInvoiceEvent:
//                                       icon = "assets/svg/hoa_don_chuyen_di.svg";
//                                       break;
//                                     case EventType.createReviewEvent:
//                                       icon = "assets/svg/thong_bao_nhan_xet.svg";
//                                       break;
//                                     case EventType.paymentSuccessEvent:
//                                       icon = "assets/svg/thong_bao_thanh_toan.svg";
//                                       break;
//                                     case null:
//                                       icon = "";
//                                       break;
//                                   }
//                                   if(icon.isEmpty){
//                                     return Container(
//                                       height: Dimes.size44,
//                                       width: Dimes.size44,
//                                       decoration: const BoxDecoration(
//                                           color: AppTheme.divideColor),
//                                     );
//                                   }else{
//                                     return SvgPicture.asset(icon,
//                                       height: Dimes.size44,
//                                       width: Dimes.size44,);
//                                   }
//                                   // return Image.network(
//                                   //   notification.avatar,
//                                   //   height: Dimes.size44,
//                                   //   width: Dimes.size44,
//                                   //   errorBuilder: (_, __, ___) {
//                                   //     return Container(
//                                   //       height: Dimes.size44,
//                                   //       width: Dimes.size44,
//                                   //       decoration: const BoxDecoration(
//                                   //           color: AppTheme.divideColor),
//                                   //     );
//                                   //   },
//                                   // );
//                                 })),
//                             Dimes.width4,
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           notification.title,
//                                           style: GoogleFonts.notoSans(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500,
//                                               color: AppTheme.primary),
//                                         ),
//                                       ),
//                                       Dimes.width4,
//                                       Builder(builder: (context) {
//                                         final currentDate = DateTime.now();
//                                         final today = DateTime(currentDate.year,
//                                             currentDate.month, currentDate.day);
//                                         final notificationDate = DateTime(
//                                             notification.createdAt.year,
//                                             notification.createdAt.month,
//                                             notification.createdAt.day);

//                                         String time = "";
//                                         if (notificationDate
//                                             .isAtSameMomentAs(today)) {
//                                           time = DateFormat("hh:mm aa")
//                                               .format(notification.createdAt)
//                                               .lowerCamelCase;
//                                         } else {
//                                           time = notification.createdAt
//                                               .timeAgoSinceDate();
//                                         }
//                                         return Text(
//                                           time,
//                                           style: GoogleFonts.notoSans(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w400,
//                                               color: const Color(0xFF7F7F7F)),
//                                         );
//                                       }),
//                                       Builder(builder: (context) {
//                                         if (notification.isRead) {
//                                           return Container();
//                                         }
//                                         return Container(
//                                           margin: const EdgeInsets.only(left: Dimes.size4),
//                                           height: Dimes.size10,
//                                           width: Dimes.size10,
//                                           decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: AppTheme.primary),
//                                         );
//                                       })
//                                     ],
//                                   ),
//                                   Text(notification.message,style: GoogleFonts.notoSans(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                   ),maxLines: 2,)
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )),
//                   ),
//                   Dimes.height18
//                 ],
//               );
//             })
//       ],
//     );
//   }

// /// Builds the empty notification view
// Widget _buildEmptyView(BuildContext context) {
//   return Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.notifications,
//             size: MediaQuery.of(context).size.height * 0.2,
//             color: Colors.grey),
//         const SizedBox(height: 10),
//         const Text(
//           'Pharmacy notifications will appear here.',
//           style: TextStyle(color: Colors.grey, fontSize: 16),
//         ),
//       ],
//     ),
//   );
// }
//
// /// Builds the app bar with unread notifications count
// Widget _buildAppBar(int totalUnread) {
//   return SliverAppBar(
//     pinned: true,
//     leading: IconButton(
//       icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
//       onPressed: controller.goBack,
//     ),
//     title: const Text(
//       'Thông báo',
//       style: TextStyle(
//           color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
//     ),
//     centerTitle: true,
//   );
// }
//
// /// Updated `_buildSectionHeader` to include unread count (when available)
// Widget _buildSectionHeader(String title, int? unreadCount) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         if (unreadCount != null && unreadCount > 0)
//           Text(
//             '$unreadCount tin chưa đọc',
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//       ],
//     ),
//   );
// }
//
// /// Builds the list of notifications
// List<Widget> _buildNotificationList(List<NotificationModel> notifications) {
//   if (notifications.isEmpty) {
//     return [const Center(child: Text('No notifications to show.'))];
//   }
//
//   return notifications
//       .map(
//         (item) => NotificationItem(
//           item: item,
//           onTap: () => controller.markReadAndOpen(item.id),
//         ),
//       )
//       .toList();
// }
// }
