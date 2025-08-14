import 'package:apps_mobile/ui/components/fields/wrap_title.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:flutter/material.dart';

class FieldText extends StatefulWidget {
  const FieldText({
    Key? key,
    this.title,
    this.errorText,
    this.validator,
    this.controller,
    this.onEditingComplete,
    this.obsecureText = false,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  final String? title;
  final String? errorText;
  final bool obsecureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;

  @override
  State<FieldText> createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> _focusNotifier;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNotifier = ValueNotifier<bool>(_focusNode.hasFocus);

    _focusNode.addListener(() {
      _focusNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WrapTitle(
      title: widget.title ?? '',
      child: ValueListenableBuilder<bool>(
        valueListenable: _focusNotifier,
        builder: (context, focused, child) {
          return TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            obscureText: widget.obsecureText,
            decoration: InputDecoration(
              // labelText: 'Choose an Item',
              // labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2.5,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
          );
        },
      ),
    );
  }
}
