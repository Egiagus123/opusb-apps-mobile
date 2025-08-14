import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/business_logic/localrequirement/querylogic_databasehelper/shipment_querylogic.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateShipment extends StatefulWidget {
  const UpdateShipment(
      {Key? key,
      required this.shipmentOfflineModel,
      required this.statusShipment,
      required this.setShipmentObject})
      : super(key: key);
  final ShipmentOfflineModel? shipmentOfflineModel;
  final bool? statusShipment;
  final void Function(ShipmentOfflineModel? shipmentOfflineModel)
      setShipmentObject;

  @override
  State<StatefulWidget> createState() {
    return _UpdateShipmentState();
  }
}

class _UpdateShipmentState extends State<UpdateShipment> {
  ShipmentQuery dbHelper = ShipmentQuery();
  TextEditingController textcontrollercontainer = TextEditingController();
  TextEditingController textcontrollergrossweight = TextEditingController();
  TextEditingController textcontrolleremptyweight = TextEditingController();
  TextEditingController textcontrollertareweight = TextEditingController();
  TextEditingController textcontrollernettweight = TextEditingController();
  FocusNode nodecontainer = FocusNode();
  FocusNode nodegrossweigth = FocusNode();
  FocusNode nodetareweigth = FocusNode();
  FocusNode nodenettweigth = FocusNode();
  FocusNode nodeemptyweigth = FocusNode();
  double netweight = 0;
  double grossweight = 0;
  double tareweight = 0;
  double emptyweight = 0;

  @override
  void initState() {
    nodecontainer.requestFocus();
    setfirstdata();
    super.initState();
  }

