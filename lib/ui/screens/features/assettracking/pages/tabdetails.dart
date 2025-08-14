import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/features/core/component/color.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class DetailsTabs extends StatefulWidget {
  final InstallBaseModel data;
  final byte;
  DetailsTabs({required InstallBaseModel dataX, this.byte}) : data = dataX;

  @override
  _DetailsTabsState createState() {
    return _DetailsTabsState(this.data, this.byte);
  }
}

class _DetailsTabsState extends State<DetailsTabs> {
  TextEditingController _locController = TextEditingController();
  TextEditingController _sernoController = TextEditingController();
  TextEditingController _catagoryController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _efectiveDateController = TextEditingController();
  InstallBaseModel data;
  var byte;

  _DetailsTabsState(this.data, this.byte);
  @override
  Widget build(BuildContext context) {
    _locController.text =
        (data.locator == null ? 'Not Define' : data.locator.identifier)!;
    _sernoController.text = data.serNo == null ? '' : data.serNo;
    _catagoryController.text = (data.bhpMInstallBaseTypeID == null
        ? ''
        : data.bhpMInstallBaseTypeID.identifier)!;
    _qtyController.text =
        data.qtyEntered == null ? 'Not Define' : data.qtyEntered.toString();
    _statusController.text =
        (data.status == null ? '' : data.status.identifier)!;
    _efectiveDateController.text =
        data.effectivedate == null ? '' : data.effectivedate;
    _descController.text = data.description == null ? '' : data.description;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Stack(
                children: [
                  // Expanded(
                  //   child:
                  Container(
                    width: 1000,
                    height: 300,
                    // color: whiteTheme,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: (byte == null)
                        ? Image.asset(
                            'assets/iconsmenu/notfound.png',
                            height: 250,
                            width: 500,
                            // fit: BoxFit.fill,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            child: Image.memory(
                              byte,
                              width: 110.0,
                              height: 100.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  // ),
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 300,
                ),
                Container(
                  height: 430,
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Card(
                        semanticContainer: true,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, bottom: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data.description == null
                                    ? ''
                                    : data.description,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: _qtyController,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  enabled: false,
                                  isDense: true,
                                  labelText: "Quantity",
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        'Unit Number',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffEAEAEA),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: _descController.text),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          // hint: Text('Choose'),
                                          onChanged: (changedValue) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        'Serial Number',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffEAEAEA),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: _sernoController.text),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          // hint: Text('Choose'),
                                          onChanged: (changedValue) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        'Equipment Type',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffEAEAEA),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  _catagoryController.text),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          // hint: Text('Choose'),
                                          onChanged: (changedValue) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        'Efektif Date',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xffEAEAEA),
                                          // border: Border.all(
                                          //     color: Theme.of(context)
                                          //         .primaryColor)
                                        ),
                                        child: DateTimeFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                            hintText:
                                                _efectiveDateController.text,
                                            hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent),
                                            border: InputBorder.none,
                                            suffixIcon: Icon(
                                              Icons.event_note,
                                            ),
                                          ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          validator: (e) => (e?.day ?? 0) == 1
                                              ? 'Please not the first day'
                                              : null,
                                          onDateSelected: (DateTime value) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 180,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
