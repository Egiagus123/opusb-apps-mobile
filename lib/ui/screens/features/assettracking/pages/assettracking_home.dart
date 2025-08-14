import 'package:apps_mobile/business_logic/cubit/asset_tracking_cubit.dart';
import 'package:apps_mobile/business_logic/models/assettrackingloc_model.dart';
import 'package:apps_mobile/business_logic/models/assettrackingstatus_model.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assetcart_page.dart';

class AssetTrackingHome extends StatefulWidget {
  @override
  _AssetTrackingHomeState createState() => _AssetTrackingHomeState();
}

class _AssetTrackingHomeState extends State<AssetTrackingHome> {
  final log = getLogger('AssetTrackingHome');

  TextEditingController _sernoTextController = TextEditingController();
  var loc;
  var stat;
  var serno;
  late AssetTrackingCubit assetTrackingCubit;
  List<AssetTrackingLocation> loadLocation = [];
  List<AssetTrackingStatus> loadStatus = [];
  late int _locationValue;

  @override
  void initState() {
    super.initState();
    loadinitData();
  }

  @override
  void dispose() {
    _sernoTextController.dispose();
    super.dispose();
  }

  Future<String> loadinitData() async {
    assetTrackingCubit = BlocProvider.of<AssetTrackingCubit>(context);
    await assetTrackingCubit.getLocation();
    return 'success';
  }

  List<DropdownMenuItem> _buildLocation(
      BuildContext context, List<AssetTrackingLocation> loc) {
    return loc
        .map((loc) => DropdownMenuItem(
              value: loc.id,
              child: Text(
                loc.value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildStatus(
      BuildContext context, List<AssetTrackingStatus> status) {
    return status
        .map((status) => DropdownMenuItem(
              value: status.value,
              child: Text(
                status.status.identifier!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetTrackingCubit, AssetTrackingState>(
      builder: (context, state) {
        if (state is AssetTrackingLoadInitial) {
          this.loadLocation = state.loc;
          this.loadStatus = state.status;

          if (loadLocation.isNotEmpty) {
            _locationValue = loadLocation[0].id;
          }
          return _buildBody(context);
        } else {
          return _buildBody(context);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 20),
                  InkWell(
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                    onTap: () => backButtonDrawer(),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
          title: Text(
            'Asset Tracking',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Container(padding: EdgeInsets.all(16), child: buildPage()),
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

  Widget buildPage() {
    return ListView(
      children: <Widget>[buildDetails()],
    );
  }

  Widget buildDetails() {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('Serial No.',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
        subtitle: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Container(
            height: 45,
            child: TextField(
              controller: _sernoTextController,
              onChanged: (value) {
                setState(() {
                  serno = value;
                });
              },
              style: TextStyle(fontFamily: 'Montserrat'),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                setState(() {
                  serno = value;
                });
              },
            ),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 45,
              icon: Icon(Icons.qr_code_scanner,
                  color: Theme.of(context).primaryColor),
              onPressed: () async {
                String? barcodeScanRes = await scanBarcode(
                    context); // Menggunakan scanBarcode(context)

                if (barcodeScanRes != 'Cancelled') {
                  // Memastikan hasil scan bukan 'Cancelled'
                  setState(() {
                    _sernoTextController.text = barcodeScanRes!;
                    serno = barcodeScanRes;
                    FocusScope.of(context).unfocus(); // Menyembunyikan keyboard
                  });
                }
              },
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('Location',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
        subtitle: Container(
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: loc,
              items: _buildLocation(context, loadLocation),
              hint: Text('Choose',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
              onChanged: (changedValue) {
                setState(() {
                  loc = changedValue;
                });
              },
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('Asset Status',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
        subtitle: Container(
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: stat,
              items: _buildStatus(context, loadStatus),
              hint: Text('Choose',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13)),
              onChanged: (changedValue) {
                setState(() {
                  stat = changedValue;
                });
              },
            ),
          ),
        ),
      ),
      SizedBox(height: 400),
      Row(
        children: [
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: clear,
                child: Text(
                  'Reset',
                  style: TextStyle(
                      fontFamily: 'Oswald',
                      letterSpacing: 1,
                      color: Theme.of(context).primaryColor),
                ),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<AssetTrackingCubit>(
                        create: (BuildContext context) => AssetTrackingCubit(),
                        child: AssetCartPage(
                          serno ?? "",
                          stat ?? "",
                          loc ?? 0,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Search Equipment',
                  style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  void clear() {
    setState(() {
      this.loc = null;
      this.stat = null;
      this.serno = null;
      _sernoTextController.clear();
    });
  }
}
