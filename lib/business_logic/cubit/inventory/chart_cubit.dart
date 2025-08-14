import 'package:apps_mobile/business_logic/models/inventory/chartdetail.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/chart/chart_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final log = getLogger('ChartCubit');
  ChartCubit() : super(ChartInitial());

  Future<void> getChartData() async {
    log.i('getDataChart()');
    try {
      List<DataDetail> chart = await sl<ChartService>().getChartData();
      emit(ChartChartLoadSuccess(chart: chart));
    } catch (e) {
      log.e('chart error: $e');
      emit(ChartStateFailure(message: 'Failed chart'));
    }
  }
}
