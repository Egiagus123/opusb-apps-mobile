import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/update_shipment.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTransaction extends StatefulWidget {
  const FormTransaction(
      {Key? key,
      required this.shipmentOfflineModel,
      required this.statusShipment,
      required this.setShipmentObject})
      : super(key: key);
  final ShipmentOfflineModel shipmentOfflineModel;
  final bool statusShipment;
  final void Function(ShipmentOfflineModel shipmentOfflineModel)
      setShipmentObject;

  @override
  State<StatefulWidget> createState() {
    return _FormTransactionState();
  }
}

class _FormTransactionState extends State<FormTransaction> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 70,
        centerTitle: true,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Builder(
          builder: (context) => Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                    flex: 7,
                    child: InkWell(
                      onTap: () {
                        backButtonDrawer();
                      },
                      overlayColor: MaterialStateProperty.all(blueTheme),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: whiteTheme,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                              width: 1,
                              color: whiteTheme,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: blueTheme,
                            size: 25,
                          ),
                        ),
                      ),
                    )),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          ),
        ),
        title: Container(
          child: Text('Container Details',
              style: OpusbTheme().latoTextStyle.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 18, color: blueTheme)),
        ),
        backgroundColor: whiteTheme,
      ),
      body: buildBodyNew(),
    );
  }

  Widget buildBodyNew() {
    return Container(
        color: whiteTheme,
        child: UpdateShipment(
          shipmentOfflineModel: widget.shipmentOfflineModel,
          statusShipment: widget.statusShipment,
          setShipmentObject: (shipmentOfflineModel) {
            setState(() {
              widget.setShipmentObject(shipmentOfflineModel!);
            });
          },
        ));
  }
}
