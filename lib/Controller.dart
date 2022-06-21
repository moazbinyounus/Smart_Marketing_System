import 'dart:core';
import 'package:get/get.dart';

class Details extends GetxController{
  String? email;
  String? firstName;
  String? location;


  takeOff(String userEmail,String userFirstName,String userLocation){
    email=userEmail;
    firstName=userFirstName;
    location=userLocation;
    print('...............');
    print(location);

  }



}