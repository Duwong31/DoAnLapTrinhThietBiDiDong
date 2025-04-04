import '../core/styles/style.dart';

enum Type { primary, secondary }

class ContainerButton extends StatelessWidget {
  const ContainerButton(
      {required this.child, this.type = Type.primary, super.key});

  final Widget child;
  final Type type;

  @override
  Widget build(BuildContext context) {
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
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: const [
          BoxShadow(
              color: AppTheme.shadowBoxColor,
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(3, 3))
        ],
      ),
      child: child,
    );
  }
}
