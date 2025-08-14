part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final List<News> news;

  DashboardLoadSuccess({required this.news});

  @override
  List<Object> get props => [news];
}

class DashboardSaveSuccess extends DashboardState {}

class DashboardStateFailure extends DashboardState {
  final String message;

  DashboardStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
