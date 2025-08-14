// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/features/core/base/utils/formatter.dart';
import 'package:apps_mobile/features/core/base/widgets/error_handler.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/base/widgets/message_util.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../models/locator.dart';
import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../states/line_list_store.dart';
import 'line_form_page.dart';

class LineListPage extends StatefulWidget {
  final PhysicalInventory inventory;

  const LineListPage({
    Key? key,
    required this.inventory,
  }) : super(key: key);
  @override
  LineListPageState createState() => LineListPageState();
}

class LineListPageState extends State<LineListPage> {
  final log = getLogger('LineListPage');

  late TextEditingController _barcodeTextController;
  late FocusNode _barcodeFocusNode;
  late ScrollController _scrollController;
  late double _scrollOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      child: StateBuilder<LineListStore>(
        // models: [Injector.getAsReactive<LineListStore>()],
        // tag: hashCode,
        initState: (context, reactiveModel) {
          _barcodeTextController = TextEditingController();
          _barcodeFocusNode = FocusNode();
          _scrollController = new ScrollController();

          reactiveModel!.setState((store) async {
            await store.init(widget.inventory);
          });
        },
        dispose: (context, reactiveModel) {
          _barcodeTextController.dispose();
          _barcodeFocusNode.dispose();
          _scrollController.dispose();
        },
        afterInitialBuild: (context, reactiveModel) {},
        builder: (context, reactiveModel) {
          if (reactiveModel!.isWaiting) return LoadingIndicator();
          log.i('builder');
          return buildPage(context, reactiveModel!.state);
        },
      ),
    );
  }

  Widget buildPage(BuildContext context, LineListStore state) {
    return Column(
      children: <Widget>[
        if (state.locatorList.isNotEmpty) buildListHeader(state),
        if (state.lines!.isNotEmpty) buildList(context, state),
      ],
    );
  }

  Widget buildListHeader(LineListStore state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Locator',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              style: Theme.of(context).textTheme.headlineMedium,
              value: state.selectedLocator!.value,
              disabledHint: Text(state.selectedLocator!.value),
              items: state.locatorList.map((Locator locator) {
                return DropdownMenuItem<String>(
                    value: locator.value,
                    child: Text(locator.value,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)));
              }).toList(),
              onChanged: state.isSearchMode
                  ? null
                  : (value) {
                      if (value != null) setSelectedLocator(value);
                    },
            ),
          ),
          if (!state.isSearchMode!)
            TextField(
              controller: _barcodeTextController,
              focusNode: _barcodeFocusNode,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
              ),
              textInputAction: TextInputAction.go,
              onSubmitted: (value) async {
                await addProduct(context, value);
                _barcodeTextController.clear();
                FocusScope.of(context).requestFocus(_barcodeFocusNode);
              },
            ),
          if (state.isSearchMode)
            Text(
                '${state.filteredLines.length} result[s] found for "${state.query}"'),
          if (state.isSearchMode)
            MaterialButton(
              onPressed: clearSearch,
              child: Text('Clear search'),
            )
        ],
      ),
    );
  }

  Widget buildList(BuildContext context, LineListStore state) {
    final state = Injector.get<LineListStore>();
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.lines!.length,
        itemBuilder: (context, index) {
          // return buildItem(state.lines[index]);
          return Slidable(
            key: ValueKey(state.lines![index]), // wajib untuk pengenalan item
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) async {
                    final bool? isRemove = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: Text(
                              "Are you sure you wish to remove ${state.lines![index].productName}?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Remove"),
                            ),
                          ],
                        );
                      },
                    );
                    if (isRemove ?? false) {
                      removeItem(context, index);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                if (!state.lines![index].isChecked!)
                  SlidableAction(
                    onPressed: (_) {
                      markLine(context, state.lines![index], true);
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check_box,
                    label: 'Check',
                  ),
                if (state.lines![index].isChecked!)
                  SlidableAction(
                    onPressed: (_) {
                      markLine(context, state.lines![index], false);
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.check_box_outline_blank,
                    label: 'UnCheck',
                  ),
              ],
            ),
            child: buildItem(state.lines![index]),
          );
        },
      ),
    );
  }

  Widget buildItem(PhysicalInventoryLine line) {
    return Card(
      color: line.isChecked! ? Color(0xFFB3E5FC) : Colors.white,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      // shape: RoundedRectangleBorder(
      //     side: BorderSide(
      //       color:
      //           line.isChecked ? Theme.of(context).primaryColor : Colors.grey,
      //       width: 3.0,
      //     ),
      //     borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LineFormPage(
                line: line,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      line.upc ?? line.productValue!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatter.formatNumber(line.qtyCount!),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Text(
                      line.productName!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: 'Montserrat',
                          ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${line.uom!.identifier}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: 'Montserrat',
                          ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              if (line.isLot!)
                Row(
                  children: <Widget>[
                    Text(
                      'LotNo: ${line.lot}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: 'Montserrat',
                          ),
                    )
                  ],
                ),
              if (line.isSerNo!)
                Row(
                  children: <Widget>[
                    Text(
                      'SerNo: ${line.serNo}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: 'Montserrat',
                          ),
                    )
                  ],
                ),
              if (line.description != null && line.description!.isNotEmpty)
                Row(
                  children: <Widget>[
                    Text(
                      '${line.description}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: 'Montserrat',
                          ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedLocator(String uid) {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) => store.setSelectedLocator(uid),
      // onError: ErrorHandler.showSnackBar,
    );
  }

  static Future<void> addProduct(BuildContext context, String value) async {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) async {
        PhysicalInventoryLine line =
            await store.getOrCreateLineByProduct(value);
        if (line.isValidAsi()) {
          (line.qtyCount ?? 0) + 1;
          await store.mergeLine(line);
        } else {
          (line.qtyCount ?? 0) + 1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LineFormPage(line: line),
            ),
          );
        }
      },
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  void markLine(
    BuildContext context,
    PhysicalInventoryLine line,
    bool isChecked,
  ) {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    _scrollOffset = _scrollController.offset;

    reactiveModel.setState(
      (store) => store.markLine(line, isChecked),
      // onSetState: (context, rm) {
      //   if (_scrollOffset != null && _scrollController.hasClients) {
      //     _scrollController.jumpTo(_scrollOffset!);
      //     _scrollOffset = null;
      //   }
      // },
      // onError: (context, error) => ErrorHandler.showSnackBar(error),
      // watch: () => [line.id], // optional, for fine-grained rebuilds
    );
  }

  void removeItem(BuildContext context, int index) {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) async {
        await store.removeItem(index);
        // if (success) MessageUtil.showSnackBar(context, 'Removed');
      },
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  static void searchItem(BuildContext context, String query) {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) {
        bool found = store.searchItem(query);
        if (!found)
          MessageUtil.showSnackBar(context, 'No result found for $query');
      },
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  void clearSearch() {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) => store.clearSearch(),
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  static void sort(bool sortAsc) {
    final reactiveModel = Injector.getAsReactive<LineListStore>();
    reactiveModel.setState(
      (store) => store.sort(sortAsc),
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }
}
