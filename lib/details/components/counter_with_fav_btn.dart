import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:favorite_button/favorite_button.dart';
import 'cart_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../productController.dart';
import 'package:get/get.dart';
import '../../Controller.dart';
import '../../models/DialogWidget.dart';
FirebaseFirestore _firestore=FirebaseFirestore.instance;

class CounterWithFavBtn extends StatefulWidget {

  bool? isfav;
  String? favId;
  CounterWithFavBtn(this.isfav,this.favId);
  @override
  State<CounterWithFavBtn> createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  final ProductController prod = Get.find();
  final Details ctrl = Get.find();

  String? id;
  void printstats(){
    print(widget.isfav);

  }
  void uniqueId(){
    id = _firestore
        .collection('Favourite')
        .doc()
        .id;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //checkStatus();
    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(),

        FavoriteButton(
          isFavorite: widget.isfav,
          valueChanged: (_isFavorite) async{
            print('Is Favorite $_isFavorite)');
            if(_isFavorite==true){
              try {
                uniqueId();

                await _firestore
                    .collection('Favourite')
                    .doc(id)
                    .set({
                  'favId': id,
                  'email': prod.email,
                  'name': prod.title,
                  'minimumOrder': prod.minOrder,
                  'totalStock': prod.totalStock,
                  'category': prod.category,
                  'imageUrl': prod.imageUrl,
                  'price':prod.price,
                  'favOf': ctrl.email,
                  'prodId':prod.id,
                  'heart':true,

                });
                setState(() {
                  widget.favId=id;
                });


                showDialog(context: context,
                    builder: (_)=> DialogWidget('Added To Favourites !') );
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (_) => DialogWidget(
                        'Network Error'));
                print(e);
              }
            }
            else if(_isFavorite==false){
              print('so $_isFavorite');
              try {

                FirebaseFirestore.instance
                    .collection("Favourite")
                    .where("favId", isEqualTo: widget.favId.toString())
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    FirebaseFirestore.instance
                        .collection("Favourite")
                        .doc(element.id)
                        .delete()
                        .then((value) {
                      print(widget.favId.toString());
                      print("Success!");

                    });
                  });
                });
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (_) => DialogWidget(
                        'Network Error'));
                print(e);
              }
            }
          },

        ),
      ],
    );
  }
}
