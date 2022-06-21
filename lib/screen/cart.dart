import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_marketing_system/screen/bill.dart';
import 'dart:math';
import 'registerStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'store.dart';
import 'homaScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_marketing_system/Controller.dart';
import 'loginScreen.dart';
import '../models/cartTIle.dart';
import 'favourite.dart';
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;


class cart extends StatefulWidget {
  @override
  State<cart> createState() => _cartState();
}
class _cartState extends State<cart> {
  final Details ctrl=Get.find();
  double value = 0;
  num total=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurple,

                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
          SafeArea(
            child: Container(
              width: 200.0,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    ctrl.firstName.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView(
                        children:  [
                          ListTile(
                            onTap: ()=>Get.to(HomeScreen()),
                            leading: const Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Home',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              DocumentReference documentReference= FirebaseFirestore.instance.collection('Store').doc(ctrl.email.toString());
                              await documentReference.get().then((snapshot){
                                if(snapshot.exists){
                                  Get.to(()=>Store());


                                }
                                else{
                                  Get.to(()=>RegisterStore());
                                }
                              });


                            },
                            leading: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Seller Portal',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: ()=>Get.to(() => cart()),
                            leading: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: ()=>Get.to(() => Favourite()),
                            leading: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Favourites',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const ListTile(
                            leading: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap:(){
                              _auth.signOut();
                              Get.to(()=>LoginScreen());
                            },
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Log Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.white38,
                      leading: TextButton(child: const Icon(Icons.menu,color: Colors.deepPurple,),
                        onPressed: (){
                          setState(
                                  () {
                                value==0 ? value= 1 : value=0 ;
                              });
                        },),
                      title: const Text('Your Cart',style: TextStyle(
                        color: Colors.deepPurple
                      ),),
                    ),
                    body: Column(
                      children: [
                        ProductStream(),
                      ],
                    ),
                    bottomNavigationBar: Card(
                      child: Container(
                        height: 40,
                        color: Colors.deepPurple,
                        child: BillStream(),
                      ),
                    ),
                  ),
                ));
              }),

        ],
      ),
    );
  }
}
class ProductStream extends StatelessWidget {
  final Details ctrl = Get.find();

  ProductStream({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            );
          }
          final messages = snapshot.data!.docs;
          List<CartTile> messageList = [];
          for (var message in messages) {
            final productId = message.get('cartId');
            final productTitle = message.get('name');
            final seller = message.get('email');
            final imageUrl=message.get('imageUrl');
            final price = message.get('price');
            final minimumOrder=message.get('minimumOrder');
            final totalStack=message.get('totalStock');
            final category=message.get('category');
            final cartOf=message.get('cartOf');
            if (ctrl.email == cartOf) {
              final singleMessage = CartTile( productId, productTitle,imageUrl, price,minimumOrder);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => CartTile(messageList[i].id,
                messageList[i].name, messageList[i].image,
                messageList[i].price,messageList[i].minimumOrder
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
        });
  }
}
class BillStream extends StatelessWidget {
  final Details ctrl = Get.find();
  double total=0;
  BillStream({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: (){
                  print(total.toString());
                }, child: const Text('Cart Empty',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ))
              ],

            );
          }
          final messages = snapshot.data!.docs;
          List<CartTile> messageList = [];
          total=0;
          for (var message in messages) {
            final price = message.get('price');
            final cartOf=message.get('cartOf');
            final quantity=message.get('minimumOrder');


            if (ctrl.email == cartOf) {


              total=total+(int.parse(price))*int.parse(quantity) ;
              print(total);
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: (){
                Get.to(Bill(total));
                print(total.toString());
              }, child: const Text('Continue',
                style: TextStyle(
                    color: Colors.white
                ),
              ))
            ],

          );
        });
  }
}