import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/screen/allProducts.dart';

class CategoryTile extends StatelessWidget {
  String name;
  String image;
  CategoryTile(this.name,this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/9,
      width: MediaQuery.of(context).size.width/5,
      child: GestureDetector(
        onTap: (){
          Get.to(()=>AllProducts(name));
        },
        child: Card(
          color: const Color(0xfffaf8f9),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black12,width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4,8,4,8),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(image,
                    width: 90,height: 90,),
                ),
                Text(name,
                style: const TextStyle(
                  fontSize: 11,
                ),
                ),
              ],
            ),
          ),


        ),
      ),
    );
  }
}
