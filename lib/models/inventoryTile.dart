
import '../models/inventoryCounter.dart';
import 'package:flutter/material.dart';

class InventoryTile extends StatefulWidget {
  String? id;
  String? name;
  String? image;
  String? price;
  String? minOrder;
  String? totalStock;
  String? category;
  String? email;
  InventoryTile(this.id,this.name,this.image,this.price,this.minOrder,this.totalStock,this.category,this.email);

  @override
  _InventoryTileState createState() => _InventoryTileState();
}

class _InventoryTileState extends State<InventoryTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(

        children: [
          SizedBox(
              height: 50,
              child: Image.network(widget.image.toString())),
          Text(widget.name.toString()),
          SizedBox(width: 50,),
          InvetoryCounter(
            widget.id.toString(),widget.name.toString(),widget.image.toString(),
            widget.price.toString(),int.parse(widget.minOrder.toString()),
            int.parse(widget.totalStock.toString()),widget.category.toString(),widget.email
              .toString()
          ),

        ],
      ),
    );
  }
}
