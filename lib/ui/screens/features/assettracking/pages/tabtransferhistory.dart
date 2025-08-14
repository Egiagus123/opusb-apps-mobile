import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:flutter/material.dart';

class TransferHistoryTab extends StatefulWidget {
  final List<InstallBaseTransfer> installbasetrf;
  TransferHistoryTab({required List<InstallBaseTransfer> data})
      : installbasetrf = data;
  @override
  _TransferHistoryTabState createState() {
    return _TransferHistoryTabState(this.installbasetrf);
  }
}

class _TransferHistoryTabState extends State<TransferHistoryTab> {
  List<InstallBaseTransfer> installbasetrf;
  _TransferHistoryTabState(this.installbasetrf);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: installbasetrf != null ? installbasetrf.length : 0,
            itemBuilder: (context, index) {
              var data = installbasetrf[index];
              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 15),
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: new InputDecoration(
                              labelText: data.tooltrfID.identifier,
                              border: InputBorder.none,
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Movement Type'),
                                  Text('Movement Date'),
                                  Text('From'),
                                  Text('To'),
                                  Text('Duration')
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(': ${data.doctype.identifier}'),
                                  Text(': ${data.dateDoc}'),
                                  Text(': ${data.from.identifier}'),
                                  Text(': ${data.to.identifier}'),
                                  Text(': ${data.duration.toString()}')
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
