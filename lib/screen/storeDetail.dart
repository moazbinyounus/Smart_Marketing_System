import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller.dart';
import 'userDetail.dart';
import '../models/productTile.dart';
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key}) : super(key: key);

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white38,
        title: Text('Your Products ',
        style: TextStyle(
            color: Colors.deepPurple
        ),),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProductStream(),
        ],
      ),
    );
  }
}

class ProductStream extends StatelessWidget {
  final Details ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Products').snapshots(),
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
          List<ProductTileSeller> messageList = [];
          for (var message in messages) {
            final productId = message.get('id');
            final productTitle = message.get('name');
            final seller = message.get('email');
            final imageUrl=message.get('imageUrl');
            final price = message.get('price');
            final minimumOrder=message.get('minimumOrder');
            final totalStack=message.get('totalStock');
            final category=message.get('category');


            if (ctrl.email == seller) {
              final singleMessage = ProductTileSeller( productId, productTitle,imageUrl, price,minimumOrder,totalStack,category,seller);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => ProductTileSeller(messageList[i].id,
                  messageList[i].name, messageList[i].image,
                  messageList[i].price,messageList[i].minOrder,
                  messageList[i].totalStock,messageList[i].category,
                  messageList[i].email,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          );
        });
  }
}
