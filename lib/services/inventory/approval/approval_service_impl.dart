import 'dart:io';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/services/inventory/approval/approval_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class ApprovalServiceImpl implements ApprovalService {
  final log = getLogger('ApprovalServiceImpl');
  final Dio dio;

  ApprovalServiceImpl({required this.dio});

  @override
  Future<List<ApprovalDoc>> getApprovalDocs(int userId,
      [String? approvalType]) async {
    log.i('getApprovalDocs(userId=$userId, approvalType=$approvalType)');
    List<ApprovalDoc> approvals = [];

    String query = "filter=AD_User_ID=$userId";

    if (approvalType != null) query += " AND nodeName='$approvalType'";

    try {
      final response = await dio.get("/models/bhp_rv_approval?$query");
      if (response.statusCode == 200) {
        approvals = ApprovalDoc.listFromJson(response.data);
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return approvals;
  }

  @override
  Future<String> getPrintFormatPath(ApprovalDoc approvalDoc) async {
    log.i('getPrintFormatPath($approvalDoc)');
    try {
      Map<String, dynamic> parsedJson = await createDocPdf(approvalDoc);
      if (parsedJson['reportFile'] != null) {
        final String reportFile = parsedJson['reportFile'];
        final int reportFileLength =
            (parsedJson['reportFileLength'] as num).toInt();
        return await downloadFile(reportFile, reportFileLength);
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }

  Future<Map<String, dynamic>> createDocPdf(ApprovalDoc approvalDoc) async {
    log.i('createDocPdf($approvalDoc)');
    try {
      final response = await dio.post('/processes/createpdf', data: {
        'AD_Table_ID': approvalDoc.tableID,
        'Record_ID': approvalDoc.recordID,
        'report-type': 'PDF',
      });
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }

  Future<String> downloadFile(String reportFile, int reportFileLength) async {
    log.i(
        'downloadFile(reportFile=$reportFile, reportFileLength=$reportFileLength)');
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$reportFile';

      final response = await dio.download(
          '/files/$reportFile?length=$reportFileLength', filePath,
          options: Options(
              headers: {HttpHeaders.acceptHeader: 'application/octet-stream'}));
      if (response.statusCode == 200) {
        return filePath;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }

  @override
  Future<String> getAttachmentPath(ApprovalDoc approvalDoc) async {
    log.i('getAttachmentPath($approvalDoc)');
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/${approvalDoc.id}.zip';
      final dir = Directory(filePath);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      final response = await dio.download(
          '/models/${approvalDoc.tableName}/${approvalDoc.recordID}/attachments/zip',
          filePath,
          options: Options(
              headers: {HttpHeaders.acceptHeader: 'application/octet-stream'}));
      if (response.statusCode == 200) {
        return filePath;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }

  @override
  Future<String> processApprovalDocs(
      int approvalId, bool isApproved, int userId, String msg) async {
    log.i(
        'processApprovalDocs(approvalId=$approvalId, isApproved=$isApproved, userId=$userId, msg=$msg)');
    try {
      final String isApprovedStr = isApproved ? 'Y' : 'N';
      final response = await dio.post('/processes/approveactivity', data: {
        'AD_WF_Activity_ID': approvalId,
        'AD_User_ID': userId,
        'isApproved': isApprovedStr,
        'textMsg': msg,
      });
      if (response.statusCode == 200) {
        return '';
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }
}
