import '../Controller.dart';
import '../models/DialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../screen/homaScreen.dart';
class OrderReceived extends StatefulWidget {
  double total;
  OrderReceived(this.total);
  @override
  _OrderReceivedState createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> {
  String? id;
  final now=DateTime.now();
  String riderId = '';
  bool status = false;
  final Details ctrl = Get.find();

  void getRider() async {
    await FirebaseFirestore.instance
        .collection('RiderStatus')
        .where('status', isEqualTo: true)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (doc.exists) {
              setState(() {
                riderId = doc.get('riderId');
                status = doc.get('status');
              });
              print(riderId);
              print(status);
            }
          },
        );
      },
    );
  }
  void uniqueId(){
    id = FirebaseFirestore.instance
        .collection('Products')
        .doc()
        .id;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextButton(
              onPressed: () async{

                if (status == true) {
                  uniqueId();


                  try {
                    //spinner = true;
                    await FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(id)
                        .set({
                      'orderId': id,
                      'ridersId': riderId,
                      'clientEmail': (ctrl.email),
                      'paymentMethode': 'Cash on Delivery',
                      'price':widget.total.toString(),
                      'orderStatus':'inProcess',
                      'time': now,
                    });


                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (_) => DialogWidget(
                            'Network Error'));
                    print(e);
                  }
                  try {
                    //spinner = true;
                    await FirebaseFirestore.instance
                        .collection('RiderStatus')
                        .doc(riderId)
                        .set({
                      'riderId': riderId,
                      'status': false,

                    });


                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (_) => DialogWidget(
                            'Network Error'));
                    print(e);
                  }

                  showDialog(
                    context: context,
                    builder: (_) => DialogWidget('Rider Found Delivery Started'),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => DialogWidget('No Rider Found'),
                  );
                }
              },
              child: Text(
                'Confirm Order',
                style: TextStyle(
                  color: Colors.purple
                ),
              ),
            ),
            TextButton(onPressed: ()=> Get.to(HomeScreen()), child: Text(
              'Continue Shopping !'
                  ,
              style: TextStyle(
                color: Colors.purple
              ),
            ))
          ],
        ),
      ),
    );
  }
}
