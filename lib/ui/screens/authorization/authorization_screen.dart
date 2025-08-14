import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/cubit/auth_cubit.dart';
import '../../../business_logic/models/id_name_pair.dart';
import 'authorization_body.dart';

class AuthorizationScreen extends StatelessWidget {
  static String routeName = "/authorization";

  @override
  Widget build(BuildContext context) {
    final List<IdNamePair> clients =
        (ModalRoute.of(context)?.settings.arguments ?? <IdNamePair>[])
            as List<IdNamePair>;
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit()..initAuthorization(clients),
        child: AuthorizationBody(
          clients: clients,
        ),
      ),
    );
  }
}
