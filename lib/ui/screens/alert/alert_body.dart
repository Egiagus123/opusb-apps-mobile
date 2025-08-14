import 'package:apps_mobile/business_logic/cubit/inventory/alert_note_cubit.dart';
import 'package:apps_mobile/business_logic/models/inventory/alert_note.dart';
import 'package:apps_mobile/ui/widgets/loading_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/ui/widgets/empty_data.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:open_filex/open_filex.dart';

class AlertBody extends StatefulWidget {
  @override
  _AlertBodyState createState() => _AlertBodyState();
}

class _AlertBodyState extends State<AlertBody> {
  List<AlertNote> _alertNotes = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlertNoteCubit>(context).getAlertNotes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertNoteCubit, AlertNoteState>(
      builder: (context, state) {
        if (state is AlertNoteInitial) {
          return Container();
        } else if (state is AlertNoteGetListInProgress) {
          return LoadingIndicator();
        } else if (state is AlertNoteGetListSuccess) {
          _alertNotes = state.alertNotes;
          if (_alertNotes.isEmpty) {
            return EmptyData();
          } else {
            return _buildData(context, _alertNotes);
          }
        } else {
          if (_alertNotes.isEmpty) {
            return EmptyData();
          } else {
            return _buildData(context, _alertNotes);
          }
        }
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        if (state is AlertNoteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${state.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        } else if (state is AlertNoteGetAttachmentInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loading attachment...'),
            ),
          );
        } else if (state is AlertNoteGetAttachmentSuccess) {
          OpenFilex.open(state.attachment.path);
        }
      },
    );
  }

  Widget _buildData(BuildContext context, List<AlertNote> alertNotes) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () async {
        await BlocProvider.of<AlertNoteCubit>(context).getAlertNotes();
      },
      child: ListView.separated(
          itemBuilder: (context, i) => ListTile(
                // tileColor: i < 3
                //     ? Theme.of(context).hoverColor
                //     : Theme.of(context).canvasColor,
                isThreeLine: true,
                title: Text(alertNotes[i].alertSubject),
                subtitle: Text(alertNotes[i].alertMessage),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(timeago.format(alertNotes[i].updated)),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          EvaIcons.attach,
                        ),
                        onPressed: () {
                          BlocProvider.of<AlertNoteCubit>(context)
                              .getAttachment(alertNotes[i].note.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
          separatorBuilder: (context, i) => Divider(
                height: 3,
              ),
          itemCount: alertNotes.length),
    );
  }
}
