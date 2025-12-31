import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/utils/extensions/string_extension.dart';
import '../../../core/utils/extensions/widget_extension.dart';

enum BorderType { none, underlined, outlined }

class LabeledTextField extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final String? hint;
  final TextStyle? hintStyle;
  final Color? bgColor;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final BorderType borderType;
  final double borderRadius;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets contentPadding;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final TextCapitalization textCapitalization;
  final AutovalidateMode? autoValidateMode;

  const LabeledTextField({
    super.key,
    this.label,
    this.labelStyle,
    this.hint,
    this.hintStyle,
    this.bgColor,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.borderType = BorderType.none,
    this.borderRadius = 0.0,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.inputFormatters,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.textCapitalization = TextCapitalization.none,
    this.autoValidateMode,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      textCapitalization: widget.textCapitalization,
      autovalidateMode: widget.autoValidateMode,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? const TextStyle(color: Colors.grey),
        filled: widget.bgColor != null,
        fillColor: widget.bgColor,
        contentPadding: widget.contentPadding,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        enabledBorder: _getBorder(Colors.grey),
        focusedBorder: _getBorder(Theme.of(context).primaryColor),
        errorBorder: _getBorder(AppColors.errorColor),
        disabledBorder: _getBorder(Colors.grey.shade300),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotNullAndNotEmpty) ...[
          widget.label!.translatedTextWidget(style: widget.labelStyle),
          8.h.vSpace,
        ],
        widget.borderType == BorderType.none
            ? ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: textField,
              )
            : textField,
      ],
    );
  }

  InputBorder _getBorder(Color color) {
    switch (widget.borderType) {
      case BorderType.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: color, width: _hasFocus ? 2 : 1),
        );
      case BorderType.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: _hasFocus ? 2 : 1),
        );
      case BorderType.none:
        return InputBorder.none;
    }
  }
}
