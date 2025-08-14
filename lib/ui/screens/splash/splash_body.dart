import 'dart:io';

import 'package:apps_mobile/main.dart';
import 'package:apps_mobile/ui/screens/home/home_offline.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/ui/screens/configuration/pin_page.dart';
import 'package:apps_mobile/ui/screens/home/home_screen.dart';
import 'package:apps_mobile/ui/screens/splash/update_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../business_logic/cubit/auth_cubit.dart';
import '../../../service_locator.dart';
import '../login/login_screen.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

var jailbroken;
var developerMode;

Future<void> checkRootStatus(BuildContext context) async {
  jailbroken = await FlutterJailbreakDetection.jailbroken;
  developerMode = await FlutterJailbreakDetection.developerMode;
}

class SplashBody extends StatefulWidget {
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  bool fingerPrint = sl<SharedPreferences>().getBool(Keys.fingerOn) ?? false;
  final String? pin = sl<SharedPreferences>().getString(Keys.pin);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRootStatus(context);
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApp(context));
  }

  Future<bool> check() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _pinStatus() async {
    final pinOn = sl<SharedPreferences>().getString(Keys.pin);
    print('pinon $pinOn');
    return pinOn != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
      if (state is AuthInitial) {
        return Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 160),
                    child: SizedBox(
                      height: 120.0,
                      child: Image.asset('assets/logo-opusb.png'),
                    ))),
            Center(
              child: SizedBox(
                child: Image.asset('assets/opusb-erp-mascot.png'),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 120.0,
                  child: Text(
                    'Version: ${Context().version}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        );
      } else if (state is AuthInProgress) {
        return LoadingIndicator();
      }
      return Container();
    }, listener: (context, state) {
      if (jailbroken
          // || developerMode
          ) {
        // Tampilkan warning
        showDialog(
          context: context,
          barrierDismissible: false, // Tidak bisa ditutup dengan tap di luar
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan Keamanan'),
              content: Text(
                // jailbroken
                // ? 'Perangkat Anda terdeteksi sudah di-root.'
                // :
                'Mode Pengembang aktif. Nonaktifkan untuk menjalankan aplikasi ini.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Keluar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Tutup aplikasi jika ingin
                    // SystemNavigator.pop(); // atau
                    exit(0);
                  },
                ),
              ],
            );
          },
        );
        // exit(0);
      } else if (state is AuthAutoLoginSuccess) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else if (state is AuthAuthenticationFailure) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else if (state is AuthMinVersionFailure) {
        Navigator.pushReplacementNamed(
          context,
          UpdateAppScreen.routeName,
          arguments: state.message,
        );
      }
    });
  }

  _initApp(context) async {
    bool conn = await check();
    if (conn) {
      Future.delayed(Duration(seconds: 2), () async {
        final pinOn = await _pinStatus();
        if (fingerPrint) {
          bool fingerTrue = await auth.authenticate(
            localizedReason: 'Scan your fingerprint to authenticate',
            options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
            ),
          );

          if (!fingerTrue) {
            if (pinOn) {
              Navigator.pushReplacementNamed(context, PinPutPage.routeName);
            } else {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          } else {
            BlocProvider.of<AuthCubit>(context).initLogin();
          }
        } else if (pinOn) {
          Navigator.pushReplacementNamed(context, PinPutPage.routeName);
        } else {
          // Navigator.pushReplacementNamed(context, PinPutPage.routeName);
          BlocProvider.of<AuthCubit>(context).initLogin();
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, HomeOffline.routeName);
    }
  }
}
