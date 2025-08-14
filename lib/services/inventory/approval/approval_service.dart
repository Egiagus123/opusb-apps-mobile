import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';

abstract class ApprovalService {
  Future<List<ApprovalDoc>> getApprovalDocs(int userID, [String approvalType]);
  Future<String> getPrintFormatPath(ApprovalDoc approvalDoc);
  Future<String> getAttachmentPath(ApprovalDoc approvalDoc);
  Future<String> processApprovalDocs(
    int approvalId,
    bool isApproved,
    int userID,
    String msg,
  );
}
