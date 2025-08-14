import 'package:flutter/material.dart';

class BarChart extends StatefulWidget {
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildChart(context);
  }

  Widget _buildChart(BuildContext ctx) {
    return Container(
      // padding: EdgeInsets.only(top: 15),
      child: new SizedBox(
        child: Image.asset(
          // 'assets/iconsmenu/Pai Chart 2.jpg',
          'assets/dashboard.png',
          width: double.maxFinite,
        ),
      ),
    );
  }
}
