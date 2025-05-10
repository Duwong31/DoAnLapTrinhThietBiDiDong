import 'package:flutter/services.dart';

import '../core/styles/style.dart';
import '../core/utilities/utilities.dart';

class InputCustom extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled, readOnly;
  final TextCapitalization capitalization;
  final BorderSide? borderSide;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final double hintSize;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  const InputCustom({
    super.key,
    this.hintText = '',
    this.labelText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.multiline,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isSearch = false,
    this.borderSide,
    this.contentPadding,
    this.readOnly = false,
    this.hintStyle,
    this.hintSize = 14,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<InputCustom> {
  bool _obscureText = true;
  String _text = '';
  @override
  void initState() {
    _text = widget.controller?.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = (widget.hintStyle ?? context.subtitle1).copyWith(
      color: Colors.black,
      fontSize: widget.hintSize,
      fontWeight: FontWeight.normal,
    );

    return TextFormField(
      initialValue: widget.initialValue,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: style,
      keyboardType: widget.inputType,
      cursorColor: AppTheme.appBarTintColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: AppTheme.inputBoxBorderColor)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
        labelText: widget.labelText ?? widget.hintText,
        counterText: '',
        contentPadding: widget.contentPadding,

        isDense: true,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            context.headline2.copyWith(
              fontSize: widget.hintSize,
              color: const Color(0xff9B9B9B),
              fontWeight: FontWeight.normal,
            ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 23, maxHeight: 20),
        // filled: true,
        prefixIcon: widget.isShowPrefixIcon
            ? Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.passVisibility),
                    onPressed: _toggle,
                  )
                : widget.isSearch && _text.isNotEmpty
                    ? IconButton(
                        onPressed: _clear,
                        icon: Image.asset(
                          AppImage.close,
                          width: 20,
                        ),
                      )
                    : widget.isIcon
                        ? IconButton(
                            onPressed: widget.onSuffixTap,
                            icon: widget.suffixIcon ?? Dimes.empty,
                          )
                        : null
            : null,
      ),
      onChanged: (val) {
        widget.onChanged?.call(val);
        setState(() {
          _text = val;
        });
      },
      onTap: widget.onTap,
    );
  }

  void _clear() {
    widget.controller?.clear();
    setState(() {
      _text = '';
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
