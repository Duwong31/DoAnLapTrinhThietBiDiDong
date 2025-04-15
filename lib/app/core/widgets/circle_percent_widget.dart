import 'package:percent_indicator/circular_percent_indicator.dart';

import '../styles/style.dart';

enum CirclePercentWidgetGradientType { red, yellow, green }

class CirclePercentWidget extends StatelessWidget {
  const CirclePercentWidget(
      {super.key,
      required this.type,
      required this.radius,
      required this.percent});
  final CirclePercentWidgetGradientType type;
  final double radius;
  final double percent;

  static LinearGradient buildGradient(
          AlignmentGeometry begin, AlignmentGeometry end, List<Color> colors) =>
      LinearGradient(begin: begin, end: end, colors: colors);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CirclePercentWidgetGradientType.red:
        return _buildCircle(
          CirclePercentWidgetGradientType.red,
          radius,
          percent,
          AppGradient.circleRed,
        );
      case CirclePercentWidgetGradientType.yellow:
        return _buildCircle(
          CirclePercentWidgetGradientType.red,
          radius,
          percent,
          AppGradient.circleYellow,
        );
      case CirclePercentWidgetGradientType.green:
        return _buildCircle(
          CirclePercentWidgetGradientType.red,
          radius,
          percent,
          AppGradient.circleGreen,
        );
    }
  }

  Widget _buildCircle(CirclePercentWidgetGradientType type, double radius,
      double percent, LinearGradient gradient) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 1)
        ],
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularPercentIndicator(
            radius: radius,
            lineWidth: 20.0,
            animation: true,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: const Color(0xff6A6A6A),
            linearGradient: gradient,
          ),
          (percent * 100)
              .toInt()
              .toString()
              .text
              .color(Colors.white)
              .size(radius / 2.0)
              .bold
              .make(),
        ],
      ),
    );
  }
}