  // @override
  // void dispose() {
  //   // nodecontainer.removeListener(() { })
  //   nodecontainer.dispose();
  //   nodeemptyweigth.dispose();
  //   nodegrossweigth.dispose();
  //   nodenettweigth.dispose();
  //   nodetareweigth.dispose();
  //   textcontrollercontainer.dispose();
  //   textcontrolleremptyweight.dispose();
  //   textcontrollergrossweight.dispose();
  //   textcontrollernettweight.dispose();
  //   textcontrollertareweight.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return buildbody();
  }

  Widget buildbody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              buildfield(
                  'Container',
                  textcontrollercontainer,
                  nodecontainer,
                  widget.statusShipment == true ? true : false,
                  TextInputType.text, () {
                FocusScope.of(context).requestFocus(nodegrossweigth);
              }, (value) => ''),
              SizedBox(height: 10),
              buildfield(
                'Gross Weight',
                textcontrollergrossweight,
                nodegrossweigth,
                widget.statusShipment == true ? true : false,
                TextInputType.numberWithOptions(decimal: true),
                () {
                  FocusScope.of(context).requestFocus(nodeemptyweigth);
                },
                (value) {
                  setState(() {
                    if (textcontrollergrossweight.text.isNotEmpty) {
                      grossweight = double.tryParse(
                          textcontrollergrossweight.text.replaceAll(',', ''))!;
                    } else {
                      grossweight = 0;
                    }
                    netweight = grossweight - emptyweight;
                    textcontrollernettweight.text = netweight.toString();
                  });
                },
              ),
              SizedBox(height: 10),
              buildfield(
                'Empty Weight',
                textcontrolleremptyweight,
                nodeemptyweigth,
                widget.statusShipment == true ? true : false,
                TextInputType.numberWithOptions(decimal: true),
                () {
                  FocusScope.of(context).requestFocus(nodetareweigth);
                },
                (value) {
                  setState(() {
                    if (textcontrolleremptyweight.text.isNotEmpty) {
                      emptyweight = double.tryParse(
                          textcontrolleremptyweight.text.replaceAll(',', ''))!;
                    } else {
                      emptyweight = 0;
                    }
                    netweight = grossweight - emptyweight;
                    textcontrollernettweight.text = netweight.toString();
                  });
                },
              ),
              SizedBox(height: 10),
              buildfield(
                  'Tare Weight',
                  textcontrollertareweight,
                  nodetareweigth,
                  widget.statusShipment == true ? true : false,
                  TextInputType.numberWithOptions(decimal: true), () {
                FocusScope.of(context).requestFocus(nodenettweigth);
              }, (value) {
                setState(() {
                  if (textcontrollertareweight.text.isNotEmpty) {
                    tareweight = double.tryParse(
                        textcontrollertareweight.text.replaceAll(',', ''))!;
                  } else {
                    tareweight = 0;
                  }
                });
              }),
              SizedBox(height: 10),
              buildfield(
                  'Nett Weight',
                  textcontrollernettweight,
                  nodenettweigth,
                  true,
                  TextInputType.numberWithOptions(decimal: true), () {
                FocusScope.of(context).unfocus();
              }, (value) => ''),
              SizedBox(height: 35),
              widget.statusShipment == true
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildelevatedbutton('Reset', 16, blueTheme, whiteTheme,
                            Colors.red.shade500, 40, 110, () {
                          clearcontroller();
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        buildelevatedbutton(
                            'Save',
                            16,
                            whiteTheme,
                            blueTheme,
                            blueTheme.withOpacity(0.5),
                            40,
                            110,
                            widget.statusShipment == false
                                ? () async {
                                    await dbHelper.updateShipmentObject(
                                        widget.shipmentOfflineModel!.id!,
                                        ShipmentOfflineModel(
                                            id: widget.shipmentOfflineModel!.id,
                                            container:
                                                textcontrollercontainer.text,
                                            clientId: widget
                                                .shipmentOfflineModel!.clientId,
                                            orgId: widget
                                                .shipmentOfflineModel!.orgId,
                                            status: false,
                                            qtyentered: grossweight,
                                            quantity: netweight,
                                            tareweight: tareweight,
                                            weight1: emptyweight,
                                            shipmentDate: ''));
                                    setState(() {
                                      widget.setShipmentObject(
                                          ShipmentOfflineModel(
                                              id: widget
                                                  .shipmentOfflineModel!.id,
                                              container:
                                                  textcontrollercontainer.text,
                                              clientId: widget
                                                  .shipmentOfflineModel!
                                                  .clientId,
                                              orgId: widget
                                                  .shipmentOfflineModel!.orgId,
                                              status: false,
                                              qtyentered: grossweight,
                                              quantity: netweight,
                                              tareweight: tareweight,
                                              weight1: emptyweight,
                                              shipmentDate: ''));
                                    });
                                    Navigator.pop(context);
                                  }
                                : () async {
                                    ShipmentOfflineModel shipmentOfflineModel =
                                        ShipmentOfflineModel(
                                      orgId: Context().orgId,
                                      container: textcontrollercontainer.text,
                                      qtyentered: grossweight,
                                      quantity: netweight,
                                      status: false,
                                      tareweight: tareweight,
                                      weight1: emptyweight,
                                      shipmentDate: '',
                                    );
                                    await dbHelper.insertShipmentObject(
                                        shipmentOfflineModel);
                                    clearcontroller();
                                  }),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildfield(
      String label,
      TextEditingController controller,
      FocusNode node,
      bool readonly,
      TextInputType inputtype,
      Function oneditingcomplate,
      Function(String) onchanged) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: OpusbTheme().latoTextStyle.copyWith(
                fontSize: 16, fontWeight: FontWeight.w600, color: blackTheme),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: blueTheme,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: TextField(
              controller: controller,
              focusNode: node,
              readOnly: readonly,
              keyboardType: inputtype,
              onChanged: onchanged,
              onEditingComplete: () => oneditingcomplate,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(top: 15.0, left: 10.0, right: 4.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
                hintText: label,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: readonly == true ? grayField : whiteTheme,
                filled: true,
              ),
              style: OpusbTheme().nunitoTextStyle.copyWith(fontSize: 16),
              inputFormatters: [
                if (inputtype == TextInputType.numberWithOptions(decimal: true))
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildelevatedbutton(
      String label,
      double fontsize,
      Color fontcolor,
      Color color,
      Color overlaycolor,
      double height,
      double width,
      Function onpressed) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: blueTheme,
            width: 1,
          )),
      child: TextButton(
        onPressed: () => onpressed,
        child: Center(
            child: Text(label,
                style: OpusbTheme().latoTextStyle.copyWith(
                    fontSize: fontsize,
                    fontWeight: FontWeight.w600,
                    color: fontcolor))),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: blueTheme, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(color),
          minimumSize: MaterialStateProperty.all(Size(width, height)),
          overlayColor: MaterialStateProperty.all(overlaycolor),
        ),
      ),
    );
  }

  void clearcontroller() {
    setState(() {
      nodecontainer.requestFocus();
      textcontrollercontainer.clear();
      textcontrolleremptyweight.clear();
      textcontrollergrossweight.clear();
      textcontrollernettweight.clear();
      textcontrollertareweight.clear();
      netweight = 0;
      grossweight = 0;
      tareweight = 0;
      emptyweight = 0;
    });
  }

  void setfirstdata() {
    if (widget.shipmentOfflineModel != null) {
      if (widget.shipmentOfflineModel!.container!.isNotEmpty) {
        textcontrollercontainer.text = widget.shipmentOfflineModel!.container!;
      }
      if (widget.shipmentOfflineModel!.qtyentered != null) {
        grossweight = widget.shipmentOfflineModel!.qtyentered!;
        textcontrollergrossweight.text =
            widget.shipmentOfflineModel!.qtyentered.toString();
      }
      if (widget.shipmentOfflineModel!.weight1 != null) {
        emptyweight = widget.shipmentOfflineModel!.weight1!;
        textcontrolleremptyweight.text =
            widget.shipmentOfflineModel!.weight1.toString();
      }
      if (widget.shipmentOfflineModel!.tareweight != null) {
        tareweight = widget.shipmentOfflineModel!.tareweight!;
        textcontrollertareweight.text =
            widget.shipmentOfflineModel!.tareweight.toString();
      }
      if (widget.shipmentOfflineModel!.quantity != null) {
        netweight = widget.shipmentOfflineModel!.quantity!;
        textcontrollernettweight.text =
            widget.shipmentOfflineModel!.quantity.toString();
      }
    }
  }
}
