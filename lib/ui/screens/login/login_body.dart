import 'package:apps_mobile/ui/screens/authorization/authorization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/cubit/auth_cubit.dart';
import '../setup/setup_screen.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _passwordVisible = true;
  bool savePassword = false;

  void _togglevisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                height: 30.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 23,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Montserrat'),
                    ),
                    Text(
                      'to Your Account',
                      style: TextStyle(
                          fontSize: 23, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                child: Material(
                  elevation: 7.0,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(13.0),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(7.0),
                                  bottomRight: Radius.circular(7.0)),
                            ),
                            width: 320,
                            height: 60,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocus);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  fillColor: Colors.white,
                                  labelStyle:
                                      TextStyle(fontFamily: 'Montserrat'),
                                  filled: true,
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontFamily: 'Montserrat'),
                                controller: _usernameController,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                  child: Material(
                      elevation: 7.0,
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Icon(Icons.vpn_key, color: Colors.white),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(7.0),
                                      bottomRight: Radius.circular(7.0)),
                                ),
                                width: 320,
                                height: 60,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      focusNode: _passwordFocus,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (v) {
                                        _onLoginButtonPressed(context);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        labelStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                        fillColor: Colors.white,
                                        filled: true,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _togglevisibility();
                                          },
                                          child: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat'),
                                      controller: _passwordController,
                                      obscureText: _passwordVisible),
                                ),
                              ),
                            ),
                          ]))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: savePassword,
                        onChanged: (val) async {
                          setState(() {
                            savePassword = val;
                          });
                        },
                        activeColor: Colors.greenAccent[200],
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SetupScreen.routeName);
                    },
                    child: Text(
                      'Application Setup',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  )
                ],
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(7.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () => _onLoginButtonPressed(context),
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is AuthInProgress) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logging in...'),
          ),
        );
      }

      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      if (state is AuthHostNotSetFailure) {
        Navigator.pushNamed(context, SetupScreen.routeName);
      }

      if (state is AuthAuthenticationSuccess) {
        Navigator.pushNamed(context, AuthorizationScreen.routeName,
            arguments: state.response.clients);
      }
    });
  }

  _onLoginButtonPressed(BuildContext context) {
    if (savePassword) {}
    BlocProvider.of<AuthCubit>(context)
        .authenticate(_usernameController.text, _passwordController.text);
  }
}
