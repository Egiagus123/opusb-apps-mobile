import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wrapper client agar authHeaders otomatis ikut di setiap request
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _base = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _base.send(request..headers.addAll(_headers));
  }

  @override
  void close() => _base.close();
}

class ChatService {
  // -------------------------- OpenRouter / LLM -------------------------- //
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://openrouter.ai/api/v1',
      headers: {
        'Authorization':
            'Bearer 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',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static const String _model = 'openai/gpt-3.5-turbo';

  Future<String> sendPrompt(String prompt) async {
    try {
      final res = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
        },
      );
      return res.data['choices'][0]['message']['content'] as String;
    } on DioException catch (e) {
      throw Exception(
          'API Error – ${e.response?.statusCode}: ${e.response?.data}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> sendPromptWithFile({
    required String prompt,
    required PlatformFile file,
  }) async {
    final fileContent = await _readFileContent(file);
    final rows = const CsvToListConverter().convert(fileContent);

    // Batasi ke header + 1 baris data
    final limitedRows = [rows.first];
    if (rows.length > 1) limitedRows.add(rows[1]);
    final trimmedContent = limitedRows.map((r) => r.join(',')).join('\n');

    final combinedPrompt = """
$prompt

Berikut ini adalah isi file (hanya sebagian kecil):

--- File: ${file.name} ---
$trimmedContent
""";

    return sendPrompt(combinedPrompt);
  }

  Future<String> _readFileContent(PlatformFile file) async {
    if (file.bytes == null) throw Exception('File kosong');
    final ext = file.extension?.toLowerCase();

    if (ext == 'csv') {
      return String.fromCharCodes(file.bytes!);
    }

    return String.fromCharCodes(file.bytes!);
  }

  // -------------------------- Permission -------------------------- //
  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) status = await Permission.storage.request();
    return status.isGranted;
  }

  // -------------------------- Google Sheets Upload -------------------------- //
  Future<String> uploadCsvToGoogleSheets(
    String sheetTitle,
    String csvContent,
  ) async {
    try {
      final signIn = GoogleSignIn(
        clientId:
            '950162351581-erqija0uktpnp3q9t2qn84r60sn2dohg.apps.googleusercontent.com',
        scopes: [
          'email',
          'profile',
          drive.DriveApi.driveFileScope,
          sheets.SheetsApi.spreadsheetsScope,
        ],
      );

      await signIn.signOut(); // force fresh session
      final account = await signIn.signIn();
      if (account == null) throw Exception('Google Sign-In was canceled');

      final authHeaders = await account.authHeaders;
      final client = _GoogleAuthClient(authHeaders);

      final driveApi = drive.DriveApi(client);
      final createdFile = await driveApi.files.create(
        drive.File()
          ..name = sheetTitle
          ..mimeType = 'application/vnd.google-apps.spreadsheet',
      );

      if (createdFile.id == null)
        throw Exception('Failed to create spreadsheet');
      final sheetId = createdFile.id!;

      final rows = const CsvToListConverter().convert(csvContent);

      final sheetsApi = sheets.SheetsApi(client);
      await sheetsApi.spreadsheets.values.update(
        sheets.ValueRange()
          ..majorDimension = 'ROWS'
          ..values = rows,
        sheetId,
        'Sheet1!A1',
        valueInputOption: 'RAW',
      );

      await sheetsApi.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest.fromJson({
          'requests': [
            {
              'updateDimensionProperties': {
                'range': {
                  'sheetId': 0, // default sheetId is usually 0
                  'dimension': 'COLUMNS',
                  'startIndex': 0,
                  'endIndex': 4,
                },
                'properties': {'pixelSize': 100},
                'fields': 'pixelSize',
              },
            },
          ],
        }),
        sheetId,
      );

      return 'https://docs.google.com/spreadsheets/d/$sheetId';
    } catch (e) {
      if (e is drive.DetailedApiRequestError) {
        throw Exception('Google API Error: ${e.message}');
      }
      rethrow;
    }
  }

  // -------------------------- Simpan CSV Lokal (Opsional) -------------------------- //
  Future<String> saveCsvLocally(String fileName, String content) async {
    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$fileName');
    await file.writeAsString(content);
    return file.path;
  }
}
