import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../models/DialogWidget.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;
class InvetoryCounter extends StatefulWidget {

  String? id;
  String? name;
  String? image;
  String? price;
  int? minItems;
  int? totalStock;
  String? category;
  String? email;
  InvetoryCounter(this.id,this.name,this.image,this.price,this.minItems,this.totalStock,this.category,this.email);
  @override
  _InvetoryCounterState createState() => _InvetoryCounterState();
}

class _InvetoryCounterState extends State<InvetoryCounter> {

  void updateFireBase() async{
    try{
      await _firestore.collection('Products').doc(widget.id.toString()).set({
        'category':widget.category.toString(),
        'totalStock': widget.totalStock.toString(),
        'email': widget.email.toString(),
        'id':widget.id.toString(),
        'imageUrl': widget.image.toString(),
        'minimumOrder': widget.minItems.toString(),
        'name': widget.name.toString(),
        'price': widget.price.toString(),
      });
    }
    catch(e){
      showDialog(context: context, builder: (_)=>DialogWidget('Network Error'));
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 32,
          child: OutlineButton(
            child: Icon(Icons.remove),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            onPressed: () {
              if (widget.totalStock! > 0) {
                setState(() {
                  widget.totalStock=widget.totalStock!-1;

                });
                updateFireBase();
              };
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            widget.totalStock.toString().padLeft(2, "0"),
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
        ),
        SizedBox(
          width: 40,
          height: 32,
          child: OutlineButton(
            child: Icon(Icons.add),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            onPressed: () {
              setState(() {
                widget.totalStock=widget.totalStock!+1;

              });
              updateFireBase();
            },
          ),
        )
      ],
    );
  }

}