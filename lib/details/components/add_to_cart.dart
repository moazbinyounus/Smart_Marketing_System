import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/productController.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_marketing_system/quantum.dart';
import '../../../constants.dart';
import '../../models/DialogWidget.dart';
import '../../Controller.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;

class AddToCart extends StatelessWidget {
  final ProductController prod = Get.find();
  final Quantum quantity=Get.find();
  final Details ctrl = Get.find();
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: kDefaultPaddin),
              height: 50,
              width: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.deepPurple,
                ),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/add_to_cart.svg",
                  color: Colors.deepPurple,
                ),
                onPressed: () async{
                  uniqueId();
                  try {
                    spinner = true;
                    await _firestore
                        .collection('Cart')
                        .doc(id)
                        .set({
                      'cartId': id,
                      'email': prod.email,
                      'name': prod.title,
                      'minimumOrder': quantity.numOfitems.toString(),
                      'totalStock': prod.totalStock,
                      'category': prod.category,
                      'imageUrl': prod.imageUrl,
                      'price':prod.price,
                      'cartOf': ctrl.email,
                      'prodId':prod.id
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
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  color: Colors.deepPurple,
                  onPressed: () {},
                  child: Text(
                    "Buy  Now".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
