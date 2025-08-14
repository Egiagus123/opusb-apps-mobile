import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:apps_mobile/ui/screen_util.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'business_logic/utils/simple_bloc_observer.dart';

import 'routes.dart';
import 'service_locator.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/themes/opusb_theme.dart';

class TamperChecker {
  static const MethodChannel _channel = MethodChannel('tamper_check');

  static Future<bool> checkSignature() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('checkSignature');
      return result ?? false; // fallback jika null
    } catch (e) {
      print("Error checking signature: $e");
      return false;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isValid = await TamperChecker.checkSignature();
  if (!isValid) {
    print("⚠️ APK telah diubah atau ditandatangani ulang.");
    exit(0); // Atau tampilkan warning
  }
  Logger.level = Level.info;
  EquatableConfig.stringify = true;
  Bloc.observer = SimpleBlocObserver();
  await init();
  HttpOverrides.global = new MyHttpOverrides();
  await Firebase.initializeApp();
  runApp(RestartWidget());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        // WARNING: Jangan gunakan ini di production
        return true;
      };
  }
}

class RestartWidget extends StatefulWidget {
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return KeyedSubtree(
      key: key,
      child: AdaptiveTheme(
        light: OpusbTheme(isDark: false).themeData,
        dark: OpusbTheme(isDark: true).themeData,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => DesignTheme(
          data: DesignData.foundation(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'OpusB Mobile',
            theme: theme,
            darkTheme: darkTheme,
            initialRoute: SplashScreen.routeName,
            routes: routes,
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              ScreenUtil.init(
                  screenSizeheight: mediaQuery.size.height,
                  screenSizewidth: mediaQuery.size.width);

              return MediaQuery(
                data: mediaQuery.copyWith(
                  // Disable text scaling to avoid render overflow
                  textScaleFactor: 1,
                ),
                child: child!,
              );
            },
          ),
        ),
      ),
    );
  }
}
