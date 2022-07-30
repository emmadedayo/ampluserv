import 'package:ampluserv/Blocs/place_bloc.dart';
import 'package:ampluserv/Repository/placeService.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:ampluserv/models/place_item_res.dart';
import 'package:ampluserv/models/trip_info_res.dart';
import 'package:ampluserv/pages/Screen/ride_picker.dart';
import 'package:ampluserv/requests/google_maps_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:ampluserv/constants/customDialogInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ampluserv/config.dart' as prefix1;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'ProductSend.dart';

const double _kPickerSheetHeight = 216.0;

class PersonalProfile extends StatefulWidget {
  _PersonalProfileState createState() => _PersonalProfileState();

}

class _PersonalProfileState extends State<PersonalProfile> implements AuthStateListener{
  final String screenName = "HOME";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController items_name = new TextEditingController();
  final TextEditingController sending_from = new TextEditingController();
  final TextEditingController pick_up_address = new TextEditingController();
  final TextEditingController sending_to = new TextEditingController();
  final TextEditingController delivered_address = new TextEditingController();
  final TextEditingController itemweight = new TextEditingController();
  BuildContext _ctx;
  RestDatasource _restDatasource = new RestDatasource();
  final scaffoldKey = new GlobalKey<ScaffoldState>();


  bool autovalidate = true;
  Validations validations = new Validations();
  var placeBloc = PlaceBloc();
  var _tripDistance = 0;
  String apiKey = prefix1.ApiKey;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  final Map<String, Marker> _markerss = <String, Marker>{};
  var fromLatLng,toLatLng, from_address,to_address,ssss;
  double ffk;
  double frm_lat,frm_lng,to_lat,to_lng;
  String type,kmm;
  int kmInDec;
  bool _isLoading;

  Map<MarkerId, Marker> _newmarkers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;


  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getUserLocation();
    _incrementCounter();
  }
  //static const LatLng _initialPosition = const LatLng(56.1303673, -106.3467712);

  void _getUserLocation() async {
   /* Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
        setState(() {*/
          _initialPosition = LatLng(56.1303673, -106.3467712);
          _isLoading = false;
        /*});

     //_initialPosition = LatLng(position.latitude, position.longitude);

    print("initial position is : ${_initialPosition.toString()}");*/
    //locationController.text = placemark[0].name;
    // notifyListeners();
  }

  void from_session(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('from_address', id);
  }

  void to_session(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('to_address', id);
  }

  void distance_new(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('distance_new', id);
  }

  _PersonalProfileState() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString('Usertype');
  }







  void onPlaceSelected(PlaceItem place, fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    // _mapController.clearMarkers();

    if(mkId == "from_address"){
      fromLatLng = LatLng(place.lat, place.lng);
      frm_lat = place.lat;
      frm_lng = place.lng;
      from_address = place.address;
      from_session(from_address);
      _markers.remove(place);
      _markers.remove(mkId);
     // print("FROM ADDRESS"+from_address);

    }
    if(mkId == "to_address"){
      toLatLng = LatLng(place.lat, place.lng);
      to_lat = place.lat;
      to_lng = place.lng;
      to_address = place.address;
      to_session(to_address);
      _markers.remove(place);
      _markers.remove(mkId);
     // print("TO ADDRESS"+to_address);
    }

    setState(() {
      _addMarker(mkId, place);

    });
  }


  void _addMarker(mkId, PlaceItem place) async {
    _markers.remove(mkId);
    _markers.clear();
    _markers.remove(place);
    _markers.add(Marker(
        markerId: MarkerId(mkId),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title:place.name , snippet: place.address),
        icon: BitmapDescriptor.defaultMarker));

   // _markers.removeAll();

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
         CameraPosition(
          bearing: 360.0,
          target: LatLng(place.lat, place.lng),
          tilt: 30.0,
          zoom: 10.0,
        ),
      ),
    );

    String route = await _googleMapsServices.getRouteCoordinates(fromLatLng,toLatLng);

    calculateDistance();



    //Geocoder::Calculations.distance_between([47.858205,2.294359], [40.748433,-73.985655]);

    /*final Distance distance = new Distance();

    // km = 423
    final int km = distance.as(LengthUnit.Kilometer,
        new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));*/
