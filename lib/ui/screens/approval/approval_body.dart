import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/models/inventory/approval_doc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/component/color.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/home/app_drawer.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/ui/widgets/empty_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../widgets/loading_indicator.dart';
import 'approval_confirmation.dart';
import 'approval_detail_screen.dart';

class ApprovalBody extends StatefulWidget {
  @override
  _ApprovalBodyState createState() => _ApprovalBodyState();
}

class _ApprovalBodyState extends State<ApprovalBody> {
  late ApprovalCubit approvalCubit;
  List<ApprovalDoc> _approvalDocs = [];
  DateTime notifLastChecked = DateTime.now();
  @override
  void initState() {
    super.initState();
    approvalCubit = BlocProvider.of<ApprovalCubit>(context);
    approvalCubit.getApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovalCubit, ApprovalState>(
      builder: (context, state) {
        if (state is ApprovalInitial) {
          return Container();
        } else if (state is ApprovalGetListInProgress) {
          return LoadingIndicator();
        } else if (state is ApprovalGetListSuccess) {
          _approvalDocs = state.approvalDocs;
          if (_approvalDocs.isEmpty) {
            return EmptyData();
          } else {
            sl<SharedPreferences>()
                .setString(Keys.notifLastChecked, notifLastChecked.toString());
            return _buildData(context, _approvalDocs);
          }
        } else {
          if (_approvalDocs.isEmpty) {
            return EmptyData();
          } else {
            return _buildData(context, _approvalDocs);
          }
        }
      },
      listener: (context, state) {
        // Scaffold.of(context).removeCurrentSnackBar();
        if (state is ApprovalFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${state.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        } else if (state is ApprovalProcessInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Processing...'),
            ),
          );
        } else if (state is ApprovalProcessSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          approvalCubit.getApprovalList();
        } else if (state is ApprovalGetPrintFormatInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loading...'),
            ),
          );
        } else if (state is ApprovalGetPrintFormatSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ApprovalDetailScreen(
                        approvalDoc: state.approvalDoc,
                        printFormatPath: state.printFormatPath,
                      )));
        } else if (state is ApprovalGetListSuccess) {
          _approvalDocs = state.approvalDocs;
          if (Context().recordId > 0 && Context().tableId > 0) {
            List<ApprovalDoc> docs = state.approvalDocs
                .where((e) =>
                    e.recordID == Context().recordId &&
                    e.tableID == Context().tableId)
                .toList();
            if (docs.isNotEmpty) {
              Context().recordId = 0;
              Context().tableId = 0;
              _openDetail(docs.first);
            }
          }
        }
      },
    );
  }

  void backButtonDrawer() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => buildAlertDialog(ctx,
            title: 'Warning',
            content: 'Do you really want to exit?',
            cancelText: 'No',
            cancelCallback: () {
              Navigator.of(ctx).pop(false);
            },
            proceedText: 'Yes',
            proceedCallback: () {
              Navigator.pop(ctx, true);
              Navigator.pop(ctx, true);
            }));
  }

  Widget _buildData(BuildContext context, List<ApprovalDoc> approvalDocs) {
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: AppBar(
        leadingWidth: 100,
        title: Text(
          'Approval',
          style: TextStyle(
              fontFamily: 'Oswald',
              letterSpacing: 1,
              color: Theme.of(context).primaryColor),
        ),
        automaticallyImplyLeading: true,
        leading: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => backButtonDrawer(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        shadowColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: purewhiteTheme),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.expand(height: 0),
          ),
          preferredSize: Size(1, 1),
        ),
        bottomOpacity: 0,
        elevation: 0.0,
      ),
      drawer: AppDrawer(
        updateTabFunction: _switchTab,
      ),
      extendBodyBehindAppBar: false,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          await approvalCubit.getApprovalList();
        },
        child: GroupedListView<ApprovalDoc, String>(
          physics: AlwaysScrollableScrollPhysics(),
          elements: approvalDocs,
          separator: Divider(
            height: 3,
          ),
          groupBy: (approvalDoc) => approvalDoc.approvalType,
          groupSeparatorBuilder: (String groupByValue) {
            return Card(
              child: ListTile(
                leading: Icon(EvaIcons.fileTextOutline),
                title: Text(
                  groupByValue,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  approvalDocs
                      .where((e) => e.approvalType == groupByValue)
                      .toList()
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          itemBuilder: (context, ApprovalDoc approvalDoc) =>
              _buildTile(context, approvalDoc),
          order: GroupedListOrder.ASC,
        ),
      ),
    );
  }

  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTile(BuildContext context, ApprovalDoc approvalDoc) {
    return Slidable(
      key: ValueKey(approvalDoc.documentNo),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _displayProcessDialog(context, approvalDoc, true);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: EvaIcons.checkmark,
            label: 'Approve',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _displayProcessDialog(context, approvalDoc, false);
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: EvaIcons.close,
            label: 'Reject',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _openDetail(approvalDoc);
        },
        child: ListTile(
          title: Text(
            approvalDoc.documentNo,
            style: const TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            approvalDoc.bp,
            style: const TextStyle(fontFamily: 'Montserrat'),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.simpleCurrency(
                  locale: 'in_ID',
                  name: approvalDoc.currency,
                  decimalDigits: 0,
                ).format(approvalDoc.amount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                timeago.format(approvalDoc.created),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'Montserrat',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayProcessDialog(
    BuildContext context,
    ApprovalDoc approvalDoc,
    bool isApprove,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ApprovalConfirmation(
              approvalCubit: approvalCubit,
              approvalDoc: approvalDoc,
              isApprove: isApprove);
        });
  }

  void _openDetail(ApprovalDoc approvalDoc) async {
    await approvalCubit.getPrintFormat(approvalDoc);
  }
}
