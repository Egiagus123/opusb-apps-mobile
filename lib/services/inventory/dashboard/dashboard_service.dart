import 'package:apps_mobile/business_logic/models/inventory/chartdetail.dart';
import 'package:apps_mobile/business_logic/models/news.dart';

abstract class DashboardService {
  Future<List<News>> getNews();
  Future<List<DataDetail>> getChartData();
}
