import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_marketing_system/constants.dart';

import './components/body.dart';
import 'package:smart_marketing_system/productController.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  final ProductController prod = Get.find();
  bool? isfav;
  String? favId;
  DetailsScreen(this.isfav,this.favId);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: Colors.deepPurple,
      appBar: buildAppBar(context),
      body: Body(isfav,favId),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[

        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"),
          onPressed: () {},
        ),
        const SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
