//import 'package:d2c/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_marketing_system/screen/homaScreen.dart';
import './screen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51L5upMFw4j8raCX9E1AKU078Bu8dADIFvGv9feRCZYBpd2NfgFsNQW1dVBrHQn2mso76qhMMPDIJbZ6IciG093ou00tNQv0sZj';
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
    // return null;
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch(e) {
      print('error connecting to firebase');
    }
  }

  @override
  void initState() {
    // calling firebase initializing function
    initializeFlutterFire();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,


      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginScreen.id
          : HomeScreen.id,
      routes: {

        LoginScreen.id: (context) => LoginScreen(),

        HomeScreen.id: (context) => HomeScreen(),
        //Temp.id: (context) => Temp(),
        //Humidity.id: (context) => Humidity(),



        //RoomDetail.id : (context) => RoomDetail(),
      },

    );
  }
}
