//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_marketing_system/screen/homaScreen.dart';
import 'package:smart_marketing_system/screen/toReview.dart';
import '../Controller.dart';
import 'package:get/get.dart';
import '../models/DialogWidget.dart';
import '../reviewConrolller.dart';
class ReviewPad extends StatefulWidget {
  String productId;
  ReviewPad(this.productId, {Key? key}) : super(key: key);

  @override
  _ReviewPadState createState() => _ReviewPadState();
}

class _ReviewPadState extends State<ReviewPad> {
  double ratingStar=1;
  String description='';
  String id='';
  final Details ctrl = Get.find();
  final ReviewController rev=Get.find();
  GlobalKey<FormState> formKey= GlobalKey<FormState>();
  void validate(){
    if(formKey.currentState!.validate()){
      print('Validated');
    }
    else{
      print('Not Validated');
    }
  }
  void uniqueId(){
    id = FirebaseFirestore.instance
        .collection('Reviews')
        .doc()
        .id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give Your Feedback'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  ratingStar=rating;

                },
                  ),
              TextFormField(
                onChanged: (value){
                  description=value;
                },
                validator: MaxLengthValidator(50, errorText: '50 characters Allowed'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write Review',
                  hintStyle: TextStyle(
                      color: Colors.black26
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.deepPurple, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              TextButton(onPressed: ()async{

                  print('validated');
                  print(ratingStar);
                  print(description);

                  if (formKey.currentState!
                      .validate() ) {
                    uniqueId();


                    try {
                      //spinner = true;
                      await FirebaseFirestore.instance
                          .collection('Reviews')
                          .doc(id)
                          .set({
                        'prodId':rev.prodId,
                        'reviewId': id,
                        'reviewedBy': (ctrl.email),
                        'stars': ratingStar,
                        'description': description,

                      });
                      FirebaseFirestore.instance
                          .collection("Sales")
                          .doc(rev.salesId)
                          .set({
                        "prodName": rev.prodName,
                        "prodId": rev.prodId,
                        "orderBy":rev.orderBy,
                        "reviewStatus":'Reviewed',
                        "DateTime":rev.dateTime,
                        "orderId":rev.riderId,
                        "price":rev.price,
                        "quantity":rev.quantity,
                        "riderId":rev.riderId,
                        "salesId":rev.salesId,
                        "storeEmail":rev.storeEmail,


                      }).then((value) {
                        return "success updated";
                      }).catchError((onError) {
                        print('contact added');
                        return "error";
                      });

                      Get.to(() => HomeScreen());
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) => DialogWidget(
                              'Network Error'));
                      print(e);
                    }

                    //showDialog(context: context, builder: (_)=> DialogWidget('All good'),);

                  } else {
                    //print(downloadUrl);

                    showDialog(
                      context: context,
                      builder: (_) => DialogWidget(
                          'Oops! lets see whats wrong '),
                    );
                  }


              }, child: Text('Post Review'))
            ],
          ),
        ),
      ),
    );
  }
}
