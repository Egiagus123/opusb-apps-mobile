import 'package:flutter/material.dart';

typedef FocusableFieldBuilder = Widget Function(
  BuildContext context,
  bool hasFocus,
);

typedef FocusableOnFocusChange = void Function(
  bool hasFocus,
  int pointerStart,
);

class FocusableField extends StatefulWidget {
  const FocusableField({
    Key? key,
    required this.builder,
    required this.onFocusChange,
  })  : assert(builder != null, 'builder cannot be null'),
        super(key: key);

  final FocusableFieldBuilder? builder;
  final FocusableOnFocusChange? onFocusChange;

  @override
  _FocusableFieldState createState() => _FocusableFieldState();
}

class _FocusableFieldState extends State<FocusableField> {
  int pointerStart = 0;

  // --- FocusNode initialization
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize FocusNode
    focusNode = FocusNode();
    // Adding listener to update state when focus changes
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose the FocusNode when widget is disposed to avoid memory leaks
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // Save the pointer start position on touch down
        pointerStart = event.position.hashCode;
      },
      onPointerUp: (event) {
        // If the pointer down position matches pointer up, request focus
        if (pointerStart == event.position.hashCode) {
          focusNode.requestFocus();
        }
      },
      child: Focus(
        canRequestFocus: true,
        focusNode: focusNode,
        onFocusChange: (value) {
          // Call the onFocusChange callback with the current focus state
          widget.onFocusChange!(value, pointerStart);
          pointerStart = 0; // Reset pointer start after focus change
        },
        child: widget.builder!(context, focusNode.hasFocus),
      ),
    );
  }
}
