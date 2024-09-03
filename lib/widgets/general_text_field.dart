import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField({
    required this.title,
    this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.validate,
    this.onTap,
    required this.onFieldSubmitted,
    this.isObscure = false,
    this.isReadOnly = false,
    Key? key,
    this.maxLength,
    this.suffixWidget,
    this.maxLines = 1,
    this.focusNode,
    this.inputFormatter,
    this.autoFillhints,
  }) : super(key: key);

  final String title;
  final TextEditingController? controller;
  final int? maxLength;
  final int maxLines;
  final bool isObscure;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final Widget? suffixWidget;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final Iterable<String>? autoFillhints;
  final String? Function(String?)? validate;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  late bool toHide;

  @override
  void initState() {
    super.initState();
    toHide = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      autofillHints: widget.autoFillhints,
      keyboardType: widget.textInputType,
      readOnly: widget.isReadOnly,
      obscureText: toHide,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      decoration: InputDecoration(
        fillColor: const Color(0xfff3f3f3),
        filled: true,
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(
                  toHide
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    toHide = !toHide;
                  });
                },
              )
            : widget.suffixWidget,
        hintText: widget.title,
        counter: const SizedBox.shrink(),
      ),
      controller: widget.controller,
      inputFormatters: widget.inputFormatter,
      maxLength: widget.maxLength,
      validator: widget.validate,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
