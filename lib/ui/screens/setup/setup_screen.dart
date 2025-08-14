import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import '../../../business_logic/cubit/setup_cubit.dart';
import 'setup_body.dart';

class SetupScreen extends StatelessWidget {
  static String routeName = "/setup";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(false)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'APPLICATION SETUP',
          style: TextStyle(
            fontFamily: 'Oswald',
            letterSpacing: 0.5,
            color: purewhiteTheme,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => SetupCubit()..loadHost(),
        child: SetupBody(),
      ),
    );
  }
}
