import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_marketing_system/screen/homaScreen.dart';
import 'package:smart_marketing_system/screen/loginScreen.dart';
import '../models/wrong_emailPassword.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'registration_screen.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey= GlobalKey<FormState>();
  void validate(){
    if(formKey.currentState!.validate()){
      print('validated');
    }
    else{
      print('Not Validated');
    }
  }
  final _auth= FirebaseAuth.instance;
  late String email;
  late String password;
  bool spinner= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            // autovalidate: true,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  //flexible is used so that available screen size is used specially when keyboard pops up and changes the screen size.
                  child: Container(
                    height: 300.0,
                    //app logo
                    child: Image.asset('assets/images/logo.png',color: Colors.deepPurple,),
                  ),
                ),

                TextFormField(
                  validator: MultiValidator(
                      [
                        EmailValidator(errorText: 'Wrong Email'),
                        RequiredValidator(errorText: 'Field empty')
                      ]
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,

                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(

                        color: Colors.black26
                    ),


                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.deepPurple, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.deepPurple, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),

                // const SizedBox(
                //   height: 24.0,
                // ),


                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 0,

                    child: MaterialButton(

                      onPressed: () async{
                        try {
                          _auth.sendPasswordResetEmail(email: email);
                          Get.to(()=>LoginScreen());
                        }
                        catch(e){
                          print(e);
                        }
                      },


                      minWidth: 200.0,
                      height: 42.0,
                      child: const Text(
                        'Send Reset Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
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

