part of 'alert_note_cubit.dart';

abstract class AlertNoteState extends Equatable {
  const AlertNoteState();

  @override
  List<Object> get props => [];
}

class AlertNoteInitial extends AlertNoteState {}

class AlertNoteGetListInProgress extends AlertNoteState {}

class AlertNoteGetListSuccess extends AlertNoteState {
  final List<AlertNote> alertNotes;

  AlertNoteGetListSuccess({required this.alertNotes});

  @override
  List<Object> get props => [alertNotes];
}

class AlertNoteGetAttachmentInProgress extends AlertNoteState {}

class AlertNoteGetAttachmentSuccess extends AlertNoteState {
  final File attachment;

  AlertNoteGetAttachmentSuccess({required this.attachment});

  @override
  List<Object> get props => [attachment];
}

class AlertNoteFailure extends AlertNoteState {
  final String message;

  AlertNoteFailure({required this.message});

  @override
  List<Object> get props => [message];
}
