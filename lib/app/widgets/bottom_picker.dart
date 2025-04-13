import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/styles/style.dart';

class MenuItems {
  final String text;
  final IconData icons;
  final MaterialColor color;
  final ImageSource imageSource;

  MenuItems({
    required this.text,
    required this.icons,
    required this.color,
    required this.imageSource,
  });
}

class BottomPicker extends StatelessWidget {
  const BottomPicker({super.key, this.onTap});
  final Function(ImageSource)? onTap;
  static void show(Function(ImageSource)? onTap) {
    Get.bottomSheet(BottomPicker(onTap: onTap));
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItems> menuItems = [
      MenuItems(
        text: 'Photos',
        icons: Icons.image,
        color: Colors.amber,
        imageSource: ImageSource.gallery,
      ),
      MenuItems(
        text: 'Camera',
        icons: Icons.camera_alt,
        color: Colors.blue,
        imageSource: ImageSource.camera,
      ),
    ];
    return Container(
      color: const Color(0xff737373),
      child: Container(
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
              children: menuItems
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                        onTap: () {
                          onTap?.call(e.imageSource);
                          Get.back();
                        },
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: e.color.shade50,
                          ),
                          height: 50,
                          width: 50,
                          child: Icon(
                            e.icons,
                            size: 20,
                            color: e.color.shade400,
                          ),
                        ),
                        title: e.text.text.semiBold.make(),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
