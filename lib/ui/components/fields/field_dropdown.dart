import 'package:apps_mobile/ui/components/fields/focusable_field.dart';
import 'package:apps_mobile/ui/components/fields/wrap_title.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:flutter/material.dart';

typedef FieldDropdownItemTextBuilder<T> = String Function(T item);

class FieldDropdown<T> extends StatelessWidget {
  const FieldDropdown({
    Key? key,
    this.title, // Menggunakan nullable untuk title
    this.errorText, // Menggunakan nullable untuk errorText
    this.initialValue, // Menggunakan nullable untuk initialValue
    this.items, // Menggunakan nullable untuk items
    required this.itemTextBuilder,
    required this.onChanged,
  }) : super(key: key);

  final String? title;
  final String? errorText;
  final T? initialValue; // Nullable initialValue
  final List<T>? items; // Nullable List
  final ValueChanged<T?>? onChanged;
  final FieldDropdownItemTextBuilder<T> itemTextBuilder;

  @override
  Widget build(BuildContext context) {
    // Memastikan itemTextBuilder tidak null
    final itemBuilder = (T item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(itemTextBuilder(item)),
      );
    };

    // Menangani null untuk items dan initialValue
    final enabled = onChanged != null &&
        (items?.isNotEmpty ??
            false); // Pastikan items tidak null dan tidak kosong

    // Jika title null, beri nilai default
    return WrapTitle(
      title: title ??
          'Default Title', // Menambahkan nilai default untuk title jika null
      child: IgnorePointer(
        ignoring: !enabled,
        child: FocusableField(
          builder: (context, hasFocus) {
            return DropdownButtonFormField<T>(
              isExpanded: true,
              value: initialValue ??
                  (items?.isNotEmpty ?? false
                      ? items![0]
                      : null), // Gunakan nilai default jika initialValue null
              items: (items ?? [])
                  .map(itemBuilder)
                  .toList(), // Jika items null, gunakan list kosong
              // decoration: DesignTheme.of(context)?.getInputDecoration(
              //   hasFocus: hasFocus,
              //   errorText: errorText,
              //   enabled: enabled,
              // ),
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
              onChanged: enabled ? onChanged : null,
            );
          },
          onFocusChange: (bool hasFocus, int pointerStart) {},
        ),
      ),
    );
  }
}
