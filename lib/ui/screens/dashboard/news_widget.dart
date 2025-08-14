import 'package:apps_mobile/business_logic/cubit/dashboard_cubit.dart';
import 'package:apps_mobile/business_logic/models/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  List<News> news = [];
  late DashboardCubit dashboardCubit;

  @override
  void initState() {
    super.initState();
    dashboardCubit = BlocProvider.of<DashboardCubit>(context);
    dashboardCubit.getNews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial) {
            return Container();
          } else if (state is DashboardLoadSuccess) {
            news = state.news;
            return buildNews(context, news);
          } else {
            return Container();
          }
        },
        listener: (context, state) {});
  }

  Widget buildNewsNotAvail(BuildContext context) {
    return Text('news will be updated');
  }

  Widget buildNews(BuildContext context, List<News> news) {
    return Container(
      height: 250,
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: ListView.builder(
        itemCount: news.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              splashColor: Colors.grey,
              onTap: () {
                _openLink(news[index].link);
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 150,
                        child: Image(image: NetworkImage(news[index].img)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          image: DecorationImage(
                            image: NetworkImage(news[index].img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          news[index].title.rendered,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openLink(String url) async {
    if (await canLaunch(url)) await launch(url);
  }
}
