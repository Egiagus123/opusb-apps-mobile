import 'package:apps_mobile/business_logic/models/inventory/chartdetail.dart';

abstract class ChartService {
  Future<List<DataDetail>> getChartData();
}
