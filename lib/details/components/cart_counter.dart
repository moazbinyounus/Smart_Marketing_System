import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import 'package:smart_marketing_system/productController.dart';

import '../../quantum.dart';

class CartCounter extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {

  final ProductController prod = Get.find();
  final Quantum ctrl = Get.find();
  int numOfItems = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numOfItems = int.parse(prod.minOrder.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 32,
          child: OutlineButton(
            child: Icon(Icons.remove),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            onPressed: () {
              if (numOfItems > int.parse(prod.minOrder.toString())) {
                setState(() {
                  numOfItems--;
                  ctrl.numOfitems=numOfItems;
                });
              };
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
        ),
        SizedBox(
          width: 40,
          height: 32,
          child: OutlineButton(
            child: Icon(Icons.add),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            onPressed: () {
              setState(() {
                numOfItems++;
                ctrl.numOfitems=numOfItems;
              });
            },
          ),
        )
      ],
    );
  }

}