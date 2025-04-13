import '../styles/style.dart';
import '../utilities/image.dart';

enum BackgroundWidgetType { primary, secondary }

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    super.key,
    required this.child,
    this.type = BackgroundWidgetType.primary,
    this.isSafeArea = false,
  });
  final Widget child;
  final BackgroundWidgetType type;
  final bool isSafeArea;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(
                type == BackgroundWidgetType.primary
                    ? AppImage.primaryBackground
                    : AppImage.secondaryBackground,
              ),
              fit: BoxFit.cover)),
      child: child,
    );
    return isSafeArea
        ? SafeArea(
            child: container,
          )
        : container;
  }
}
