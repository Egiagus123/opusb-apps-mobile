// import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/ui/screens/configuration/pin_page.dart';
// import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service_locator.dart';
import 'base_config_page.dart';

class ConfigurationPage extends StatefulWidget {
  static String routeName = "/config";

  final bool _statusFinger;
  final String _pin;
  ConfigurationPage({bool? statusFinger, String? pin})
      : _statusFinger = statusFinger!,
        _pin = pin!;

  @override
  _ConfigurationPageState createState() =>
      _ConfigurationPageState(statusFinger: _statusFinger, pin: _pin);
}

class _ConfigurationPageState extends State<ConfigurationPage>
    with WidgetsBindingObserver {
  bool statusFinger = false;
  bool pinOn = false;
  Size? deviceSize;
  final LocalAuthentication auth = LocalAuthentication();

  bool? fingerPrint = sl<SharedPreferences>().getBool(Keys.fingerOn) == null
      ? false
      : sl<SharedPreferences>().getBool(Keys.fingerOn);
  String? pin = sl<SharedPreferences>().getString(Keys.pin);

  _ConfigurationPageState({bool? statusFinger, String? pin})
      : statusFinger = statusFinger!,
        pin = pin;

  @override
  initState() {
    if (this.statusFinger.toString() == 'null') statusFinger = false;
    _pinStatus();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Future<bool> _fingerPrintStatus() async {
    final fingerPrint = sl<SharedPreferences>().getBool(Keys.fingerOn);
    if (fingerPrint == null) {
      return false;
    }
    return fingerPrint;
  }

  _pinStatus() async {
    final checkPin = sl<SharedPreferences>().getString(Keys.pin);
    if (checkPin == null) {
      setState(() {
        this.pin = checkPin;
        this.pinOn = false;
      });
    } else {
      setState(() {
        this.pinOn = true;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // final checkPin = sl<SharedPreferences>().getString(Keys.pin);
    // final fingerPrint = await _fingerPrintStatus();
    // if (state == AppLifecycleState.resumed) {
    //   if (fingerPrint) {
    //     var fingerTrue = await auth.authenticateWithBiometrics(
    //         localizedReason: 'Scan your fingerprint to authenticate',
    //         useErrorDialogs: true,
    //         stickyAuth: true);

    //     if (!fingerTrue) {
    //       if (checkPin != null) {
    //         Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => PinPutPage(pin: checkPin)));
    //       }
    //     }
    //   } else if (checkPin != null) {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => PinPutPage(pin: checkPin)));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = AdaptiveTheme.of(context).mode.isDark;
    deviceSize = MediaQuery.of(context).size;
    final String? host = sl<SharedPreferences>().getString(Keys.authHost);

    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      BaseConfigPage(isDarkMode: isDarkMode),
      allCards(context, isDarkMode, host!)
    ]));
  }

  Future<bool> _checkBiometrics(bool val) async {
    // ignore: unused_catch_clause

    try {} on PlatformException catch (e) {
      return false;
    }

    return await _authenticate(val);
  }

  Future<bool> _authenticate(bool val) async {
    try {
      val = await await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
      if (!val) {
        return false;
      } else {
        return true;
      }
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return false;
    }
  }

  Widget textWidget(String words) => Text(
        words,
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
      );

  Widget allCards(BuildContext context, bool isDarkMode, String host) =>
      SingleChildScrollView(
          child: Column(children: <Widget>[
        SizedBox(
          height: deviceSize!.height * 0.1,
        ),
        Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(
          height: deviceSize!.height * 0.04,
        ),
        displayCard(isDarkMode),
        securityCard(host),
        // logoutCard(isDarkMode)
      ]));

  Widget displayCard(bool isDarkMode) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 12, left: 20),
                    child: Text(
                      'Display',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    )),
              ),
              ListTile(
                leading: Icon(EvaIcons.sunOutline),
                title: textWidget('Dark Themes'),
                trailing: Switch(
                  activeColor: mainColor,
                  value: isDarkMode,
                  onChanged: (val) async {
                    AdaptiveTheme.of(context).toggleThemeMode();
                  },
                ),
              ),
            ]))),
      ));

  Widget securityCard(String host) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, left: 18),
                    child: Text(
                      'Security',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: textWidget('Set Pin'),
                  subtitle: Text(
                    pinOn
                        ? 'Tap here and change your pin'
                        : 'Setup your pin and login with pin',
                    style: const TextStyle(fontFamily: 'Montserrat'),
                  ),
                  onTap: () async {
                    if (pinOn) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => buildAlertDialog(
                          ctx,
                          title: 'Change pin?',
                          content:
                              'Want to change your pin and delete the old one?',
                          cancelText: 'No',
                          cancelCallback: () => Navigator.of(ctx).pop(false),
                          proceedText: 'Yes',
                          proceedCallback: () => Navigator.of(ctx).pop(true),
                        ),
                      );

                      if (confirmed == true) {
                        sl<SharedPreferences>().remove(Keys.pin);
                        _pinStatus();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (ctx) => PinPutPage(pin: pin!)),
                        );
                      }
                    }
                  },
                  trailing: Switch(
                    activeColor: mainColor,
                    value: pinOn,
                    onChanged: (val) async {
                      if (val) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => PinPutPage(pin: pin!)),
                        );
                      } else {
                        setState(() {
                          sl<SharedPreferences>().remove(Keys.pin);
                          pinOn = false;
                        });
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.fingerprint),
                  title: textWidget('Set Fingerprint'),
                  subtitle: const Text(
                    'Login with fingerprint',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  trailing: Switch(
                    activeColor: mainColor,
                    value: fingerPrint!,
                    onChanged: (val) async {
                      if (val) {
                        final result = await _checkBiometrics(val);
                        setState(() {
                          fingerPrint = result;
                          sl<SharedPreferences>()
                              .setBool(Keys.fingerOn, result);
                        });
                      } else {
                        setState(() {
                          fingerPrint = false;
                          sl<SharedPreferences>().setBool(Keys.fingerOn, false);
                        });
                      }
                    },
                  ),
                ),
                ExpansionTile(
                  title: textWidget('About'),
                  leading: Icon(Icons.info),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 70, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OpusB Inventory Mobile',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                                'Version: ${Context().version} Build: ${Context().buildNumber}'),
                            Text('Address : $host'),
                            Text('Client : ${Context().clientName}'),
                            Text('Role : ${Context().roleName}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget logoutCard(bool isDarkMode) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(children: [
                MaterialButton(
                    onPressed: null,
                    child: Text('Logout',
                        style: TextStyle(
                            color: isDarkMode ? purewhiteTheme : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 16)))
              ])))));
}
