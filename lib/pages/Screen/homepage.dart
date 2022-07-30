import 'dart:async';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:ampluserv/pages/auth/login.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'config.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> implements AuthStateListener {
  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService  = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;

  GoogleMap googleMap;

  @override
  void initState() {
    super.initState();
    //_HomepageState();
    initPlatformState();
  }

  _HomepageState() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myString = prefs.getString('Session');
    if(myString.isEmpty){
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_ctx)=> LoginScreen())
        );

      });
    } else {

    }

  }

  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_OUT)
      Navigator.push(
          context,
          MaterialPageRoute(builder: (_ctx)=> LoginScreen())
      );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 7
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));

            if(mounted){
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if(serviceStatusResult){
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });

  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) {
      if(mounted){
        setState(() {
          _currentLocation = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          body: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/3.0,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: Carousel(
                          boxFit: BoxFit.cover,
                          images: [
                            AssetImage('assets/image/imga.jpeg',),
                            AssetImage('assets/image/imga.jpg',),
                            AssetImage('assets/image/imgb.jpg'),
                            AssetImage('assets/image/imgc.jpeg',),
                            AssetImage('assets/image/imgd.jpg'),
                          ],
                          autoplay: true,
                          // autoplayDuration: const Duration(seconds: 60),
                          animationCurve: Curves.easeIn,
                          showIndicator: true,
                          animationDuration: Duration(seconds: 2),
                          dotHorizontalPadding: 4.0,
                          dotBgColor: Colors.transparent,
                          dotSize: 4.0,
                          indicatorBgPadding: 2.0,
                        ),
                      ),
                    ),
                    Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 100.0),
                              child: Text(
                                "Welcome To Ampluserv Courier Services Inc",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 130.0),
                              child: Text(
                                "On Demand Delivery Services",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                Container(
                  //height: 215,
                  width: double.infinity,
                  padding:
                  EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "About Us",
                                style: textBoldBlackw,
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text("Ampluserv Courier Services Inc, founded in 2005, specializes in construction materials and hosehold items delivery among others. Service is our #1 one success storyWith the use of our robust online technology, you can request for any vehicle of your choice and we will deliver your packages to where you need them to be.We can also pick packages up for you.",
                                style: textStyleBlack,
                                textAlign: TextAlign.justify,)
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 300.0,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: _initialCamera,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      controller.setMapStyle('[{"featureType":"all","elementType":"all","stylers":[{"invert_lightness":true},{"saturation":10},{"lightness":20},{"gamma":0.7},{"hue":"#435158"}]}]');

                    },
                  ),
                ),
              ]
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () => _locationSubscription.cancel(),
            tooltip: 'Stop Track Location',
            child: Icon(Icons.stop),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        )
    );

  }
}