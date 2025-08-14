import 'dart:io';

import 'package:apps_mobile/business_logic/models/inventory/alert_note.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/services/inventory/alert_note/alert_note_service.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class AlertNoteServiceImpl implements AlertNoteService {
  final log = getLogger('AlertNoteServiceImpl');
  final Dio dio;

  AlertNoteServiceImpl({required this.dio});

  @override
  Future<List<AlertNote>> getAlertNotes(int userId) async {
    log.i('getAlertNotes($userId)');
    List<AlertNote> alertNotes = <AlertNote>[];
    try {
      final response = await dio.get(
          "/models/bhp_mv_alertnote?filter=AD_User_ID=$userId AND Processed='N'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AlertNote> list = data.map((i) => AlertNote.fromJson(i)).toList();
        alertNotes = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(alertNotes);
    return alertNotes;
  }

  // @override
  // Future<File> getAttachment(int noteId) async {
  //   log.i('getAttachment($noteId)');
  //   File attachment;
  //   try {
  //     String url =
  //         "${dio.options.baseUrl}/models/ad_note/$noteId/attachments/zip";
  //     String token = Context().token;
  //     attachment = await DefaultCacheManager().getSingleFile(url, headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/octet-stream',
  //       'Authorization': 'Bearer $token',
  //     });
  //   } on DioError catch (e) {
  //     throw e.error;
  //   }
  //   log.d(attachment);
  //   return attachment;
  // }

  @override
  Future<File> getAttachment(int noteId) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$noteId.zip';

      final response = await dio.download(
          '/models/ad_note/$noteId/attachments/zip', filePath,
          options: Options(
              headers: {HttpHeaders.acceptHeader: 'application/octet-stream'}));
      if (response.statusCode == 200) {
        final bytes = File(filePath).readAsBytesSync();
        final archive = ZipDecoder().decodeBytes(bytes);
        File? extractedFile;
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            extractedFile = File('${tempDir.path}/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('${tempDir.path}/$filename')..create(recursive: true);
          }
        }
        return extractedFile!;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    throw Exception;
  }
}
