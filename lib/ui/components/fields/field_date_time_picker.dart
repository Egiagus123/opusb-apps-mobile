import 'package:apps_mobile/ui/components/fields/wrap_title.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

export 'package:date_field/date_field.dart' show DateTimeFieldPickerMode;

typedef FieldDatePicketOnSelected = void Function(DateTime date);

class FieldDateTimePicker extends StatefulWidget {
  const FieldDateTimePicker({
    Key? key,
    this.title,
    this.autovalidateMode = AutovalidateMode.always,
    this.initialDate,
    this.startDate,
    this.endDate,
    this.errorText,
    this.validator,
    this.onSelected,
    this.mode = DateTimeFieldPickerMode.date,
  }) : super(key: key);

  final String? title;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<DateTime>? validator;
  final String? errorText;
  final DateTimeFieldPickerMode mode;
  final DateTime? initialDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final FieldDatePicketOnSelected? onSelected;

  @override
  State<FieldDateTimePicker> createState() => _FieldDateTimePickerState();
}

class _FieldDateTimePickerState extends State<FieldDateTimePicker> {
  late final FocusNode _focusNode;
  bool _dialogOpened = false;
  int _pointerStart = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  DesignData? get design => DesignTheme.of(context);

  @override
  Widget build(BuildContext context) {
    return WrapTitle(
      title: widget.title ?? '',
      child: Listener(
        onPointerDown: (event) {
          _pointerStart = event.position.hashCode;
        },
        onPointerUp: (event) {
          if (_pointerStart == event.position.hashCode) {
            _focusNode.requestFocus();
            _dialogOpened = true;
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Focus(
          canRequestFocus: true,
          focusNode: _focusNode,
          onFocusChange: (focused) {
            if (_dialogOpened && !focused && _pointerStart != 0) {
              _focusNode.requestFocus();
              _pointerStart = 0;
              _dialogOpened = false;
            }
          },
          child: _buildDateTimeField(),
        ),
      ),
    );
  }

  DateTimeFormField _buildDateTimeField() {
    // final inputDecoration = design?.getInputDecoration(
    //       hasFocus: _focusNode.hasFocus,
    //       enabled: true,
    //       suffixIcon: Icons.calendar_today_outlined,
    //       errorText: widget.errorText,
    //     ) ??
    //     InputDecoration(
    //       border: const OutlineInputBorder(),
    //       suffixIcon: const Icon(Icons.calendar_today_outlined),
    //       errorText: widget.errorText,
    //     );

    return DateTimeFormField(
      initialValue: widget.initialDate,
      firstDate: widget.startDate,
      lastDate: widget.endDate,
      dateTextStyle: TextStyle(fontSize: 16),
      autovalidateMode: widget.autovalidateMode,
      mode: widget.mode,
      onDateSelected: (DateTime date) {
        _dialogOpened = false;
        widget.onSelected?.call(date);
      },
      decoration: InputDecoration(
        labelText: 'Select Date',
        labelStyle: TextStyle(fontSize: 16),
        hintText: 'yyyy-mm-dd',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
