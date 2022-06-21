import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:smart_marketing_system/screen/storeDetail.dart';
import '../models/DialogWidget.dart';
import 'package:get/get.dart';
import '../Controller.dart';
import 'locpick.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? name;
  String? minOrder;
  String? tStock;
  String? productCategory;
  String? imageUrl;
  String? id;
  TextEditingController con1 = TextEditingController();
  TextEditingController con2 = TextEditingController();
  TextEditingController con3= TextEditingController();
  TextEditingController con4= TextEditingController();
  String? pid;
  void uniquePid(){
    pid = _firestore
        .collection('pic')
        .doc()
        .id;
  }


  var downloadUrl;
  String? price;

  bool spinner = false;
  final _auth = FirebaseAuth.instance;
  String? _chosenValue;
  final Details ctrl = Get.find();
  void getStoreCategory() async {
    String? email = ctrl.email;
    String category;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Store').doc(email.toString());
    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        productCategory = snapshot.get('category');
      } else {
        print('unable to get address');
      }
    });
  }
  void uniqueId(){
    id = _firestore
        .collection('Products')
        .doc()
        .id;
  }

  void initState() {
    super.initState();
    getStoreCategory();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: spinner,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 230.0,
                      //app logo
                      child: Image.asset('assets/images/product.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.3,
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
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Center(
                                      child: Container(
                                        height: 25.0,
                                        // app logo
                                        child: const Text(
                                          'Lets Add a Product !',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.deepPurple),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      uploadImage();
                                    },
                                    child: Container(
                                      height: 100.0,
                                      child: (imageUrl != null)
                                          ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                              child: Image.network(
                                                  imageUrl.toString()),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              child: Card(
                                                elevation: 0,

                                                child: Icon(Icons.add_photo_alternate,
                                                size: 90,),
                                              ),
                                            ),
                                    ),
                                  ),

                                  TextFormField(
                                    controller: con1,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Field empty')
                                    ]),
                                    onChanged: (value) {
                                      //when user writes the written string will be taken email
                                      name = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Product Name',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    controller: con2,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Field empty')
                                    ]),
                                    onChanged: (value) {
                                      //when user writes the written string will be taken email
                                      minOrder = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Minimum Order',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    controller: con3,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Field empty')
                                    ]),
                                    onChanged: (value) {
                                      //when user writes the written string will be taken email
                                      tStock = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Total Stock',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    controller: con4,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'Field empty')
                                    ]),
                                    onChanged: (value) {
                                      //when user writes the written string will be taken email
                                      price = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Price per unit',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Material(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      elevation: 5.0,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                                  .validate() &&
                                              downloadUrl != null) {
                                            uniqueId();


                                            try {
                                              spinner = true;
                                              await _firestore
                                                  .collection('Products')
                                                  .doc(id)
                                                  .set({
                                                'id': id,
                                                'email': (ctrl.email),
                                                'name': name,
                                                'minimumOrder': minOrder,
                                                'totalStock': tStock,
                                                'category': productCategory,
                                                'imageUrl': downloadUrl,
                                                'price':price
                                              });
                                              setState(() {
                                                setState(() {
                                                  con1.text='';
                                                  con2.text='';
                                                  con3.text='';
                                                  con4.text='';


                                                });
                                              });
                                              spinner = false;
                                              Get.to(() => StoreDetail());
                                            } catch (e) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => DialogWidget(
                                                      'Network Error'));
                                              print(e);
                                            }

                                            //showDialog(context: context, builder: (_)=> DialogWidget('All good'),);

                                          } else {
                                            print(downloadUrl);

                                            showDialog(
                                              context: context,
                                              builder: (_) => DialogWidget(
                                                  'Oops! You left Something '),
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

  uploadImage() async {
    uniquePid();
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage.ref().child(pid.toString()).putFile(file);
        // .onComplete;

        downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
