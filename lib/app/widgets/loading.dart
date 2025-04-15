import '../core/styles/style.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    this.width = 30.0,
    this.color = AppTheme.primary,
    this.isSeparatePlatform = true,
    this.strokeWidth = 4.0,
    this.padding = 10.0,
  });
  final double strokeWidth, padding;
  final double width;
  final Color color;
  final bool isSeparatePlatform;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SizedBox(
          width: width,
          height: width,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
