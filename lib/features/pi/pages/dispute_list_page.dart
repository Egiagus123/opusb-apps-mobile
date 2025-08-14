import 'package:flutter/material.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/features/core/base/utils/formatter.dart';
import 'package:apps_mobile/features/core/base/widgets/error_handler.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/base/widgets/message_util.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../states/dispute_list_store.dart';
import 'line_form_page.dart';

class DisputeListPage extends StatefulWidget {
  final PhysicalInventory? inventory;

  const DisputeListPage({Key? key, this.inventory}) : super(key: key);
  @override
  DisputeListPageState createState() => DisputeListPageState();
}

class DisputeListPageState extends State<DisputeListPage> {
  final log = getLogger('DisputeListPage');

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16),
      child: StateBuilder<DisputeListStore>(
        // models: [Injector.getAsReactive<DisputeListStore>()],
        // tag: hashCode,
        initState: (context, reactiveModel) {
          reactiveModel!.setState((store) async {
            await store.init(widget.inventory!);
          });
        },
        builder: (context, reactiveModel) {
          if (reactiveModel!.isWaiting) return LoadingIndicator();
          log.i('builder');
          return buildPage(context, reactiveModel.state);
        },
      ),
    );
  }

  Widget buildPage(BuildContext context, DisputeListStore state) {
    return Column(
      children: <Widget>[
        if (state.isSearchMode) buildListHeader(state),
        if (state.lines!.isNotEmpty) buildList(context, state),
      ],
    );
  }

  Widget buildListHeader(DisputeListStore state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Text(
              '${state.filteredLines!.length} result[s] found for "${state.query}"'),
          MaterialButton(
            onPressed: clearSearch,
            child: Text('Clear search'),
          )
        ],
      ),
    );
  }

  Widget buildList(BuildContext context, DisputeListStore state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.lines!.length,
        itemBuilder: (context, index) {
          return Dismissible(
              background: Container(color: Colors.redAccent),
              key: Key(state.lines![index].id.toString()),
              onDismissed: (direction) {
                removeItem(context, index);
              },
              confirmDismiss: (DismissDirection direction) async {
                final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: Text(
                          "Are you sure you wish to remove ${state.lines![index].description}?"),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        MaterialButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Remove")),
                      ],
                    );
                  },
                );
                return res;
              },
              child: buildItem(state.lines![index]));
        },
      ),
    );
  }

  Widget buildItem(PhysicalInventoryLine line) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 70),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LineFormPage(
                        line: line,
                      )),
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
                        line.description ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: 'Montserrat'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        Formatter.formatNumber(line.qtyCount!),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontFamily: 'Montserrat'),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void addItem(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<DisputeListStore>();
    reactiveModel.setState(
      (store) {
        PhysicalInventoryLine line = store.createLine();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LineFormPage(line: line),
          ),
        );
      },
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  void removeItem(BuildContext context, int index) {
    final reactiveModel = Injector.getAsReactive<DisputeListStore>();
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
    final reactiveModel = Injector.getAsReactive<DisputeListStore>();
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
    final reactiveModel = Injector.getAsReactive<DisputeListStore>();
    reactiveModel.setState(
      (store) => store.clearSearch(),
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }
}
