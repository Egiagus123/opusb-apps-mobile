import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/date_text.dart';
import 'package:flutter/material.dart';

class StatusHistoryTab extends StatefulWidget {
  final List<InstallBaseStatus> installbasestatus;
  StatusHistoryTab({required List<InstallBaseStatus> data})
      : installbasestatus = data;
  @override
  _StatusHistoryTabState createState() {
    return _StatusHistoryTabState(this.installbasestatus);
  }
}

class _StatusHistoryTabState extends State<StatusHistoryTab> {
  List<InstallBaseStatus> installbasestatus;
  _StatusHistoryTabState(this.installbasestatus);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: installbasestatus != null ? installbasestatus.length : 0,
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                width: 430,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  // const Color(0xffF8F9F9)
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          installbasestatus[position].status.identifier ==
                                  'Available'
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffEEFFE6).withOpacity(0.5),
                                      // const Color(0xffF8F9F9)
                                      border: Border.all(
                                          color: Color(0xff6EE789), width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${installbasestatus[position].status.identifier}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Color(0xff18A116)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          installbasestatus[position].status.identifier ==
                                      'Down - On Shop' ||
                                  installbasestatus[position]
                                          .status
                                          .identifier ==
                                      'Down - On Site'
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffFFF8DE).withOpacity(0.5),
                                      // const Color(0xffF8F9F9)
                                      border: Border.all(
                                          color: Color(0xffF9D988), width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${installbasestatus[position].status.identifier}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                  color: Color(0xffE98427)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          installbasestatus[position].status.identifier !=
                                      'Down - On Shop' &&
                                  installbasestatus[position]
                                          .status
                                          .identifier !=
                                      'Down - On Site' &&
                                  installbasestatus[position]
                                          .status
                                          .identifier !=
                                      'Available'
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xffD3D3D3).withOpacity(0.2),
                                      // const Color(0xffD3D3D3)
                                      border: Border.all(
                                          color: const Color(0xffD3D3D3),
                                          width: 1.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${installbasestatus[position].status.identifier}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 220,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.event_note),
                                SizedBox(
                                  width: 10,
                                ),
                                DateText(
                                  freetext: '',
                                  dateTime:
                                      installbasestatus[position].effectivedate,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.person_outlined),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  installbasestatus[position]
                                      .bpartnerSR
                                      .identifier!,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  ),
                  subtitle: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      '',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffEAEAEA),
                          border: Border.all(color: Colors.white)),
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "   ${installbasestatus[position].description}"),
                        keyboardType: TextInputType.emailAddress,
                        // hint: Text('Choose'),
                        onChanged: (changedValue) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
