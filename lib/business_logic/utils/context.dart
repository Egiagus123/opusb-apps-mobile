import 'package:apps_mobile/business_logic/models/recentitem.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';

class Context {
  static final Context _instance = Context._internal();

  factory Context() => _instance;

  Context._internal({
    this.appName = '',
    this.packageName = '',
    this.version = '',
    this.buildNumber = '',
    this.orgId = 0,
    this.userId = 0,
    this.userName = '',
    this.token = '',
    this.clientName = '',
    this.roleName = '',
    this.photo,
    this.recordId = 0,
    this.tableId = 0,
    this.bpwo = 0,
    this.bplocationwo = 0,
    this.wostatus = '',
    this.priority = '',
    this.startdate,
    this.enddate,
    this.equipmentid = 0,
    this.finalListWO = const [],
    this.recentitem = const [],
  });

  // Initializing with default values or allowing null
  String appName;
  String packageName;
  String version;
  String buildNumber;

  int orgId;

  int userId;
  String userName;
  String token;
  String clientName;
  String roleName;
  var photo;

  int recordId;
  int tableId;
  int bpwo;
  int bplocationwo;
  String wostatus;
  String priority;
  DateTime? startdate; // Nullable DateTime
  DateTime? enddate; // Nullable DateTime
  int equipmentid;

  List<WOServiceModel> finalListWO;
  List<RecentItem> recentitem;
}
