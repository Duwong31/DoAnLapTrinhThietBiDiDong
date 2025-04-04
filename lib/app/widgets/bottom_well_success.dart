import 'package:get/get.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';
import 'app_button.dart';

class BottomWellSuccess extends StatelessWidget {
  const BottomWellSuccess({
    super.key,
    required this.image,
    required this.message,
    required this.button,
    this.callback,
    this.enableDrag = false,
  });
  final String image, message, button;
  final VoidCallback? callback;
  final bool enableDrag;
  static void show(
    String message, {
    VoidCallback? callback,
    String image = AppImage.wellDone,
    String buttonTitle = 'OK',
    bool enableDrag = false,
  }) {
    Get.bottomSheet(
      BottomWellSuccess(
        image: image,
        message: message,
        button: buttonTitle,
        callback: callback,
        enableDrag: enableDrag,
      ),
      isDismissible: enableDrag,
      enableDrag: enableDrag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: enableDrag,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Wrap(
            runSpacing: 20,
            children: [
              VxBox()
                  .size(38, 5)
                  .color(AppTheme.primary)
                  .withRounded(value: 20)
                  .makeCentered(),
              Image.asset(image, width: context.screenWidth * .6).centered(),
              message.text.center
                  .size(16)
                  .color(AppTheme.subtitleColor)
                  .makeCentered(),
              AppButton(button, onPressed: () {
                Get.back();
                callback?.call();
              })
            ],
          ),
        ));
  }
}
