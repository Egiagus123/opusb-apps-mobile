import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'approval_detail_body.dart';

class ApprovalDetailScreen extends StatelessWidget {
  static String routeName = "/approval-detail";

  final ApprovalDoc? approvalDoc;
  final String? printFormatPath;

  const ApprovalDetailScreen({Key? key, this.approvalDoc, this.printFormatPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ApprovalDoc approvalDoc = ModalRoute.of(context).settings.arguments;
    print('approval detail screen build');
    return Scaffold(
      body: BlocProvider(
        create: (context) => ApprovalCubit(),
        child: ApprovalDetailBody(
          approvalDoc: approvalDoc!,
          printFormatPath: printFormatPath!,
        ),
      ),
    );
  }
}
