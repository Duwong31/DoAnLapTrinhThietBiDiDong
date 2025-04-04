import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/models/models.dart';
import '../controllers/notifications_controller.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.item, this.onTap});
  final NotificationModel item;
  final VoidCallback? onTap;
  NotificationsController get ctr => Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Slidable(
          groupTag: 'onlyOpen',
          key: ValueKey(item.id),
          closeOnScroll: true,
          // startActionPane: ActionPane(
          //   extentRatio: .4,
          //   motion: const ScrollMotion(),
          //   children: [
          //     SlideDelete(
          //       text: 'Archive',
          //       image: AppImage.archive,
          //       bg: AppTheme.secondary,
          //       onSlideTap: () {},
          //     ),
          //   ],
          // ),
          endActionPane: ActionPane(
            extentRatio: .35,
            motion: const ScrollMotion(),
            children: [
              SlideDelete(
                text: 'Delete',
                image: AppImage.delete,
                bg: context.error,
                right: true,
                onSlideTap: () => ctr.remove(item.id),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  VxBox()
                      .size(5, 5)
                      .color(item.isRead ? Colors.transparent : Colors.red)
                      .roundedFull
                      .make()
                      .marginOnly(right: 8),
                  Image.asset(
                    item.promote ? AppImage.promo : AppImage.remind,
                    width: 28,
                    height: 28,
                  ),
                  Dimes.width10,
                  item.title.text
                      .size(16)
                      .color(AppTheme.primary)
                      .medium
                      .make(),
                  const Spacer(),
                  item.date.text.medium.make(),
                ],
              ),
              item.description.text
                  .size(16)
                  .minFontSize(16)
                  .maxLines(2)
                  .ellipsis
                  .make()
                  .pOnly(left: 10, top: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideDelete extends StatelessWidget {
  const SlideDelete({
    super.key,
    required this.onSlideTap,
    required this.image,
    required this.text,
    required this.bg,
    this.right = false,
  });
  final VoidCallback onSlideTap;
  final String image, text;
  final Color bg;
  final bool right;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Slidable.of(context)?.close();
        onSlideTap.call();
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.only(left: right ? 5 : 0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImage.delete, width: 20, color: Colors.white),
            text.text.size(16).white.make().pOnly(top: 5),
          ],
        ),
      ),
    );
  }
}
