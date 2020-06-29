import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocerry_app/Modal/auth.dart';
import 'package:flutter_grocerry_app/Modal/users.dart';
import 'package:flutter_grocerry_app/Widgets/colors.dart';
import 'package:flutter_grocerry_app/Widgets/customButton.dart';
import 'package:flutter_grocerry_app/Widgets/inputFields.dart';
import 'package:flutter_grocerry_app/Widgets/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';


class UserInfoPage extends StatefulWidget {
  static final String routName = '/UserInfoPage';
  final String pageTitle;

  UserInfoPage({Key key, this.pageTitle}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String name, office, street;
  final Map<String, Marker> _markers = {};
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _markers.clear();
        final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        );
        _markers["Current Location"] = marker;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.thoroughfare} ${place.subLocality},${place.locality}, ${place.postalCode},${place.administrativeArea},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentLocation();
    });
  }

  var scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthUser>(context, listen: false);
    print(user.phoneNo);
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        title: Text('User Info',
            style: TextStyle(
                color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
      ),
      body: _currentAddress != null
          ? Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: GoogleMap(
                      markers: _markers.values.toSet(),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 16,
                        tilt: 60,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 18, right: 18),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    Container(
                                      width: 240,
                                      child: Text(
                                        _currentAddress,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                fryoTextInput('Username', onChanged: (value) {
                                  name = value;
                                }),
                                fryoTextInput('flat/House/office No',
                                    onChanged: (value) {
                                  office = value;
                                }),
                                fryoTextInput('street/society',
                                    onChanged: (value) {
                                  street = value;
                                }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    width: double.infinity,
                    decoration: userInfoPlateDecoration,
                  ),
                ),
                Container(
                  height: 40,
                  color: white,
                  width: double.infinity,
                  child: CustomFlatButton(
                    text: 'Save',
                    onPress: () {
                      Firestore.instance
                          .collection('users')
                          .document(user.userId)
                          .setData(
                            User.fromUser(
                              User(
                                  name: name,
                                  address: '$office,$street,$_currentAddress',
                                  number: int.parse(user.phoneNo),
                                  orders:[]
                              ),
                            ),
                          )
                          .whenComplete(() {
                        Navigator.pushReplacementNamed(
                            context, HomePage.routName);
                      });
                    },
                  ),
                )
              ],
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