/*    final harvesine = new Haversine.fromDegrees(latitude1: lat1,
        longitude1: lon1,
        latitude2: lat2,
        longitude2: lon2);

    print('Distance from location 1 to 2 is : ${harvesine.distance()}');*/
    setState(() {
      createRoute(route);
    });
  }

  calculateDistance(){
    PlaceService.getStep(frm_lat, frm_lng, to_lat, to_lng).then((vl) {
      TripInfoRes infoRes = vl;
      NumberFormat formatter = new NumberFormat("####");

      setState(() {
        _tripDistance = infoRes.distance;
        double bv = _tripDistance / 1000;
        kmInDec = int.parse(formatter.format(bv));
        kmm = kmInDec.toString();
        distance_position(kmm);
        distance_new(kmInDec.toString());
      });
    //  print("New  " + kmInDec.toString());
    });
  }



  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    // notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    // notifyListeners();
    setState(() {
      _lastPosition;
      });
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
   // _mapController = controller;
    //setState(() {
      _mapController = controller;
    //});
    //notifyListeners();
  }

  Widget build(BuildContext context) {
    _ctx = context;
    Size screenSize = MediaQuery.of(context).size;
    print("GGVHBHBDHBDJBJD"+_initialPosition.toString());
    SystemChrome.setEnabledSystemUIOverlays ([]);
    if(type == "2"){
      return Scaffold(
        key: scaffoldKey,
        body:Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: GoogleMap(
//              key: ggKey,
                  onMapCreated: onCreated,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  onCameraMove:onCameraMove,
                  myLocationEnabled: true,
                  polylines: polyLines,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition , zoom: 5,
                  ),
                ),
              ),
             /* new Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: RidePicker(onPlaceSelected),
              ),*/
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        key: scaffoldKey,
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: GoogleMap(
//              key: ggKey,
                  onMapCreated: onCreated,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  onCameraMove:onCameraMove,
                  myLocationEnabled: true,
                  polylines: polyLines,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition , zoom: 5,
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: RidePicker(onPlaceSelected),
              ),

              distance_position(kmm),
            ],
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 7.0,
          color: Colors.white,
          child: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: kmInDec == null
              ?Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: redColor,
                    width: MediaQuery.of(context).size.width,
                    child:GestureDetector(
                      onTap: () {

                      },
                      child: Center(
                        child: Text(
                          'Select Address',
                          style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 19.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),

                      ),
                    ),
                  ),
                ],
            ):
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: greenColor,
                  width: MediaQuery.of(context).size.width,
                  child:GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> ProductScreen())
                      );
                    },
                    child: Center(
                      child: Text(
                        'Start',
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 19.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      );
    }

  }


  distance_position(kmm){
    if(kmm == null){

      return Positioned(
        bottom: 48, right: 0, left: 0, height: 50,
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Total Distance (" "): ",
                style: TextStyle(fontSize: 18, color: Colors.black),),
            ],
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 48, right: 0, left: 0, height: 50,
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Total Distance (" + kmm + "): ",
                style: TextStyle(fontSize: 18, color: Colors.black),),
            ],
          ),
        ),
      );
    }
  }
  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_OUT)
      Navigator.of(_ctx).pushReplacementNamed("/login");
  }
/*   void _moveCamera() {
    print("move camera: ");
    print(_markers);

    if (_markers.values.length > 1) {
      var fromLatLng = _markers["from_address"].options.position;
      var toLatLng = _markers["to_address"].options.position;

      var sLat, sLng, nLat, nLng;
      if(fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if(fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController.animateCamera(CameraUpdate.newLatLng(
          _markers.values.elementAt(0).options.position));
    }
  }*/

/*  void _checkDrawPolyline() {
//  remove old polyline
    _mapController.clearPolylines();

    if (_markers.length > 1) {
      var from = _markers["from_address"].options.position;
      var to = _markers["to_address"].options.position;
      PlaceService.getStep(
              from.latitude, from.longitude, to.latitude, to.longitude)
          .then((vl) {
            TripInfoRes infoRes = vl;

            _tripDistance = infoRes.distance;
            setState(() {
            });
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }

//        print(paths);
        _mapController.addPolyline(PolylineOptions(
            points: paths, color: Color(0xFF3ADF00).value, width: 10));
      });
    }
  }*/


  dialogInfo(_message){
    return customDialogInfo(
        title: "Registration Response",
        body: _message,
        onTap: () {
          Navigator.of(context).pop();
          /*Navigator.push(context,
            MaterialPageRoute(builder: (context)=> SignInScreen()));
      },*/
        }
    );
  }
  /* _signUp(){
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 4), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Please Wait...")
          ],
        ),
        ));
    final model = {"budget":budget,"fullname":fullname.text,"username":username.text,"password":password.text,"phone":phone_number.text,"email":email.text};
    print(model);
    _restDatasource.UserRegistration(model).then((res) {
      if(res["statusCode"] == "200"){
        showDialog(context: context, child: dialogInfo(res["message"]));

      } else {
        _showSnackBar(res["message"]);
      }
    }).catchError((onError) => {
    _showSnackBar("Something Went Wrong, Try Again Later")
    });
  }*/
  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }



}
