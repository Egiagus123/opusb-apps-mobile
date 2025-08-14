import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/alert_note/alert_note_service.dart';
import 'package:apps_mobile/business_logic/models/inventory/alert_note.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

part 'alert_note_state.dart';

class AlertNoteCubit extends Cubit<AlertNoteState> {
  final log = getLogger('AlertNoteCubit');

  AlertNoteCubit() : super(AlertNoteInitial());

  Future<void> getAlertNotes() async {
    log.i('getAlertNotes');
    try {
      emit(AlertNoteGetListInProgress());
      List<AlertNote> alertNotes =
          await sl<AlertNoteService>().getAlertNotes(Context().userId);
      emit(AlertNoteGetListSuccess(alertNotes: alertNotes));
    } catch (e) {
      log.e('getAlertNotes error: $e');
      emit(AlertNoteFailure(message: 'Failed to get alert notes'));
    }
  }

  Future<void> getAttachment(int noteId) async {
    log.i('getAttachment');
    try {
      emit(AlertNoteGetAttachmentInProgress());
      File attachment = await sl<AlertNoteService>().getAttachment(noteId);
      emit(AlertNoteGetAttachmentSuccess(attachment: attachment));
    } catch (e) {
      log.e('getAttachment error: $e');
      emit(AlertNoteFailure(message: 'Failed to get attachment'));
    }
  }
}
