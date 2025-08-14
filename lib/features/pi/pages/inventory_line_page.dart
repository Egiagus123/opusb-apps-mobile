import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';

import '../models/physical_inventory.dart';
import 'dispute_list_page.dart';
import 'line_list_page.dart';
import 'line_list_search_page.dart';

class InventoryLinePage extends StatefulWidget {
  final PhysicalInventory? inventory;

  const InventoryLinePage({Key? key, this.inventory}) : super(key: key);

  @override
  _InventoryLinePageState createState() => _InventoryLinePageState();
}

class _InventoryLinePageState extends State<InventoryLinePage> {
  int _selectedIndex = 0; // default to line list
  bool get isDispute => _selectedIndex == 1;
  List<Widget> _body = <Widget>[];
  bool _sortAsc = true;

  @override
  void initState() {
    super.initState();
    _body = [
      LineListPage(inventory: widget.inventory!),
      DisputeListPage(inventory: widget.inventory),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        title: Text(
          'Inventory Count',
          style: TextStyle(
              fontFamily: 'Oswald', letterSpacing: 1, color: purewhiteTheme),
        ),
        actions: <Widget>[
          if (!isDispute)
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  _sortAsc
                      ? FontAwesomeIcons.sortAlphaDown
                      : FontAwesomeIcons.sortAlphaDownAlt,
                  color: purewhiteTheme,
                ),
                onPressed: () {
                  LineListPageState.sort(!_sortAsc);
                  setState(() {
                    _sortAsc = !_sortAsc;
                  });
                },
              );
            }),
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.search,
                color: purewhiteTheme,
              ),
              onPressed: () async {
                String? query = await showSearch(
                  context: context,
                  delegate: LineListSearchPage(),
                );
                if (query != null) {
                  if (isDispute) {
                    DisputeListPageState.searchItem(context, query);
                  } else {
                    LineListPageState.searchItem(context, query);
                  }
                }
              },
            );
          }),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _body[_selectedIndex],
      floatingActionButton: Builder(
        builder: (BuildContext context) => FloatingActionButton(
          onPressed: () async {
            if (isDispute) {
              DisputeListPageState.addItem(context);
            } else {
              // Mendapatkan hasil pemindaian barcode dengan scanBarcode(context)
              String? barcodeScanRes = await scanBarcode(context);

              // Memeriksa apakah pemindaian dibatalkan atau gagal
              if (barcodeScanRes != null && barcodeScanRes != 'Cancelled') {
                // Jika pemindaian berhasil, lanjutkan untuk menambahkan produk
                await LineListPageState.addProduct(context, barcodeScanRes);
              } else {
                // Penanganan jika pemindaian dibatalkan atau gagal
                print('Scan was cancelled or failed');
              }
            }
          },
          child: Icon(
            isDispute ? Icons.add : FontAwesomeIcons.qrcode,
            color: purewhiteTheme,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.question),
            label: 'In Dispute',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });
          _sortAsc = true;
        },
      ),
    );
  }
}
