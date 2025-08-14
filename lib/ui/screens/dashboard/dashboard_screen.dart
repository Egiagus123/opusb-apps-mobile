import 'package:flutter/material.dart';

import 'dashboard_body.dart';

class DashboardScreen extends StatelessWidget {
  static String routeName = "/dashboard";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DashboardBody(),
    );
  }
}
