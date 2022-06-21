import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/models/delFav.dart';
import 'dialogDelCart.dart';
import 'package:flutter/material.dart';
import '../Controller.dart';
import 'DialogWidget.dart';
final Details ctrl = Get.find();
FirebaseFirestore _firestore=FirebaseFirestore.instance;
class FavTIle extends StatefulWidget {
  String? favid;
  String? name;
  String? image;
  String? price;
  String? seller;
  String? minOrder;
  String? totalStock;
  String? category;
  String? prodId;


  FavTIle(this.favid,this.name,this.image,this.price,this.seller,this.minOrder
      ,this.totalStock,this.category,this.prodId);

  @override
  _FavTIleState createState() => _FavTIleState();
}

class _FavTIleState extends State<FavTIle> {
  String? id;
  void uniqueId(){
    id = _firestore
        .collection('Cart')
        .doc()
        .id;
  }
  bool spinner=false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: GestureDetector(
        onLongPress: (){
          print(widget.favid);
          showDialog(
            context: context,
            builder: (_) => DeletefavItem(widget.favid.toString()),
          );
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(widget.image.toString())),
              Text(widget.name.toString()),

              Text('Rs. '"${widget.price}"),
              IconButton(onPressed: ()async{
                uniqueId();
                try {
                  spinner = true;
                  await _firestore
                      .collection('Cart')
                      .doc(id)
                      .set({
                    'cartId': id,
                    'email': widget.seller.toString(),
                    'name': widget.name.toString(),
                    'minimumOrder': widget.minOrder.toString(),
                    'totalStock': widget.totalStock.toString(),
                    'category': widget.category.toString(),
                    'imageUrl': widget.image.toString(),
                    'price':widget.price.toString(),
                    'cartOf': ctrl.email,
                    'prodId':widget.prodId.toString()
                  });

                  spinner = false;
                  showDialog(context: context,
                      builder: (_)=> DialogWidget('Added To Cart !') );
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (_) => DialogWidget(
                          'Network Error'));
                  print(e);
                }

              },
                  icon: Icon(Icons.add_shopping_cart)),





            ],
          ),
        ),
      ),
    );
  }
}
