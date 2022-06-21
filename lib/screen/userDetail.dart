import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_marketing_system/screen/locpick.dart';
import '../models/DialogWidget.dart';
import 'package:get/get.dart';
import 'homaScreen.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
class UserDetail extends StatefulWidget {
  String email;
  UserDetail(this.email, {Key? key}) : super(key: key);



  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  GlobalKey<FormState> formKey= GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  bool spinner = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            //auto  validate: true,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'Field empty')]),
                  onChanged: (value) {
                    //when user writes the written string will be taken email
                    firstName = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'First Name',
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
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'Field empty')]),
                  onChanged: (value) {
                    //entered string will be saved as password
                    lastName = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          _firestore.collection('UserDetail').doc(widget.email).set({
                            'email': widget.email,
                            'firstName': firstName,
                            'lastName': lastName,
                          },
                          );
                          Get.to(LocationPicker(widget.email,'UserAddress'));
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (_) => DialogWidget('Field Empty'),
                          );
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
    );
  }
}
