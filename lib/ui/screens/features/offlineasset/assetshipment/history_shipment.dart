import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/business_logic/localrequirement/querylogic_databasehelper/shipment_querylogic.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/offlineservices/offline_service.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/offline_detail_shipment.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryUpload extends StatefulWidget {
  const HistoryUpload({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryUploadState();
  }
}

class _HistoryUploadState extends State<HistoryUpload> {
  ShipmentQuery dbHelper = ShipmentQuery();
  List<ShipmentOfflineModel> historyshipment = [];
  late DateFormat formateden;
  late bool _showWidget;
  String container = '';

  loadData() async {
    historyshipment = await dbHelper.getAllShipmentObjects();
  }

  @override
  void initState() {
    loadData()
      ..then((_) {
        setState(() {});
      });
    _showWidget = false;
    initializeDateFormatting('id_ID', null);
    formateden = DateFormat('MMM dd, yyyy', 'id_ID');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildbody();
  }

  Widget buildbody() {
    return Column(
      children: [
        animationupdated(),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20),
              Expanded(
                  child: elevatedbutton('Sorting by Container No',
                      'assets/Icons/sorting.png', null, () {
                setState(() {
                  historyshipment = historyshipment
                    ..sort((a, b) => a.container!.compareTo(b.container!));
                });
              })),
              SizedBox(width: 30),
              Expanded(
                  child: elevatedbutton(
                      'Upload to System', 'assets/Icons/upload.png', null,
                      () async {
                List<ShipmentOfflineModel> tempshipment = historyshipment
                    .where((element) => element.status == false)
                    .toList();
                for (var shipmentobject in tempshipment) {
                  bool saved =
                      await sl<OfflineService>().insertShipment(shipmentobject);
                  if (saved == true) {
                    int updated = await dbHelper.updateShipmentObject(
                        shipmentobject.id!,
                        ShipmentOfflineModel(
                            id: shipmentobject.id,
                            container: shipmentobject.container,
                            clientId: shipmentobject.clientId,
                            orgId: shipmentobject.orgId,
                            status: true,
                            qtyentered: shipmentobject.qtyentered,
                            quantity: shipmentobject.quantity,
                            tareweight: shipmentobject.tareweight,
                            weight1: shipmentobject.weight1,
                            shipmentDate: formateden.format(DateTime.now())));
                    if (updated != 0 || updated != null) {
                      setState(() {
                        historyshipment
                            .firstWhere(
                                (element) => element.id == shipmentobject.id)
                            .status = true;
                        historyshipment
                            .firstWhere(
                                (element) => element.id == shipmentobject.id)
                            .shipmentDate = formateden.format(DateTime.now());
                        container = shipmentobject.container.toString();
                        _showWidget = true;
                      });
                    }
                  } else {
                    print('${shipmentobject.container} Failed to upload');
                  }
                }
                if (_showWidget == true) {
                  Future.delayed(const Duration(seconds: 5)).then((value) {
                    setState(() {
                      _showWidget = false;
                    });
                  });
                }
              })),
              SizedBox(width: 20),
            ],
          ),
        ),
        Expanded(child: displaylistshipment()),
        SizedBox(height: 5)
      ],
    );
  }

  Widget animationupdated() {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: _showWidget ? 50 : 0,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: _showWidget
                    ? Icon(
                        Icons.check_circle,
                        color: greeCheckBackgroundUpload,
                        size: 20,
                      )
                    : SizedBox(),
              )),
          Expanded(
            flex: 9,
            child: Text(
              "#$container Uploaded Successfully",
              textAlign: TextAlign.start,
              style: OpusbTheme()
                  .poppinsTextStyle
                  .copyWith(color: greenTextStyleUpload),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: greenBackgroundUpload,
          boxShadow: [
            BoxShadow(
                color: _showWidget ? grayTheme : whiteTheme,
                offset: Offset(0, 2),
                spreadRadius: 1,
                blurRadius: 2)
          ]),
    );
  }

  Widget elevatedbutton(
      String? label, String? imageurl, Icon? icon, Function ontap) {
    return ElevatedButton(
        // onPressed: ontap,
        onPressed: () async {
          await ontap;
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(90, 35)),
          overlayColor: MaterialStateProperty.all(grayTheme),
          backgroundColor: MaterialStateProperty.all(whiteTheme),
          side:
              MaterialStateProperty.all(BorderSide(color: blueTheme, width: 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.asset(
                  imageurl!,
                  color: blueTheme,
                  height: 15,
                  width: 10,
                )),
            SizedBox(width: 10),
            Expanded(
              flex: 9,
              child: Text(
                label!,
                textAlign: TextAlign.center,
                style: OpusbTheme().latoTextStyle.copyWith(
                    fontSize: 12, fontWeight: semiBold, color: blueTheme),
              ),
            )
          ],
        ));
  }

  Widget displaylistshipment() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historyshipment.length,
      itemBuilder: (context, index) {
        return displayshipment(historyshipment[index]);
      },
    );
  }

  Widget displayshipment(ShipmentOfflineModel shipmentOfflineModel) {
    ShipmentOfflineModel tempShipment = shipmentOfflineModel;
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: grayTheme, width: 1),
        color: whiteTheme,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 70,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      '# ${tempShipment.container}',
                      style: OpusbTheme().latoTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                            color: gray3Theme,
                          ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: tempShipment.status == true
                              ? greenUpload
                              : redUpload,
                          width: 1,
                        ),
                        color: tempShipment.status == true
                            ? whiteTheme
                            : beigeTheme,
                      ),
                      child: Text(
                        'Uploaded',
                        style: OpusbTheme().poppinsTextStyle.copyWith(
                            fontSize: 12,
                            color: tempShipment.status == true
                                ? greenUpload
                                : redUpload),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: grayTheme,
              thickness: 1,
            ),
            Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        'Upload : ${tempShipment.shipmentDate!.trim().isEmpty ? '-' : tempShipment.shipmentDate}',
                        style: OpusbTheme()
                            .latoTextStyle
                            .copyWith(fontSize: 12, color: gray3Theme),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => FormTransaction(
                                shipmentOfflineModel: tempShipment,
                                statusShipment: tempShipment.status!,
                                setShipmentObject: (shipmentOfflineModel) {
                                  setState(() {
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .container =
                                        shipmentOfflineModel.container;
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .clientId =
                                        shipmentOfflineModel.clientId;
                                    historyshipment
                                        .firstWhere((element) =>
                                            element.id ==
                                            shipmentOfflineModel.id)
                                        .orgId = shipmentOfflineModel.orgId;
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .qtyentered =
                                        shipmentOfflineModel.qtyentered;
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .quantity =
                                        shipmentOfflineModel.quantity;
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .shipmentDate =
                                        shipmentOfflineModel.shipmentDate;
                                    historyshipment
                                        .firstWhere((element) =>
                                            element.id ==
                                            shipmentOfflineModel.id)
                                        .status = shipmentOfflineModel.status;
                                    historyshipment
                                            .firstWhere((element) =>
                                                element.id ==
                                                shipmentOfflineModel.id)
                                            .tareweight =
                                        shipmentOfflineModel.tareweight;
                                    historyshipment
                                        .firstWhere((element) =>
                                            element.id ==
                                            shipmentOfflineModel.id)
                                        .weight1 = shipmentOfflineModel.weight1;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Details',
                          style: OpusbTheme().poppinsTextStyle.copyWith(
                              fontSize: 10,
                              color: greenUpload,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
