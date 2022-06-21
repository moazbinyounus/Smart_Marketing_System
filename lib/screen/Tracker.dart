import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/models/tracktile.dart';
import '../Controller.dart';
import 'package:get/get.dart';
class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Column(
        children: [
          TrackerStream(),
        ],
      ),
    );
  }
}

class TrackerStream extends StatelessWidget {
  final Details ctrl = Get.find();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inProcess').orderBy('time',descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            );
          }
          final messages = snapshot.data!.docs;
          List<Tracktile> messageList = [];
          for (var message in messages) {
            final productName = message.get('prodName');
            final productTStatus = message.get('status');
            final orderby=message.get('orderBy');


            if(ctrl.email==orderby){
              final singleMessage = Tracktile(productName,productTStatus);
              messageList.add(singleMessage);}

          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => Tracktile(
                messageList[i].name,
                messageList[i].status,

              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        });
  }
}

