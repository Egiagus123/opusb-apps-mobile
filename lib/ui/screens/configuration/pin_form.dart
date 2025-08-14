import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/ui/screens/configuration/configuration_page.dart';
import 'package:apps_mobile/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service_locator.dart';

class PinPutForm extends StatefulWidget {
  final String _pin, _whilepin;

  PinPutForm({@required String? pin, String? whilePin})
      : _pin = pin!,
        _whilepin = whilePin!;

  @override
  _PinPutFormState createState() =>
      _PinPutFormState(pin: _pin, whilePin: _whilepin);
}

class _PinPutFormState extends State<PinPutForm> {
  final String _pin, _whilePin;
  String? username, pass, text, text2, text3, role, org, client;
  int? roles, orgs, clients;
  _PinPutFormState({String? pin, whilePin})
      : _pin = pin!,
        _whilePin = whilePin;
  final pinSaved = sl<SharedPreferences>().getString(Keys.pin);
  final _pinController = TextEditingController();
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String? errorMessage;

  _initApp(context) {
    Future.delayed(const Duration(seconds: 2), () async {
      await BlocProvider.of<AuthCubit>(context).initreLogin();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pinSaved == null) {
      setState(() {
        text = "Setup New Pin";
        text2 = "";
        text3 = "";
      });
    } else {
      setState(() {
        text = "Enter Security Pin Code";
        text2 = "Forget pin?";
        text3 = "Logout and Reset your pin";
      });
    }
    _onInputPinDone() async {
      if (pinSaved == null) {
        // set up the buttons
        Widget okButton = MaterialButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            });

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("Your pin has been configured !"),
          actions: [
            okButton,
          ],
        );
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        ).then((value) => {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                return new ConfigurationPage();
              }))
            });

        sl<SharedPreferences>().setString(Keys.pin, _pinController.text);
      }
      if (pinSaved != null &&
          pinSaved == _pinController.text &&
          _whilePin == null) {
        _initApp(context);
      }
      if (pinSaved != null &&
          pinSaved != _pinController.text &&
          _whilePin == null) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.red, content: new Text("Wrong Password")));
        _pinController.text = "";
      }
      if (_whilePin != null && _whilePin == _pinController.text) {
        Navigator.pop(context);
      }
    }

    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async =>
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: Scaffold(
              body: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      text!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                  )),
                  Container(
                    height: 100.0,
                    child: GestureDetector(
                      child: PinCodeTextField(
                        appContext: context, // WAJIB!
                        length: pinLength,
                        controller: _pinController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        animationType: AnimationType.scale,
                        keyboardType: TextInputType.number,
                        textStyle: const TextStyle(fontSize: 30.0),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        onChanged: (value) {
                          setState(() {
                            hasError = false;
                          });
                        },
                        onCompleted: (value) {
                          _onInputPinDone();
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      text2!,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: MaterialButton(
                        textColor: Colors.blue,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          // (_pin != null)
                          // ? BlocProvider.of<AuthBloc>(context)
                          //     .add(AuthEventLogout())
                          // : null;
                        },
                        child: Text(
                          text3!,
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ))
                ],
              ),
            ),
          )),
        );
      },
      listener: (context, state) {
        if (state is AuthInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Loading...')),
          );
          // return Scaffold.of(context).s(
          //   SnackBar(
          //     content: Text('loading...'),
          //   ),
          // );
        } else if (state is AuthAutoLoginSuccess) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      },
    );
  }
}
