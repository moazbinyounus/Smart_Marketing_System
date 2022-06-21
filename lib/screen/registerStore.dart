import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import '../models/DialogWidget.dart';
import 'package:get/get.dart';
import '../Controller.dart';
import 'locpick.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseFirestore _firestore = FirebaseFirestore.instance;
class RegisterStore extends StatefulWidget {
  const RegisterStore({Key? key}) : super(key: key);

  @override
  _RegisterStoreState createState() => _RegisterStoreState();
}

class _RegisterStoreState extends State<RegisterStore> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;

  bool spinner = false;
  final _auth = FirebaseAuth.instance;
  String? _chosenValue;
  final Details ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/regstore.webp'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  //flexible is used so that available screen size is used specially when keyboard pops up and changes the screen size.
                  child: Container(
                    height: 200.0,
                    //app logo
                    child: Image.asset('assets/images/storeClip.png'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        //there will be expanded here
                        ModalProgressHUD(
                          inAsyncCall: spinner,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Form(
                              //autovalidate: true,
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                      child: Container(
                                        height: 100.0,
                                        // app logo
                                        child: const Text('Lets Make Your Store !',

                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.deepPurple
                                        ),),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Field empty')
                                    ]),
                                    onChanged: (value) {
                                      //when user writes the written string will be taken email
                                      name = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your store name',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Card(
                                    //color: Colors.deepPurple,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: BorderSide(color: Colors.deepPurple)
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 20),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _chosenValue,
                                          style: TextStyle(color: Colors.black),

                                          items: <String>[
                                            'Electronics',
                                            'Apparel',
                                            'Vehicle',
                                            'Sports',
                                            'Home',
                                            'Garden',
                                            'Beauty'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            "Choose Category",
                                            // style: TextStyle(
                                            //     color: Colors.black,
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w600),
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _chosenValue = value!.toString();
                                            });
                                          },
                                        ),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30.0)),
                                      elevation: 5.0,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (formKey.currentState!.validate() && _chosenValue!=null) {

                                            try{
                                              spinner=true;
                                              await _firestore.collection('Store').doc(ctrl.email).set({
                                                'email':(ctrl.email),
                                                'name': name,
                                                'category': _chosenValue,

                                              });
                                              spinner=false;
                                              Get.to(()=>LocationPicker(ctrl.email.toString(), 'StoreLocation'));
                                            }
                                            catch(e){
                                              showDialog(context: context, builder: (_)=>DialogWidget('Network Error'));
                                              print(e);
                                            }

                                           //showDialog(context: context, builder: (_)=> DialogWidget('All good'),);



                                          }
                                          else{
                                            showDialog(context: context, builder: (_)=> DialogWidget('Oops! You left Something '),);
                                          }
                                        },
                                        minWidth: 200.0,
                                        height: 42.0,
                                        child: const Text(
                                          'Continue',
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
