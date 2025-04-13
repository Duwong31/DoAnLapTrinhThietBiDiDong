import '../styles/style.dart';

class CardViewWidget extends StatelessWidget {
  const CardViewWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff242424),
      child: child,
    );
  }
}
