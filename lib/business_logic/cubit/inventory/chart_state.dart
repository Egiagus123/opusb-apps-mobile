part of 'chart_cubit.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartChartLoadSuccess extends ChartState {
  final List<DataDetail> chart;

  ChartChartLoadSuccess({required this.chart});

  @override
  List<Object> get props => [chart];
}

class ChartSaveSuccess extends ChartState {}

class ChartStateFailure extends ChartState {
  final String message;

  ChartStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
