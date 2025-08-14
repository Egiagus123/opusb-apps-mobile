import 'package:apps_mobile/business_logic/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/cubit/auth_cubit.dart';
import 'splash_body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: SplashBody(),
      ),
    );
  }
}
