import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/ui/screens/features/assetaudit/assetaudit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetAuditInitial extends StatefulWidget {
  @override
  State createState() => _AssetAuditInitialState();
}

class _AssetAuditInitialState extends State<AssetAuditInitial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AssetAuditCubit>(
        create: (BuildContext context) => AssetAuditCubit(),
        child: AssetAudit(),
      ),
    );
  }
}
