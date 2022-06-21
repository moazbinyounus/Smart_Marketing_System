
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_marketing_system/screen/paymentMethode.dart';

class Bill extends StatefulWidget {
  double wht=0;
  double delivery=0;
  double bill=0;
  double total=0;

  Bill(double this.bill, {Key? key}) : super(key: key);


  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  void getCharges()async{
    DocumentReference documentReference=FirebaseFirestore.instance.collection('Charges').doc('AcRnnobcZnpGHLMIrkof');
    await documentReference.get().then((snapshot){
      if(snapshot.exists){
        setState(() {
          widget.wht=(snapshot.get('wht')).toDouble();
          widget.delivery=(snapshot.get('delivery')).toDouble();
         billCalculator();
        });

      }
      else{
        print('unable to get address');
      }
    });
  }
  void billCalculator(){
    widget.total=widget.bill+widget.delivery+(widget.bill/widget.wht).round();

  }
  @override
  void initState() {
    getCharges();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Card(
        child: Container(
          height: 40,
          color: Colors.deepPurple,
          child: TextButton(
            onPressed: (){
              Get.to(()=> PaymentMethode(widget.total));
            },
            child: Text('Continue',
            style: TextStyle(
              color: Colors.white
            ),),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Bill'),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            color: Color(0xffbca0dc),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bill',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(widget.bill.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'W.H.T (%)',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(widget.wht.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Delivery',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(widget.delivery.toString()),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Total:'),
                      Text(widget.total.toString()),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
