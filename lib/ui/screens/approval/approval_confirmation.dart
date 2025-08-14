import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:flutter/material.dart';

class ApprovalConfirmation extends StatelessWidget {
  final ApprovalCubit? approvalCubit;
  final ApprovalDoc? approvalDoc;
  final bool? isApprove;
  final _messageController = TextEditingController();

  ApprovalConfirmation(
      {Key? key,
      @required this.approvalCubit,
      @required this.approvalDoc,
      @required this.isApprove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isApprove!
          ? 'Approve ${approvalDoc!.documentNo}'
          : 'Reject ${approvalDoc!.documentNo}'),
      content: TextField(
        controller: _messageController,
        decoration: InputDecoration(hintText: 'Add optional message'),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(isApprove! ? 'Approve' : 'Reject'),
          onPressed: () {
            approvalCubit!.processApproval(
                approvalId: approvalDoc!.id,
                isApproved: isApprove!,
                msg: _messageController.text);
            _messageController.clear();
            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          child: Text('Cancel'),
          onPressed: () {
            _messageController.clear();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
