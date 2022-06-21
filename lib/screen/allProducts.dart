import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_marketing_system/services/dataController.dart';
import '../models/productTileClient.dart';
//import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AllProducts extends StatefulWidget {
  String? categoryName;
  AllProducts(this.categoryName, {Key? key}) : super(key: key);

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot? snapshotData;
  bool isExecuted = false;
  String? search;
  TextEditingController con1 = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  //snapshotData!.docs[index]['imageUrl']
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
          itemCount: snapshotData!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProductTileClient(
                    snapshotData!.docs[index]['id'],
                    snapshotData!.docs[index]['name'],
                    snapshotData!.docs[index]['imageUrl'],
                    snapshotData!.docs[index]['price'],
                    snapshotData!.docs[index]['minimumOrder'],
                    snapshotData!.docs[index]['totalStock'],
                    snapshotData!.docs[index]['category'],
                    snapshotData!.docs[index]['email'],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                onPressed: () {
                  val.queryData(searchController.text).then((value) {
                    snapshotData = value;
                    setState(() {
                      isExecuted = true;
                    });
                  });
                },
                icon: Icon(Icons.search),
              );
            },
          )
        ],
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Search'),
          controller: searchController,
        ),
      ),
      body: isExecuted
          ? searchedData()
          : Column(
              children: [
                ProductStream(
                  widget.categoryName.toString(),
                ),
              ],
            ),
    );
  }
}

class ProductStream extends StatelessWidget {
  String categoryName;
  ProductStream(this.categoryName);

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
          List<ProductTileClient> messageList = [];
          for (var message in messages) {
            final productId = message.get('id');
            final productTitle = message.get('name');
            final seller = message.get('email');
            final imageUrl = message.get('imageUrl');
            final price = message.get('price');
            final minimumOrder = message.get('minimumOrder');
            final totalStack = message.get('totalStock');
            final category = message.get('category');

            if (categoryName == category) {
              final singleMessage = ProductTileClient(productId, productTitle,
                  imageUrl, price, minimumOrder, totalStack, category, seller);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => ProductTileClient(
                messageList[i].id,
                messageList[i].name,
                messageList[i].image,
                messageList[i].price,
                messageList[i].minOrder,
                messageList[i].totalStock,
                messageList[i].category,
                messageList[i].email,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
