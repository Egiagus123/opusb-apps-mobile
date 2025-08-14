import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/ui/screens/configuration/pin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinPutPage extends StatelessWidget {
  static const String routeName = '/pin-put'; // <-- ADD THIS LINE

  final String _pin, _whilePin;
  PinPutPage({required String pin, whilePin})
      : _pin = pin,
        _whilePin = whilePin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: PinPutForm(pin: _pin),
      ),
    );
  }
}
