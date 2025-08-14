import 'package:flutter/material.dart';

import 'field_date_time_picker.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FieldDateTimePicker(
                title: 'Start date',
              ),
              SizedBox(height: 10),
              TextFormField(),
            ],
          ),
        ),
      ),
    );
  }
}
