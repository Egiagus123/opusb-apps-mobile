import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/dashboard_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/downloaddata_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/inventory/alert_note_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/inventory/chart_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/inventory/watchlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (BuildContext context) => AuthCubit(),
          ),
          BlocProvider<DashboardCubit>(
            create: (BuildContext context) => DashboardCubit(),
          ),
          BlocProvider<DownloadDataCubit>(
            create: (BuildContext context) => DownloadDataCubit(),
          ),
          // * ============= INVENTORY =================
          BlocProvider<ApprovalCubit>(
            create: (BuildContext context) => ApprovalCubit(),
          ),
          BlocProvider<AlertNoteCubit>(
            create: (BuildContext context) => AlertNoteCubit(),
          ),
          BlocProvider<ChartCubit>(
            create: (BuildContext context) => ChartCubit(),
          ),
          BlocProvider<WatchlistCubit>(
            create: (BuildContext context) => WatchlistCubit(),
          ),
          // * ============= INVENTORY =================
        ],
        child: WillPopScope(
          onWillPop: () async {
            // Tampilkan dialog dan tunggu hasilnya
            bool? shouldExit = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit?'),
                actions: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                ],
              ),
            );
            // Return true jika user memilih Yes, false jika memilih No
            return shouldExit ?? false;
          },
          child: HomeBody(),
        ));
  }
}
