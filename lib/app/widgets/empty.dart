import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.image,
    this.title = 'Nothing found',
    this.content = "Pharmacy notifications will appear here",
    this.icon,
  });
  final String? image;
  final String title;
  final String content;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        final height = constraints.maxHeight;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                icon ??
                    Image.asset(
                      image ?? AppImage.empty,
                      width: height * 0.4,
                      height: height * 0.4,
                      // color: primary,
                    ),
                Dimes.height10,
                title.text.center.medium
                    .color(primary)
                    .size(height * 0.04)
                    .make(),
                Dimes.height10,
                content.text.center.medium.size(height * 0.02).make(),
              ],
            ),
          ),
        );
      },
    );
  }
}
