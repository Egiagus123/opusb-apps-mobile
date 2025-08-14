import 'package:apps_mobile/business_logic/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/approval/approval_service.dart';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

part 'approval_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  final log = getLogger('ApprovalCubit');

  ApprovalCubit() : super(ApprovalInitial());

  Future<void> getApprovalList() async {
    log.i('getApprovalList');
    try {
      //  emit(ApprovalGetListInProgress());
      List<ApprovalDoc> approvalDocs =
          await sl<ApprovalService>().getApprovalDocs(Context().userId);

      emit(ApprovalGetListSuccess(approvalDocs: approvalDocs, userData: []));
    } catch (e) {
      log.e('getApprovalList error: $e');
      emit(ApprovalFailure(message: 'Failed to get approval list'));
    }
  }

  Future<void> getPrintFormat(ApprovalDoc approvalDoc) async {
    log.i('getPrintFormat($approvalDoc)');
    try {
      emit(ApprovalGetPrintFormatInProgress());
      final String path =
          await sl<ApprovalService>().getPrintFormatPath(approvalDoc);
      emit(ApprovalGetPrintFormatSuccess(
          printFormatPath: path, approvalDoc: approvalDoc));
    } catch (e) {
      log.e('getPrintFormat error: $e');
      emit(ApprovalFailure(message: 'Failed to get print format'));
    }
  }

  Future<void> getAttachment(ApprovalDoc approvalDoc) async {
    log.i('getPrintFormat($approvalDoc)');
    try {
      emit(ApprovalGetAttchProcessInProgress());
      print(ApprovalGetAttchProcessInProgress);
      final String path =
          await sl<ApprovalService>().getAttachmentPath(approvalDoc);
      emit(ApprovalGetAttachSuccess(
          printFormatPath: path, approvalDoc: approvalDoc));
      print(ApprovalGetAttachSuccess);
    } catch (e) {
      log.e('getPrintFormat error: $e');
      emit(ApprovalFailure(message: 'No attachment available'));
    }
  }

  Future<void> processApproval({
    required int approvalId,
    required bool isApproved,
    required String msg,
  }) async {
    log.i('processApproval(approvalId=$approvalId, msg=$msg)');
    try {
      emit(ApprovalProcessInProgress());
      await sl<ApprovalService>().processApprovalDocs(
        approvalId,
        isApproved,
        Context().userId,
        msg,
      );
      emit(ApprovalProcessSuccess(
          message: isApproved ? 'Approved' : 'Rejected'));
    } catch (e) {
      log.e('processApproval error: $e');
      emit(ApprovalFailure(message: 'Failed to process approval'));
    }
  }
}
