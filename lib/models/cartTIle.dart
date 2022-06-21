import 'dialogDelCart.dart';
import 'package:flutter/material.dart';

class CartTile extends StatefulWidget {
  String? id;
  String? name;
  String? image;
  String? price;
  String? minimumOrder;

  CartTile(
    this.id,
    this.name,
    this.image,
    this.price,
    this.minimumOrder,
  );

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print(widget.id);
        showDialog(
          context: context,
          builder: (_) => DeleteCartItem(widget.id.toString()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(widget.image.toString())),
              Text(widget.name.toString()),
              Text(widget.minimumOrder.toString()),
              Text('Rs. ' "${widget.price}"),
            ],
          ),
        ),
      ),
    );
  }
}
