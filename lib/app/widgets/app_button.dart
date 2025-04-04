import '../core/styles/style.dart';

enum ButtonType { normal, outline, round, roundOutline, text }

class AppButton extends StatelessWidget {
  const AppButton(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.type = ButtonType.normal,
    this.borderRadius = 50.0,
    this.borderWidth = 1,
    this.borderColor,
    this.textColor,
    this.color,
    this.elevation = 0,
    this.fontSize = 15,
    this.height = 46,
    this.axisSize = MainAxisSize.max,
    this.fontWeight = FontWeight.w600,
  });
  final VoidCallback? onPressed;
  final String text;
  final bool loading;
  final bool disabled;
  final ButtonType type;
  final Widget? icon;
  final Color? borderColor, textColor, color;
  final double borderRadius, borderWidth, elevation, fontSize, height;
  final MainAxisSize axisSize;
  final FontWeight fontWeight;
  Widget _buildLoading() {
    if (!loading) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      width: 30,
      height: 30,
      child: const CircularProgressIndicator(
        strokeWidth: 1.5,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = <Widget>[
      text.text.size(fontSize).color(textColor ?? Colors.white).make(),
      _buildLoading()
    ].row(
      crossAlignment: CrossAxisAlignment.center,
      alignment: MainAxisAlignment.center,
      axisSize: axisSize,
    );
    switch (type) {
      case ButtonType.outline:
        Widget button = MaterialButton(
          color: color,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              width: borderWidth,
              color: borderColor ?? context.primaryColor,
            ),
          ),
          onPressed: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: axisSize,
            children: [
              text.text
                  // .buttonText(context)
                  .align(TextAlign.center)
                  .size(fontSize)
                  .minFontSize(10)
                  .fontWeight(fontWeight)
                  .color(
                      textColor ?? (disabled ? Colors.black26 : Colors.white))
                  .make()
                  .expand(),
            ],
          ).box.height(height).make(),
        );
        if (icon != null) {
          button = OutlinedButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: label,
          );
        }

        return button;

      case ButtonType.round:
        Widget button = ElevatedButton(
          onPressed: disabled ? null : onPressed,
          child: label,
        );
        if (icon != null) {
          button = ElevatedButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: label,
          );
        }

        return button;

      case ButtonType.roundOutline:
        Widget button = OutlinedButton(
          onPressed: disabled ? null : onPressed,
          child: label,
        );
        if (icon != null) {
          button = OutlinedButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: label,
          );
        }

        return button;

      case ButtonType.text:
        Widget button = TextButton(
          onPressed: disabled ? null : onPressed,
          child: label,
        );
        if (icon != null) {
          button = TextButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: icon!,
            label: label,
          );
        }

        return button;
      default:
        Widget button = MaterialButton(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: disabled ? Colors.grey : color ?? context.primaryColor,
          onPressed: disabled || loading ? () {} : onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: axisSize,
            children: loading
                ? [_buildLoading()]
                : <Widget>[
                    if (icon != null) icon!.pOnly(right: 5),
                    text.text
                        // .buttonText(context)
                        .align(TextAlign.center)
                        .size(fontSize)
                        .minFontSize(10)
                        .fontWeight(fontWeight)
                        .color(textColor ??
                            (disabled ? Colors.black26 : Colors.white))
                        .make()
                        .expand(),
                  ],
          ).box.height(height).make(),
        );
        // if (icon != null) {
        //   button = ElevatedButton.icon(
        //     onPressed: disabled ? null : onPressed,
        //     icon: icon!,
        //     label: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       mainAxisSize: axisSize,
        //       children: <Widget>[
        //         text.text.buttonText(context).size(fontSize).color(Colors.white).make(),
        //         _buildLoading(),
        //       ],
        //     ),
        //   );
        // }

        return button;
    }
  }
}
