import 'dart:convert';
//import 'dart:html';

import '../Controller.dart';
import '../models/DialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as c;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../screen/homaScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class CardOrderReceived extends StatefulWidget {
  double total;
  CardOrderReceived(this.total);
  @override
  _CardOrderReceivedState createState() => _CardOrderReceivedState();
}

class _CardOrderReceivedState extends State<CardOrderReceived> {
  String? id;
  final now = DateTime.now();
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

  void uniqueId() {
    id = FirebaseFirestore.instance.collection('Products').doc().id;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRider();
  }

  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/app_bg.jpeg'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
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
                        'paymentMethode': 'Paid',
                        'price': widget.total.toString(),
                        'orderStatus': 'inProcess',
                        'time': now,
                      });
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) => DialogWidget('Network Error'));
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
                      await makePayment(widget.total.toString());
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) => DialogWidget('Network Error'));
                      print(e);
                    }
                    //makePayment(widget.total.toString());

                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => DialogWidget('No Rider Found'),
                    );
                  }
                },
                child: c.Card(
                  color: Color(0xff6f3096),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children:[
                        Icon(Icons.check, color: Colors.white,),
                        Text(
                        ' Confirm Order',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),]
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => Get.to(HomeScreen()),
                  child: c.Card(
                    color: Color(0xff06114f),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue Shopping',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Icon(Icons.arrow_forward,color: Colors.white,)
                        ],
                      ),
                    )
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntentData = await createPaymentIntent(
          amount, 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet

      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
        print(
            'blrtshlistroiwlsrtihlgsrihtlsrhilthglsirhtlshrlthrlshnlktnlk//////////////////////////');
        showDialog(
          context: context,
          builder: (_) => DialogWidget('Rider Found'),
        );
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(widget.total.toString()),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51L5upMFw4j8raCX9KTs4UrxADV8iCPTzOxcbML1DBBzMV2AJ0AvfC9X5Z22nwgd7s5oNkOppopWkY7JQxxQdUs1W00XbyNAVHs',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = ((double.parse(amount).round()));
    return a.toString();
  }
}
