import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_marketing_system/models/category.dart';
import 'package:smart_marketing_system/screen/Tracker.dart';
import 'package:smart_marketing_system/screen/favourite.dart';
import 'package:smart_marketing_system/screen/locpick.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_marketing_system/screen/loginScreen.dart';
import 'package:smart_marketing_system/screen/registerStore.dart';
import 'package:smart_marketing_system/screen/store.dart';
import 'package:smart_marketing_system/screen/toReview.dart';
import 'cart.dart';
import 'favourite.dart';
import '../Controller.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/smartmarketingsystem-17613.appspot.com/o/2.png?alt=media&token=51ddc67b-bc89-46e8-b2b5-0ce27704a061',
  'https://firebasestorage.googleapis.com/v0/b/smartmarketingsystem-17613.appspot.com/o/4.png?alt=media&token=9432de04-3d19-4a64-b9e0-27ce0d4edb98',
  'https://firebasestorage.googleapis.com/v0/b/smartmarketingsystem-17613.appspot.com/o/3.png?alt=media&token=87cbcd66-4cbe-4833-b70d-fe0e808edf78',
  'https://firebasestorage.googleapis.com/v0/b/smartmarketingsystem-17613.appspot.com/o/Purple%20Wedding%20Ideas(3).png?alt=media&token=759db941-b8ac-44bb-8c1e-c8e4c56e0e67',
];
final Controller = Get.put(Details());
User? currentUser;

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  int _current = 0;
  String? address = '';
  final CarouselController _controller = CarouselController();
  String? firstName = '';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? userEmail = '';
  String ue = "";
  int _current = 0;
  late KFDrawerController _drawerController;
  final CarouselController _controller = CarouselController();
  double value = 0;
  bool spinner=true;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        currentUser = user;
        userEmail = currentUser?.email;
        //String? userPhone=currentUser?.phoneNumber;
        ue = userEmail!.toString();
        print(currentUser?.email);
        print(
            '////////////////////////////////////////////////////////////////////////////////');
        print(ue);
        getUserAddress();
        getUserName();
      }
    } catch (e) {
      print(e);
    }
  }

  void getUserAddress() async {
    String? email = currentUser?.email!;
    print(ue);
    print(currentUser?.email);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('UserAddress').doc(ue);
    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        widget.address = snapshot.get('location');
      } else {
        print('unable to get address');
      }
    });
  }

  void getUserName() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('UserDetail').doc(ue);
    await documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        widget.firstName = snapshot.get('firstName');
        Controller.takeOff(
            ue, widget.firstName.toString(), widget.address.toString());
        setState(() {
          spinner=false;
        });
      } else {
        print('unable to get name');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.deepPurple,
                Colors.deepPurple,
                //Colors.deepPurpleAccent
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
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
                      widget.firstName.toString(),
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
                      children: [
                        ListTile(
                          onTap: () => Get.to(HomeScreen()),
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
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('Store')
                                    .doc(ue);
                            await documentReference.get().then((snapshot) {
                              if (snapshot.exists) {
                                Get.to(() => Store());
                              } else {
                                Get.to(() => RegisterStore());
                              }
                            });
                          },
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Seller Portal',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.to(() => cart()),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.to(() => Favourite()),
                          leading: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Favourites',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.to(() => Tracker()),
                          leading: Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Track Ride',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () => Get.to(() => ToReview()),
                          leading: Icon(
                            Icons.rate_review,
                            color: Colors.white,
                          ),
                          title: Text(
                            'To Review',
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
                          onTap: () {
                            _auth.signOut();
                            Get.to(() => LoginScreen());
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
                          backgroundColor: Colors.white38,
                          elevation: 0,
                          leading: TextButton(
                            child: const Icon(
                              Icons.menu,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              setState(() {
                                value == 0 ? value = 1 : value = 0;
                              });
                            },
                          ),
                          title: TextButton(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.firstName.toString()),
                                Text(widget.address.toString()),
                              ],
                            ),
                            onPressed: () {
                              Get.to(() =>
                                  LocationPicker(userEmail!, 'UserAddress'));
                            },
                          )),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.2,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                              items: imageSliders,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 8,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : const Color(0xff6936ab))
                                          .withOpacity(
                                              _current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CategoryTile('Electronics',
                                        'assets/images/electronics.png'),
                                    CategoryTile(
                                        'Apparel', 'assets/images/apparel.png'),
                                    CategoryTile(
                                        'Vehicle', 'assets/images/car.png'),
                                    CategoryTile(
                                        'Sports', 'assets/images/sport.png'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CategoryTile(
                                        'Home', 'assets/images/home.png'),
                                    CategoryTile(
                                        'Garden', 'assets/images/garden.png'),
                                    CategoryTile(
                                        'Beauty', 'assets/images/beauty.png'),
                                    CategoryTile(
                                        'Medicine', 'assets/images/pillcat.png'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CategoryTile(
                                        'Toys', 'assets/images/toyCat.png'),
                                    CategoryTile(
                                        'Watch', 'assets/images/watchCat.png'),
                                    CategoryTile(
                                        'Gadgets', 'assets/images/acesCat.png'),

                                    CategoryTile(
                                        'Grocery', 'assets/images/groceryCat.png'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CategoryTile(
                                        'Phones', 'assets/images/phoneCat.png'),
                                    CategoryTile(
                                        'Furniture', 'assets/images/furnitureCat.png'),
                                    CategoryTile(
                                        'Food', 'assets/images/foodCat.png'),
                                    CategoryTile(
                                        'Other', 'assets/images/otherCat.png'),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        // child: Text(
                        //   'No. ${imgList.indexOf(item)} image',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
