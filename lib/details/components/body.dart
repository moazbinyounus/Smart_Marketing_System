import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/constants.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/models/clientReview.dart';
import 'add_to_cart.dart';
import 'color_and_size.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_title_with_image.dart';
import 'package:smart_marketing_system/productController.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/productTileClient.dart';
import 'package:get/get.dart';
FirebaseFirestore _firestore=FirebaseFirestore.instance;
class Body extends StatefulWidget {
  bool? isfav;
  String? favId;
  Body(this.isfav,this.favId);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductController prod = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      //ColorAndSize(product: product),
                      SizedBox(height: kDefaultPaddin / 2),
                      averageRating(),
                      Description(),
                      SizedBox(height: kDefaultPaddin / 2),
                      CounterWithFavBtn(widget.isfav,widget.favId),
                      SizedBox(height: kDefaultPaddin / 2),
                      AddToCart(),
                      ReviewsStream('Sports'),
                    ],
                  ),
                ),
                ProductTitleWithImage()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReviewsStream extends StatelessWidget {
  final ProductController prod = Get.find();


  String categoryName;
  ReviewsStream(this.categoryName);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Reviews').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            );
          }
          final messages = snapshot.data!.docs;
          List<ClientReview> messageList = [];
          for (var message in messages) {
            final productId = message.get('prodId');
            //final reviewId = message.get('reviewId');
            final reviewedBy = message.get('reviewedBy');
            final stars = message.get('stars');
            final description=message.get('description');


            if (prod.id==productId ) {
              final singleMessage = ClientReview(productId, reviewedBy,description,stars);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => ClientReview(
                messageList[i].productId,
                messageList[i].reviewedBy,
                messageList[i].description,
                messageList[i].stars,

              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        });
  }
}
class averageRating extends StatelessWidget {
  final ProductController prod = Get.find();
  double totalStars=0;
  double count=0;
  averageRating({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Reviews').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Row(


            );
          }
          final messages = snapshot.data!.docs;
          //List<CartTile> messageList = [];
          //total=0;
          for (var message in messages) {
            final productId = message.get('prodId');

            final stars = message.get('stars');



            if (prod.id==productId) {


             totalStars=totalStars+stars;
             count=count+1;

            }
          }
          if(count!=0){
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RatingBar.builder(
                  itemSize: MediaQuery.of(context).size.height/45,
                  initialRating: totalStars/count,
                  minRating: totalStars/count,
                  maxRating: totalStars/count,
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
                Text('('+count.toString()+')'),
              ],

            );
          }
          else{
            return Row(

            );
          }
        });
  }
}