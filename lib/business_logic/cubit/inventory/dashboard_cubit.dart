import 'package:apps_mobile/business_logic/models/news.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/dashboard/dashboard_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final log = getLogger('DashboardCubit');
  DashboardCubit() : super(DashboardInitial());

  Future<void> getNews() async {
    log.i('getNews()');
    try {
      List<News> news = await sl<DashboardService>().getNews();
      emit(DashboardLoadSuccess(news: news));
    } catch (e) {
      log.e('getNews error: $e');
      emit(DashboardStateFailure(message: 'Failed getNews'));
    }
  }
}
