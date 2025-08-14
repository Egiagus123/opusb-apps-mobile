import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apps_mobile/business_logic/utils/size_config.dart';

class EmptyData extends StatelessWidget {
  final String text;

  const EmptyData({Key? key, this.text = 'No Data'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(100),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            height: getProportionateScreenHeight(250),
            width: getProportionateScreenWidth(250),
            child: SvgPicture.asset(
              'assets/svg/undraw_empty_xct9.svg',
              semanticsLabel: 'Empty',
            ),
          ),
          Text(text, style: Theme.of(context).textTheme.titleLarge)
        ],
      ),
    );
  }
}
