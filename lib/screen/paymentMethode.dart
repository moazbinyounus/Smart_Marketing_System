import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_marketing_system/screen/cardOrderRecieved.dart';
import 'package:smart_marketing_system/screen/orders.dart';
import '../models/DialogWidget.dart';
import 'package:get/get.dart';
import 'orderReceived.dart';
class PaymentMethode extends StatefulWidget {
  double total;
  PaymentMethode(this.total);




  @override
  State<PaymentMethode> createState() => _PaymentMethodeState();
}

class _PaymentMethodeState extends State<PaymentMethode> {
  String riderId='';

  bool status=false;

  void getRider()async{
    await FirebaseFirestore.instance
        .collection('RiderStatus').where('status', isEqualTo: true)
        .limit(1).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {

        if(doc.exists){
          setState(() {
            riderId=doc.get('riderId');
            status=doc.get('status');
          });

          print(riderId);
          print(status);


        }
      });
    });




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Method'
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/8,
              width: MediaQuery.of(context).size.width,
              child:  TextButton(
                onPressed: (){
                  Get.to(OrderReceived(widget.total));



                },
                child: Card(
                  color: Color(0xffbca0dc),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cash on Delivery',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                      ),
                    ],
                  ),

                ),
              ),

            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/8,
              width: MediaQuery.of(context).size.width,
              child:  TextButton(
                onPressed: (){
                  Get.to(()=>CardOrderReceived(widget.total));
                },
                child: Card(
                  color: Color(0xffbca0dc),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Pay Via Card',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ],
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
