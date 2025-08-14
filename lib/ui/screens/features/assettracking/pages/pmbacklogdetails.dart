import 'package:apps_mobile/business_logic/models/pmbacklog.dart';
import 'package:flutter/material.dart';

class PMBacklogTabs extends StatefulWidget {
  final List<PMBacklogModel> pmbacklog;
  PMBacklogTabs({required List<PMBacklogModel> data}) : pmbacklog = data;
  @override
  _PMBacklogTabsState createState() {
    return _PMBacklogTabsState(this.pmbacklog);
  }
}

class _PMBacklogTabsState extends State<PMBacklogTabs> {
  List<PMBacklogModel> pmbacklog;
  _PMBacklogTabsState(this.pmbacklog);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pmbacklog != null ? pmbacklog.length : 0,
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: [
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.1, left: 10, right: 10, bottom: 40),
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: new InputDecoration(
                              labelText: pmbacklog[position].equipmentnumber,
                              border: InputBorder.none,
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 70,
                                    child: Text('Equipment'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('PM Type'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('PM Status'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Schedule Date'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Assign WO'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Assign WO Status'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Last Complete Date'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 230,
                                    child: Text(
                                        ': ${pmbacklog[position].bhpMInstallBaseID == null ? '' : pmbacklog[position].bhpMInstallBaseID.identifier}'),
                                  ),
                                  // Text(
                                  //     ': ${pmbacklog[position].bhpMInstallBaseID == null ? '' : pmbacklog[position].bhpMInstallBaseID.identifier}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].bhpMPMTypeID == null ? '' : pmbacklog[position].bhpMPMTypeID.identifier}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].pMStatus == null ? '' : pmbacklog[position].pMStatus.identifier}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].scheduledDate == null ? '' : pmbacklog[position].scheduledDate}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].assignedwo == null ? '' : pmbacklog[position].assignedwo}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].assignedwostatus == null ? '' : pmbacklog[position].assignedwostatus}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      ': ${pmbacklog[position].lastCompletionDate == null ? '' : pmbacklog[position].lastCompletionDate}'),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
