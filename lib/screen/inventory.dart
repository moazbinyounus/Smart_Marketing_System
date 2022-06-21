import 'dart:ui';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/Controller.dart';
import '../models/inventoryTile.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;
class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white24,
        elevation: 0,
        title: Text("Inventory",
        style: TextStyle(
          color: Colors.deepPurple
        ),),
      ),
      body: Column(
        children: [
          ProductStream()
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
          List<InventoryTile> messageList = [];
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
              final singleMessage = InventoryTile( productId, productTitle,imageUrl, price,minimumOrder,totalStack,category,seller);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => InventoryTile(messageList[i].id,
                messageList[i].name, messageList[i].image,
                messageList[i].price,messageList[i].minOrder,
                messageList[i].totalStock,messageList[i].category,
                messageList[i].email,
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
