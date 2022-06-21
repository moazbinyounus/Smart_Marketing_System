import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/screen/reviewPad.dart';
import 'package:get/get.dart';
class ReviewTile extends StatefulWidget {
  //String? id;
  String productId;
  String productName;
  Timestamp time;


  ReviewTile(
      this.productId,
      this.productName,
      this.time
      );

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Get.to(()=>ReviewPad(widget.productId)),

      child: SizedBox(

        child: Card(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.productName.toString()),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(widget.time.toDate().toString()),
                    //Text(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
