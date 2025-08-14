import 'package:apps_mobile/business_logic/models/pm_list.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service.dart';
import 'package:apps_mobile/ui/widgets/loading_indicator.dart';
import 'package:apps_mobile/widgets/CustomTabIndicator.dart';
import 'package:flutter/material.dart';

class PMListForm extends StatefulWidget {
  @override
  State createState() => _PMListFormState();
}

class _PMListFormState extends State<PMListForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<PMSListModel> filteredDatadue = [];
  List<PMSListModel> pmdue = [];
  List<PMSListModel> filteredDataschedule = [];
  List<PMSListModel> pmschedule = [];
  bool isloadingdue = true;
  bool isloadingsh = true;

  String searchQuery = "";
  TextEditingController searchcontroller = TextEditingController();

  Future<String> loadinitData() async {
    pmdue = await sl<AssetTrackingService>().getPMListDue();
    pmschedule = await sl<AssetTrackingService>().getPMListShedule();

    setState(() {
      filteredDatadue = pmdue;
      filteredDataschedule = pmschedule;
      isloadingdue = false;
      isloadingsh = false;
    });

    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadinitData();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredDatadue = pmdue
          .where((pmdue) =>
              pmdue.documentNo.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredDataschedule = pmschedule
          .where((pmsh) =>
              pmsh.documentNo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Desired height
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
            'PM List',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: TextField(
                      controller: searchcontroller,
                      onSubmitted: (value) => updateSearchQuery(value),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by PM No',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    updateSearchQuery(searchcontroller.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('Cari',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[100], // Tab background color
            child: TabBar(
              controller: _tabController,
              indicator: CustomTabIndicator(
                width: 180, // Set desired width
                height: 50, // Height of the indicator
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(15),
              ),
              labelColor: Colors.white, // Color for active tab text
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "Due"),
                Tab(text: "Schedule"),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Isi tab Due
                isloadingdue
                    ? LoadingIndicator()
                    : ListView.builder(
                        itemCount: filteredDatadue.length,
                        itemBuilder: (context, index) {
                          final datadue = filteredDatadue[index];
                          return buildCard(datadue);
                        },
                      ),

                // Isi tab Schedule
                isloadingsh
                    ? LoadingIndicator()
                    : ListView.builder(
                        itemCount: filteredDataschedule.length,
                        itemBuilder: (context, index) {
                          final datash = filteredDataschedule[index];
                          return buildCard(datash);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(dynamic data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.0),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue[100]!.withOpacity(0.5),
                      border:
                          Border.all(color: Colors.blue.shade400, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        data.pmStatus?.identifier ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.blue[600]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  data.documentNo,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: 2)
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.bHPMPMTypeID?.identifier ?? "",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  data.bhpMInstallBaseID?.identifier ?? "",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  data.scheduledDate,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
