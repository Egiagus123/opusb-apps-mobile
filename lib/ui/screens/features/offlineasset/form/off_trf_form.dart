import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
// import 'package:apps_mobile/business_logic/utils/color.dart';
// import 'package:apps_mobile/ui/screens/features/offlineasset/pagesreceiving/1_off_receivinglist.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/pagestrf/1_off_trflist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineAssetTrfForm extends StatefulWidget {
  @override
  State createState() => _OfflineAssetTrfFormState();
}

class _OfflineAssetTrfFormState extends State<OfflineAssetTrfForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AssetTransferReceivingCubit>(
        create: (BuildContext context) => AssetTransferReceivingCubit(),
        child: OfflineTransferList(),
      ),
    );
  }
}
