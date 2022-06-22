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
  String riderId = '';

  bool status = false;

  void getRider() async {
    await FirebaseFirestore.instance
        .collection('RiderStatus')
        .where('status', isEqualTo: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          setState(() {
            riderId = doc.get('riderId');
            status = doc.get('status');
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
        title: const Text('Payment Method'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/app_bg.jpeg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Get.to(OrderReceived(widget.total));
              },
              child: Card(
                color: const Color(0xff6f3096),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.height/9,
                  child:  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining,color: Colors.white,),
                        Text(
                          ' Cash on Delivery',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => CardOrderReceived(widget.total));
              },
              child: Card(
                color: const Color(0xff06114f),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.height/9,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.credit_card,color: Colors.white,),
                        Text(
                          ' Pay Via Card',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
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
