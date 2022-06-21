import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/screen/reviewPad.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class ClientReview extends StatefulWidget {
  //String? id;
  String productId;
  String reviewedBy;
  String description;
  double stars;


  ClientReview(
      this.productId,
      this.reviewedBy,
      this.description,
      this.stars
      );

  @override
  _ClientReviewState createState() => _ClientReviewState();
}

class _ClientReviewState extends State<ClientReview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: ()=> Get.to(()=>ReviewPad(widget.productId)),

      child: SizedBox(

        child: Card(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RatingBar.builder(
                  itemSize: 20,
                  initialRating: widget.stars,
                  minRating: widget.stars,
                  maxRating: widget.stars,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {

                  },
                ),
                Text(widget.reviewedBy,
                style: TextStyle(
                  color: Colors.deepPurpleAccent
                ),
                ),
                Text(widget.description)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
