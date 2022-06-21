import 'dialogDelCart.dart';
import 'package:flutter/material.dart';

class Tracktile extends StatefulWidget {
  //String? id;
  String name;
  String status;


  Tracktile(
      this.name,
      this.status
      );

  @override
  _TracktileState createState() => _TracktileState();
}

class _TracktileState extends State<Tracktile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: SizedBox(

        child: Card(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name.toString()),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(widget.status),
                    //Text(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
