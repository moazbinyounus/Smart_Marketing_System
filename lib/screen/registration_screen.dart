import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_marketing_system/screen/locpick.dart';
import 'package:smart_marketing_system/screen/userDetail.dart';
import '../models/DialogWidget.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formKey= GlobalKey<FormState>();
  late String email;
  late String password;
  bool spinner=false;
  final _auth= FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            //autovalidate: true,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 200.0,
                    // app logo
                    child: Image.asset('assets/images/logo.png',
                    color:  Colors.deepPurple,
                    ),
                  ),
                ),
                TextFormField(
                  validator: MultiValidator(
                      [
                        EmailValidator(errorText: 'Wrong Email'),
                        RequiredValidator(errorText: 'Field empty')
                      ]
                  ),
                  onChanged: (value) {
                    //when user writes the written string will be taken email
                    email=value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(

                  validator: MultiValidator(
                      [
                        MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
                        RequiredValidator(errorText: 'Field empty')
                      ]
                  ),
                  onChanged: (value) {
                    //entered string will be saved as password
                    password= value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',

                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(

                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                          print('validated');
                          try{
                            setState(() {
                              spinner = true;
                            });
                            final newUser= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                            if (newUser != null){
                              //Navigator.pushNamed(context, RoomScreen.id);
                              Get.to(UserDetail(email));
                            }
                            setState(() {
                              spinner= false;
                            });
                          }
                          catch (e){
                            setState(() {
                              spinner =false;
                            });

                            print(e);
                            String reason=e.toString();
                            showDialog(
                              context: context,
                              builder: (_) => DialogWidget( 'Account already in use' ),
                            );

                          }


                        }
                        else{
                          print('not Validated');
                        }
                      },

                      minWidth: 200.0,
                      height: 42.0,
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
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
