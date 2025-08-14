import 'package:apps_mobile/ui/components/fields/dummy_screen.dart';
import 'package:apps_mobile/ui/screens/alert/alert_screen.dart';
import 'package:apps_mobile/ui/screens/approval/approval_detail_screen.dart';
import 'package:apps_mobile/ui/screens/approval/approval_screen.dart';
import 'package:apps_mobile/ui/screens/dashboard/dashboard_screen.dart';
// import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart';

import 'ui/screens/authorization/authorization_screen.dart';
import 'ui/screens/configuration/configuration_page.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/login/login_screen.dart';
import 'ui/screens/setup/setup_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/splash/update_app_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  '/dummy': (_) => DummyScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
  UpdateAppScreen.routeName: (context) => UpdateAppScreen(),
  ConfigurationPage.routeName: (context) => ConfigurationPage(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SetupScreen.routeName: (context) => SetupScreen(),
  AuthorizationScreen.routeName: (context) => AuthorizationScreen(),
  ApprovalScreen.routeName: (context) => ApprovalScreen(),
  ApprovalDetailScreen.routeName: (context) => ApprovalDetailScreen(),
  AlertScreen.routeName: (context) => AlertScreen(),
  ConfigurationPage.routeName: (context) => ConfigurationPage(),
};
