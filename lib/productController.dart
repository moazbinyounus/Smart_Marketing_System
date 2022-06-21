import 'dart:core';
import 'package:get/get.dart';

class ProductController extends GetxController{
  String? id;
  String? email;
  String? title;
  String? minOrder;
  String? totalStock;
  String? imageUrl;
  String? price;
  String? category;



  initializer(String productId,String productEmail,String productTitle,
      String minimumOrder,String stock,String prodImageUrl,
      String prodPrice,String productCategory ){
    id=productId;
    email=productEmail;
    title=productTitle;
    minOrder=minimumOrder;
    totalStock=stock;
    imageUrl=prodImageUrl;
    price=prodPrice;
    category=productCategory;

  }



}