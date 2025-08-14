import 'dart:io';
import 'package:apps_mobile/business_logic/models/inventory/alert_note.dart';

abstract class AlertNoteService {
  Future<List<AlertNote>> getAlertNotes(int userId);
  Future<File> getAttachment(int noteId);
}
