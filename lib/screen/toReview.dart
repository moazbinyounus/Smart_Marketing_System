import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/models/reviewTile.dart';
import 'package:smart_marketing_system/models/tracktile.dart';
import '../Controller.dart';
import 'package:get/get.dart';
import '../reviewConrolller.dart';
final Controller = Get.put(ReviewController());
class ToReview extends StatefulWidget {
  const ToReview({Key? key}) : super(key: key);

  @override
  _ToReviewState createState() => _ToReviewState();
}

class _ToReviewState extends State<ToReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Column(
        children: [
          TrackerStream(),
        ],
      ),
    );
  }
}

class TrackerStream extends StatelessWidget {
  final Details ctrl = Get.find();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Sales').snapshots(),
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
          List<ReviewTile> messageList = [];
          for (var message in messages) {
            final productName = message.get('prodName');
            final prodId=message.get('prodId');
            final orderby=message.get('orderBy');
            final reviewStatus=message.get('reviewStatus');
            final time=message.get('DateTime');
            final orderId=message.get('orderId');
            final price=message.get('price');
            final quantity=message.get('quantity');
            final riderId=message.get('riderId');
            final salesId=message.get('salesId');
            final storeEmail=message.get('storeEmail');



            if(ctrl.email==orderby && reviewStatus=='pendingReview'){
              Controller.takeOff(productName, prodId, orderby, reviewStatus, time, orderId, price, quantity, riderId, salesId, storeEmail);
              final singleMessage = ReviewTile(prodId,productName,time);
              messageList.add(singleMessage);}

          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => ReviewTile(
                messageList[i].productId,
                messageList[i].productName,
                messageList[i].time,

              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        });
  }
}

