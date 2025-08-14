import 'package:apps_mobile/business_logic/models/news.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final log = getLogger('DashboardCubit');
  DashboardCubit() : super(DashboardInitial());

  Future<void> getNews() async {
    log.i('getNews()');
    try {
      Dio dio = new Dio();
      List<News> news = <News>[];
      final response = await dio
          .get('https://www.berca.co.id/wp-json/wp/v2/posts?categories=44');

      var data = (response.data as List);
      List<News> newListData = data.map((i) => News.fromJson(i)).toList();
      news = newListData.reversed.toList();
      emit(DashboardLoadSuccess(news: news));
    } catch (e) {
      log.e('getNews error: $e');
      emit(DashboardStateFailure(message: 'Failed getNews'));
    }
  }
}
