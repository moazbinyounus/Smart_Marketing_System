import 'package:flutter/material.dart';
import 'package:smart_marketing_system/constants.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/productController.dart';
import 'package:smart_marketing_system/details/details_screen.dart';
import 'dialogDelProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductTileSeller extends StatefulWidget {
 String? id;
 String? name;
 String? image;
 String? price;
 String? minOrder;
 String? totalStock;
 String? category;
 String? email;

  ProductTileSeller(this.id,this.name,this.image,this.price,this.minOrder,this.totalStock,this.category,this.email);

  @override
  State<ProductTileSeller> createState() => _ProductTileSellerState();
}

class _ProductTileSellerState extends State<ProductTileSeller> {
 final Controller = Get.put(ProductController());
 bool isfav=false;
 String? favId;

 void checkStatus()async{
   try{
     final querySnapshot= await FirebaseFirestore.instance.collection('Favourite')
         .where('prodId', isEqualTo: widget.id.toString())
         .get();
     bool state;
     String fi;
     for (var doc in querySnapshot.docs) {
       // Getting data directly
       state=doc.get('heart');
       fi=doc.get('favId');

       print(isfav);
       setState(() {
         isfav=state;
         favId=fi;
         print(isfav);

       });



     }
     setState(() {
       print(isfav);

     });}
   catch(e){
     print(e);
     isfav=false;
   }
 }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Controller.initializer(widget.id.toString(), widget.email.toString(), widget.name.toString(),
        //     widget.minOrder.toString(), widget.totalStock.toString(), widget.image.toString(), widget.price.toString(), widget.category.toString());
        // Get.to(()=>DetailsScreen(isfav,favId));

      },
      onLongPress: (){
        print(widget.id);
        showDialog(
          context: context,
          builder: (_) => DeleteProduct(widget.id.toString()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: Color(0xffe6e6fa),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${widget.id}",
                child: Image.network(widget.image.toString()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              widget.name.toString(),
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            'Rs. '"${widget.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}