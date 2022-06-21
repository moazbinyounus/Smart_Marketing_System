import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController{
  String? prodName;
  String? prodId;
  String? orderBy;
  String? reviewStatus;
  Timestamp? dateTime;
  String? orderId;
  String? price;
  String? quantity;
  String? riderId;
  String? salesId;
  String? storeEmail;


  takeOff(String productName,String productId,String orderBy,String reviewStatus,Timestamp datetime,
      String orderId,String price,String quantity,String riderId,String salesId,String storeEmail){

    prodName=productName;
    prodId=productId;
    this.orderBy=orderBy;
    this.reviewStatus=reviewStatus;
    dateTime=datetime;
    this.orderId=orderId;
    this.price=price;
    this.quantity=quantity;
    this.riderId=riderId;
    this.salesId=salesId;
    this.storeEmail=storeEmail;
  }



}