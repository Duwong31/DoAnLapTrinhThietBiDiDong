import 'package:get/get.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';

class BottomChangeSelect extends StatelessWidget {
  const BottomChangeSelect(
      {super.key, required this.items, this.onTap, this.active});
  final Function(String)? onTap;
  final String? active;
  final List<String> items;
  static void show(
      {Function(String)? callback,
      String? active,
      required List<String> items}) {
    Get.bottomSheet(BottomChangeSelect(
      onTap: callback,
      active: active,
      items: items,
    ));
  }

  @override
  Widget build(BuildContext context) {
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
            children: items
                .map(
                  (e) => Material(
                    child: ListTile(
                      title:
                          e.text.size(16).medium.color(AppTheme.primary).make(),
                      trailing: Image.asset(
                        active == e ? AppImage.check : AppImage.empty,
                        color: active == e ? AppTheme.secondary : null,
                        width: 20,
                      ),
                      onTap: () {
                        Get.back();
                        onTap?.call(e);
                      },
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
