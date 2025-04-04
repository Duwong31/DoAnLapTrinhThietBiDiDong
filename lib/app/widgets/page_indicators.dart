import 'dart:math';

import '../core/styles/style.dart';

const Size kDefaultSize = Size.square(10.0);
const EdgeInsets kDefaultSpacing = EdgeInsets.all(6.0);
const ShapeBorder kDefaultShape = CircleBorder();
typedef OnTap = void Function(int position);

class PageDecorator {
  const PageDecorator({
    this.color = Colors.grey,
    this.activeColor = AppTheme.primary,
    this.size = kDefaultSize,
    this.activeSize = kDefaultSize,
    this.shape = kDefaultShape,
    this.activeShape = kDefaultShape,
    this.spacing = kDefaultSpacing,
  });
  final Color color;
  final Color activeColor;
  final Size size;
  final Size activeSize;
  final ShapeBorder shape;
  final ShapeBorder activeShape;
  final EdgeInsets spacing;
}

class PageIndicators extends StatelessWidget {
  const PageIndicators({
    super.key,
    required this.numberIndicators,
    this.currentIndex = 0,
    this.decorator = const PageDecorator(),
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  })  : assert(numberIndicators > 0),
        assert(currentIndex >= 0),
        assert(
          currentIndex < numberIndicators,
          'Position must be inferior than dotsCount',
        );
  final int numberIndicators;
  final int currentIndex;
  final PageDecorator decorator;
  final Axis axis;
  final bool reversed;
  final OnTap? onTap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  Widget _buildDot(int index) {
    final state = min(1.0, (currentIndex.toDouble() - index).abs());
    final size = Size.lerp(
      decorator.activeSize,
      decorator.size,
      state,
    )!;
    final color = Color.lerp(
      decorator.activeColor,
      decorator.color,
      state,
    )!;
    final shape = ShapeBorder.lerp(
      decorator.activeShape,
      decorator.shape,
      state,
    )!;

    var dot = Container(
      width: size.width,
      height: size.height,
      margin: decorator.spacing,
      decoration: ShapeDecoration(
        color: color,
        shape: shape,
      ),
    );
    if (currentIndex == index) {
      dot = Container(
        width: size.width,
        height: size.height,
        margin: decorator.spacing,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
      );
    }
    return onTap == null
        ? dot
        : InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onTap?.call(index),
            child: dot,
          );
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(numberIndicators, _buildDot);
    final dots = reversed == true ? dotsList.reversed.toList() : dotsList;

    return axis == Axis.vertical
        ? dots.column(
            alignment: mainAxisAlignment,
            axisSize: mainAxisSize,
          )
        : dots.row(
            alignment: mainAxisAlignment,
            axisSize: mainAxisSize,
          );
  }
}
