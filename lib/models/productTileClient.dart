import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/constants.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/productController.dart';
import 'package:smart_marketing_system/details/details_screen.dart';
import 'dialogDelProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controller.dart';
import '../quantum.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final Details ctrl = Get.find();
class ProductTileClient extends StatefulWidget {
  String? id;
  String? name;
  String? image;
  String? price;
  String? minOrder;
  String? totalStock;
  String? category;
  String? email;

  ProductTileClient(this.id,this.name,this.image,this.price,this.minOrder,this.totalStock,this.category,this.email);

  @override
  State<ProductTileClient> createState() => _ProductTileClientState();
}

class _ProductTileClientState extends State<ProductTileClient> {
  bool isfav=false;
  String? favOf;
  String? favId;
  final Controller = Get.put(ProductController());
  final quantity=Get.put(Quantum());
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
        favOf=doc.get('favOf');

        print(isfav);

        if(favOf==ctrl.email){
        setState(() {
          isfav=state;
          favId=fi;
          print(isfav);
        });}
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
        Controller.initializer(widget.id.toString(), widget.email.toString(), widget.name.toString(),
            widget.minOrder.toString(), widget.totalStock.toString(), widget.image.toString(), widget.price.toString(), widget.category.toString());
        quantity.settingQuantum(int.parse(widget.minOrder.toString()));
        Get.to(()=>DetailsScreen(isfav,favId));

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
          //AverageRating(widget.id.toString(),0,0),
          Text(
            'Rs. '"${widget.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
class AverageRating extends StatelessWidget {
  final ProductController prod = Get.find();
  double totalStars=0;
  double count=0;
  String id;
  AverageRating(this.id,this.count,this.totalStars);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
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



            if (id==productId) {
              totalStars=totalStars+stars;
              count=count+1;
              print(count);
              print(stars);
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