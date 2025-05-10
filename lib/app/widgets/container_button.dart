import '../core/styles/style.dart';

enum Type { primary, secondary }

class ContainerButton extends StatelessWidget {
  const ContainerButton(
      {required this.child, this.type = Type.primary, super.key});

  final Widget child;
  final Type type;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Gradient gradient;
    switch (type) {
      case Type.primary:
        gradient = AppGradient.buttonPrimary;
        break;
      case Type.secondary:
        gradient = AppGradient.buttonSecondary;
        break;
    }
    return Container(
      height: Dimes.buttonBoxHeight,
      decoration: BoxDecoration(
        border: Border.all(width: 0),
        gradient: AppGradient.yellowOrange,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        // boxShadow: const [
        //   BoxShadow(
        //       color: AppTheme.shadowBoxColor,
        //       blurRadius: 10,
        //       spreadRadius: 0,
        //       offset: Offset(3, 3))
        // ],
      ),
      child: child,
    );
  }
}
