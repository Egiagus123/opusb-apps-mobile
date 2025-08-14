import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/business_logic/models/id_name_pair.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/home/home_screen.dart';
import 'package:apps_mobile/ui/screens/splash/update_app_screen.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorizationBody extends StatelessWidget {
  final List<IdNamePair> clients;

  const AuthorizationBody({Key? key, required this.clients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
      if (state is AuthInProgress) {
        return LoadingIndicator();
      } else if (state is AuthAuthorizationDataLoaded) {
        return buildData(context, state.clientId, state.roles, state.roleId,
            state.orgs, state.orgId);
      } else {
        return buildData(context, 0, [], 0, [], 0);
      }
    }, listener: (context, state) {
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${state.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      } else if (state is AuthAuthorizationSuccess) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else if (state is AuthMinVersionFailure) {
        Navigator.pushReplacementNamed(
          context,
          UpdateAppScreen.routeName,
          arguments: state.message,
        );
      }
    });
  }

  Widget buildData(BuildContext context, int clientId, List<IdNamePair> roles,
      int roleId, List<IdNamePair> orgs, int orgId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 150.0,
          ),
          SizedBox(
            height: 115.0,
            child: Image.asset('assets/logo-opusb.png'),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text('Client :',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12)),
            subtitle: DropdownButton<int>(
              isExpanded: true,
              value: clientId > 0 ? clientId : null,
              items: clients
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          c.name,
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ))
                  .toList(),
              onChanged: (id) => setClient(context, id!),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ListTile(
            title: Text('Role :',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12)),
            subtitle: DropdownButton<int>(
              isExpanded: true,
              value: roleId > 0 ? roleId : null,
              items: roles
                  .map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.name,
                            style: TextStyle(fontFamily: 'Montserrat')),
                      ))
                  .toList(),
              onChanged: (id) => setRole(context, clientId, id!),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ListTile(
            title: Text('Org :',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12)),
            subtitle: DropdownButton<int>(
              isExpanded: true,
              value: orgId != null ? orgId : null,
              items: orgs
                  .map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.name,
                            style: TextStyle(fontFamily: 'Montserrat')),
                      ))
                  .toList(),
              onChanged: (id) => setOrg(context, clientId, roleId, id!, roles),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(7),
            color: orgId > 0 ? themeswatch : Colors.grey,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              // disabledColor: Colors.grey,
              onPressed: (clientId > 0 && roleId > 0 && orgId > 0)
                  ? () => authorize(context, clientId, roleId, orgId)
                  : null,
              child: Text(
                "SUBMIT",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald',
                    fontSize: 15,
                    letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setClient(BuildContext context, int clientId) {
    BlocProvider.of<AuthCubit>(context)
        .loadAuthorizationData(clientId: clientId);
  }

  void setRole(BuildContext context, int clientId, int roleId) {
    BlocProvider.of<AuthCubit>(context)
        .loadAuthorizationData(clientId: clientId, roleId: roleId);
  }

  void setOrg(BuildContext context, int clientId, int roleId, int orgId,
      List<IdNamePair> roles) {
    BlocProvider.of<AuthCubit>(context).loadOrg(
        clientId: clientId, roleId: roleId, orgId: orgId, roles: roles);
  }

  void authorize(BuildContext context, int clientId, int roleId, int orgId) {
    BlocProvider.of<AuthCubit>(context).authorize(clientId, roleId, orgId);
  }
}
