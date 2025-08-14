import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:apps_mobile/business_logic/cubit/downloaddata_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/inventory/approval_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/ui/chatAI/uichat/ChatScreen.dart';
import 'package:apps_mobile/ui/screens/approval/approval_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/ui/screens/configuration/configuration_page.dart';
import 'package:apps_mobile/ui/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service_locator.dart';

class AppDrawer extends StatefulWidget {
  final Function updateTabFunction;

  AppDrawer({Key? key, required this.updateTabFunction}) : super(key: key);
  @override
  _AppDrawerState createState() =>
      _AppDrawerState(updateTabFunction: this.updateTabFunction);
}

class _AppDrawerState extends State<AppDrawer> {
  Function updateTabFunction;
  _AppDrawerState({required Function updateTabFunction})
      : updateTabFunction = updateTabFunction;
  // ApprovalCubit approvalCubit;
  // List<ApprovalDoc> _approvalDocs = [];
  var bytes;

  @override
  void initState() {
    super.initState();
    // approvalCubit = BlocProvider.of<ApprovalCubit>(context);
    // approvalCubit.getApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    bool isDowloading = false;
    bytes = Context().photo;

    return BlocConsumer<DownloadDataCubit, DownloadDataState>(
      builder: (context, state) {
        return _buildDrawer(context, updateTabFunction, bytes, isDowloading);
      },
      listener: (context, state) {
        if (state is DownloadinProgress) {
          setState(() {
            isDowloading = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Downloading...',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey,
              ),
            );
          });
        } else if (state is SavingDataToLocal) {
          setState(() {
            isDowloading = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Almost Done ...',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey,
              ),
            );
          });
        } else if (state is DownloadDataLoadData) {
          _save(context, state.saveline);
        }
      },
    );
  }

  void _save(BuildContext context, int lenght) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (lenght > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download done!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => buildAlertDialog(
      //     context,
      //     title: 'Status',
      //     content: 'Failed to save!',
      //     proceedText: 'OK',
      //     proceedCallback: () {
      //       Navigator.of(context).pop(true);
      //     },
      //   ),
      // ).then((created) {});
    }
  }

  Widget _buildDrawer(BuildContext context, Function updateTabFunction,
      var bytes, bool isDownloading) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    final DownloadDataCubit downloadDataCubit =
        BlocProvider.of<DownloadDataCubit>(context);

    bool isDarkMode = AdaptiveTheme.of(context).mode.isDark;
    bool? fingerPrint = sl<SharedPreferences>().getBool(Keys.fingerOn);

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: DrawerHeader(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: (bytes == null
                            ? Icon(
                                EvaIcons.personOutline,
                                color: Colors.grey[600],
                                size: 54,
                              )
                            : ClipOval(
                                child: Image.memory(bytes),
                              )),
                      ),
                      SizedBox(height: 16),
                      Text(
                        Context().userName.toUpperCase(),
                        style: TextStyle(
                          color: purewhiteTheme,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.home_outlined),
              onTap: () {
                updateTabFunction(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: ImageIcon(
                const AssetImage("assets/settingssliders.png"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfigurationPage(
                      statusFinger: fingerPrint!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Approval',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: ImageIcon(
                const AssetImage("assets/settingssliders.png"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<ApprovalCubit>(
                      create: (BuildContext context) => ApprovalCubit(),
                      child: ApprovalScreen(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Download Data',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: Icon(EvaIcons.download),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Download Data from Server',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ElevatedButton(
                        child: Text('Download file'),
                        onPressed: () async {
                          setState(() {
                            List<AssetRequestModel>.empty();
                          });

                          await downloadDataCubit.getData().then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'Close',
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Chat AI',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.android),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Log out',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
              leading: ImageIcon(
                const AssetImage("assets/Logout.png"),
                color: Colors.red,
              ),
              onTap: () async {
                await authCubit.logout();
                Navigator.pushReplacementNamed(context, SplashScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Version: ${Context().version} Build: ${Context().buildNumber}',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              leading: Icon(EvaIcons.infoOutline),
            ),
          ],
        ),
      ),
    );
  }
}
