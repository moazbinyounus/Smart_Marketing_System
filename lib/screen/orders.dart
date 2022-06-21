

import 'package:flutter/material.dart';


class OrdersRecieved extends StatefulWidget {
  const OrdersRecieved({Key? key}) : super(key: key);

  @override
  _OrdersRecievedState createState() => _OrdersRecievedState();
}

class _OrdersRecievedState extends State<OrdersRecieved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
    );
  }
}
