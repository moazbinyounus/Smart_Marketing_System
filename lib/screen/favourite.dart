import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_marketing_system/models/favTIle.dart';
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
import 'cart.dart';
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;
class Favourite extends StatefulWidget {
  @override
  State<Favourite> createState() => _FavouriteState();
}
class _FavouriteState extends State<Favourite> {
  final Details ctrl=Get.find();
  double value = 0;
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
                      //Colors.deepPurpleAccent
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
                          const ListTile(
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
                      title: const Text('Favourites',style: TextStyle(
                          color: Colors.deepPurple
                      ),),
                    ),
                    body: Column(
                      children: [
                        ProductStream(),
                      ],
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Favourite').snapshots(),
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
          List<FavTIle> messageList = [];
          for (var message in messages) {
            final favId = message.get('favId');
            final productTitle = message.get('name');
            final seller = message.get('email');
            final imageUrl=message.get('imageUrl');
            final price = message.get('price');
            final minimumOrder=message.get('minimumOrder');
            final totalStack=message.get('totalStock');
            final category=message.get('category');
            final cartOf=message.get('favOf');
            final prodId=message.get('prodId');


            if (ctrl.email == cartOf) {
              final singleMessage = FavTIle( favId, productTitle,imageUrl, price,seller,minimumOrder,totalStack,category,prodId);
              messageList.add(singleMessage);
            }
          }
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messageList.length,
              itemBuilder: (ctx, i) => FavTIle(messageList[i].favid,
                messageList[i].name, messageList[i].image,
                messageList[i].price,messageList[i].seller,
                  messageList[i].minOrder,messageList[i].totalStock,
                  messageList[i].category,messageList[i].prodId
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
