import 'package:get/get.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';

class SelectItem {
  final String title;
  final String value;
  SelectItem(this.title, this.value);
}

class BottomChangeOrder extends StatelessWidget {
  const BottomChangeOrder({super.key, this.onTap});

  final Function(String)? onTap;

  static void bottomChangeStatus({Function(String)? callback}) {
    Get.bottomSheet(BottomChangeOrder(onTap: callback));
  }

  @override
  Widget build(BuildContext context) {
    const active = StringUtils.pickupStore;
    final titles = [
      SelectItem('Pickup at Store', StringUtils.pickupStore),
      SelectItem('Delivery', StringUtils.orderDelivered),
      SelectItem('Shipping', StringUtils.shipping),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          const Row(children: [Dimes.height10]),
          VxBox()
              .size(38, 5)
              .color(AppTheme.primary)
              .withRounded(value: 20)
              .makeCentered(),
          Dimes.height10,
          Wrap(
              children: titles
                  .map(
                    (e) => Material(
                      child: ListTile(
                        title: e.title.text
                            .size(16)
                            .medium
                            .color(AppTheme.primary)
                            .make(),
                        trailing: Image.asset(
                          active == e.value ? AppImage.check : AppImage.empty,
                          color: active == e.value ? AppTheme.secondary : null,
                          width: 20,
                        ),
                        onTap: () {
                          Get.back();
                          onTap?.call(StringUtils.pickupStore);
                        },
                      ),
                    ),
                  )
                  .toList())
        ],
      ),
    );
  }
}
