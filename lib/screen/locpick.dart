import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_marketing_system/models/DialogWidget.dart';
import 'package:smart_marketing_system/screen/homaScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
FirebaseFirestore _firestore = FirebaseFirestore.instance;
class LocationPicker extends StatefulWidget{
  String email;
  String type;
  LocationPicker(this.email,this.type, {Key? key}) : super(key: key);
  @override
  _LocationPickerState createState() => _LocationPickerState();
}
class _LocationPickerState extends State<LocationPicker> {
  late double lat;
  late double lng;
  //String googleApikey = "GOOGLE_MAP_API_KEY";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(33.5651, 73.0169);
  String location = "Location Name:";
  LatLng currentLocation=LatLng(33.5651, 73.0169);
  loc.Location _location = loc.Location();
  late GoogleMapController _controller;
  
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(
              l.latitude!,
              l.longitude!,
          ),zoom: 15),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: Stack(
            children:[

              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: _initialcameraposition, //initial position
                  zoom: 15.0, //initial zoom level
                ),
                mapType: MapType.normal, //map type
                onMapCreated: _onMapCreated,
                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona; //when map is dragging
                },
                onCameraIdle: () async { //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                  setState(() { //get place name from lat and lang
                    lat=cameraPosition!.target.latitude;
                    lng = cameraPosition!.target.longitude;
                    location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                  });
                },
              ),

              Center( //picker image on google map
                child: Image.asset("assets/images/picker.png", width: 80,),
              ),


              Positioned(  //widget to display location name
                  bottom:100,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            trailing: TextButton(onPressed: ()async{

                              //this will save location and lat lng
                              try{
                              await _firestore.collection(widget.type).doc(widget.email).set({
                                'email': widget.email,
                                'lat': lat,
                                'lng': lng,
                                'location':location,
                              });
                              Get.to(HomeScreen());}
                              catch(e){
                                showDialog(context: context, builder: (_)=>DialogWidget('Network Error'));
                                print(e);
                              }

                            }, child: const Icon(
                              Icons.save_alt_rounded,color: Color(0xff6936ab),
                            )),

                            title:Text(location, style: const TextStyle(fontSize: 18),),
                            dense: true,
                          )
                      ),
                    ),
                  )
              )
            ]
        )
    );
  }
}