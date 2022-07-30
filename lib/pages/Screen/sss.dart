import 'package:ampluserv/constants/inputFieldi.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/utils/Network_Url.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as Math;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:toast/toast.dart';

class ProductScreen extends StatefulWidget {

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String from,to,devo_title,theme_startdate,theme_type,id,message,distances;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  var _image;

  Network_Url _network_url = new Network_Url();
  String StringCode,Message;
  bool errors;
  RestDatasource _restDatasource = new RestDatasource();

  final TextEditingController product_name = new TextEditingController();
  final TextEditingController sending_region = new TextEditingController();
  final TextEditingController receiving_region = new TextEditingController();
  final TextEditingController distance = new TextEditingController();
  final TextEditingController pickupaddress = new TextEditingController();
  final TextEditingController deliveryaddress = new TextEditingController();
  final TextEditingController item_weight = new TextEditingController();

  List<Map<String, dynamic>> listDeliveryTime = [{"id": 'Regular',"name" : 'Regular',},{"id": 'Express',"name" : 'Express',}
  ,{"id": 'Rush',"name" : 'Rush',}];
  String selectedDeliveryTime,selectedItemCategory,selectedVehicleType,lastSelectedValue,str_delivery_time,str_item_cat,_str_veh_type;
  List<Map<String, dynamic>> listItemCategory = [{"id": 'Electronics',"name" : 'Electronics',},
  {"id": 'House hold Item',"name" : 'House hold Item',},{"id": 'Construction materials',"name" : 'Construction materials',}
  ,{"id": 'medical materials',"name" : 'medical materials',}
  ,{"id": 'dangerous goods',"name" : 'dangerous goods',}
  ,{"id": 'skid of flooring',"name" : 'skid of flooring',}
  ,{"id": 'boxes  & others',"name" : 'boxes  & others',}];

  List<Map<String, dynamic>> VehicleTypeCategory = [{"id": 'Car',"name" : 'Car',},
  {"id": 'SUV',"name" : 'SUV',}
  ,{"id": 'VAN',"name" : 'VAN',}
  ,{"id": 'CUB VAN',"name" : 'CUB VAN',}
  ,{"id": '5 TON TRUCK WITH TAILGATE',"name" : '5 TON TRUCK WITH TAILGATE',}];

  bool passwordVisible;
  bool passwordVisibles;


  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from = prefs.getString('from_address') ?? '';
    to = prefs.getString('to_address') ?? '';
    distances = prefs.getString('distance_new') ?? '';
    sending_region.text = from;
    receiving_region.text = to;
    distance.text = distances + "km";
    // _presenter.getPrayer(myString);
    //print("Session" + myString);
  }

  var db = new DatabaseHelper();
  chcUserModel _userModel;

  dbDetails() async {
    _userModel = await db.getClient();
    setState(() {
      print(_userModel.api_token);
      _userModel;
    });
  }

  Future getImageLibrary() async {
    var gallery =
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(gallery.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image,500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));
    setState(() {
      _image = compressImg;
    });
  }

  Future cameraImage() async {
    var gallery =
    await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(gallery.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));
    setState(() {
      _image = compressImg;
    });
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera(context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: const Text('Select Camera'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Photo Library'),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    //print("Date"+widget.detail.id);
    super.initState();
    _incrementCounter();
    dbDetails();
    // _isLoading = true;
  }

  @override
  void dispose() {
    // _incrementCounter();
    /* ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text('Item Details',maxLines: 2,style: TextStyle(color: blackColor),),
          backgroundColor: whiteColor,
          elevation: 2.0,
          iconTheme: IconThemeData(color: blackColor),

          actions: <Widget>[
            //verify(approved_status),

            new IconButton(
                icon: Icon(FontAwesomeIcons.paperPlane,color: primaryColor, size: 18,),
                onPressed: (){
                  postImage(context);
                }
            ),

          ]

      ),
      body: Stack(
        children: <Widget>[
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 30.0),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 20.0),
                    child: new Form(
                      key: formKey,
                      autovalidate: autovalidate,
                      child: new Column(
                        children: <Widget>[
                          // error_d(),
                          new Column(
                            children: <Widget>[
                              new InputFieldi(
                                hintText: "Items name",
                                obscureText: false,
                                controller: product_name,
                                textInputType: TextInputType.text,
                                textStyle: textStyleBlack,
                                textFieldColor: textFieldColor,
                                visible: true,
                                icon: Icons.edit,
                                iconColor: Colors.white,
                                radius: 10,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                validateFunction: validations.validateName,
                                onSaved: (String value) {},
                              ),
                              new InputFieldi(
                                hintText: "Sending Region",
                                obscureText: false,
                                controller: sending_region,
                                textInputType: TextInputType.text,
                                textStyle: textStyleBlack,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                visible: false,
                                icon: Icons.location_city,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                onSaved: (String value) {},
                              ),
                              new InputFieldi(
                                hintText: "Direction To PickUp",
                                obscureText: false,
                                controller: pickupaddress,
                                textInputType: TextInputType.emailAddress,
                                textStyle: textStyleBlack,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                visible: true,
                                icon: Icons.directions,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                validateFunction: validations.validateName,
                                onSaved: (String value) {},
                              ),
                              new InputFieldi(
                                hintText: "Sending To",
                                obscureText: false,
                                controller: receiving_region,
                                textInputType: TextInputType.number,
                                textStyle: textStyleBlack,
                                visible: false,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                icon: Icons.location_city,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              new InputFieldi(
                                hintText: "Distance",
                                obscureText: false,
                                controller: distance,
                                textInputType: TextInputType.number,
                                textStyle: textStyleBlack,
                                visible: false,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                icon: Icons.format_align_right,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                onSaved: (String value) {},
                              ),
                              new InputFieldi(
                                hintText: "Direction to delivery address",
                                obscureText: false,
                                controller: deliveryaddress,
                                textInputType: TextInputType.text,
                                textStyle: textStyleBlack,
                                visible: true,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                icon: Icons.directions,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                onSaved: (String value) {},
                                validateFunction: validations.validateName,


                              ),
                              new InputFieldi(

                                hintText: "Item Weight",
                                obscureText: false,
                                controller: item_weight,
                                textInputType: TextInputType.phone,
                                textStyle: textStyleBlack,
                                visible: true,
                                textFieldColor: textFieldColor,
                                radius: 10,
                                icon: Icons.line_weight,
                                iconColor: Colors.white,
                                bottomMargin: 20.0,
                                hintStyle: TextStyle(color: Colors.white),
                                onSaved: (String value) {},
                                validateFunction: validations.validateName,

                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 10.0),
                                          child: new InputDecorator(
                                            decoration: const InputDecoration(
                                            ),
                                            isEmpty: selectedDeliveryTime == null,
                                            child: new DropdownButton<String>(
                                              hint: new Text("Service Booking",style: textStyle,),
                                              value: selectedDeliveryTime,
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectedDeliveryTime = newValue;
                                                  print(selectedDeliveryTime);

                                                });
                                              },
                                              items: listDeliveryTime.map((value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value['id'],
                                                  child: new Text(value['name'],style: textStyle,),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),

                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 10.0),
                                          child: new InputDecorator(
                                            decoration: const InputDecoration(
                                            ),
                                            isEmpty: selectedItemCategory == null,
                                            child: new DropdownButton<String>(
                                              hint: new Text("Items Category",style: textStyle,),
                                              value: selectedItemCategory,
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectedItemCategory = newValue;
                                                  print(selectedItemCategory);

                                                });
                                              },
                                              items: listItemCategory.map((value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value['id'],
                                                  child: new Text(value['name'],style: textStyle,),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 2.0),
                                          child: new InputDecorator(
                                            decoration: const InputDecoration(
                                            ),
                                            isEmpty: selectedVehicleType == null,
                                            child: new DropdownButton<String>(
                                              hint: new Text("Vehicle Type",style: textStyle,),
                                              value: selectedVehicleType,
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectedVehicleType = newValue;
                                                  print(selectedVehicleType);

                                                });
                                              },
                                              items: VehicleTypeCategory.map((value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value['id'],
                                                  child: new Text(value['name'],style: textStyle,),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                color: Colors.grey[100],
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Item Image",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black),
                                    )),
                              ),
                              Container(
                                color: whiteColor,
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: new ClipRRect(
                                          borderRadius: new BorderRadius.circular(2.0),
                                          child:_image == null
                                              ?new GestureDetector(
                                              onTap: (){selectCamera(context);},
                                              child: new Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  color: primaryColor,
                                                  child: new Image.asset('assets/image/1.png',fit: BoxFit.cover, height: 100.0,width: 100.0,)
                                              )
                                          ): new GestureDetector(
                                              onTap: () {selectCamera(context);},
                                              child: new Container(
                                                height: 100.0,
                                                width: 100.0,
                                                child: Image.file(_image,fit: BoxFit.cover, height: 100.0,width: 100.0,),
                                              )
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonTheme(
                                minWidth: screenSize.width,
                                height: 50.0,
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                  elevation: 0.0,
                                  color: primaryColor,
                                  child: new Text('SEND',style: headingWhites,),
                                  onPressed: (){
                                    postImage(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],

      ),
    );
  }

  void postImage(context) async {
    if (_image == null) {
      Toast.show(
          "Please Upload Product Image", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: redColor,
          textColor: Colors.white);
    } else {
      scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 10), content:
          new Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              new Text("  Please Wait...")
            ],
          ),
          ));
      var stream = new http.ByteStream(
          DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = _network_url.PostService('postItems');
      //print(myString);
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + _userModel.api_token
      };

      final multipartRequest = new http.MultipartRequest(
          'POST', Uri.parse(uri));
      multipartRequest.headers.addAll(headers);
      var multipartFile = new http.MultipartFile("image", stream, length,
          filename: basename(_image.path));
      multipartRequest.fields['product_name'] = product_name.text;
      multipartRequest.fields['sending_region'] = sending_region.text;
      multipartRequest.fields['receiving_region'] = receiving_region.text;
      multipartRequest.fields['distance'] = distance.text;
      multipartRequest.fields['pickupaddress'] = pickupaddress.text;
      multipartRequest.fields['deliveryaddress'] = deliveryaddress.text;
      multipartRequest.fields['item_weight'] = item_weight.text;
      multipartRequest.fields['delivery_time'] =
      selectedDeliveryTime == null ? "" : selectedDeliveryTime;
      multipartRequest.fields['category'] =
      selectedItemCategory == null ? "" : selectedItemCategory;
      multipartRequest.fields['pickup_vehicle'] =
      selectedVehicleType == null ? "" : selectedVehicleType;
      multipartRequest.files.add(multipartFile);

      var response = await multipartRequest.send();
      // var res = json.decode(response.stream.transform(streamTransformer))


      if (response.statusCode == 200) {
        Toast.show("Product successfully added. ", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: blackColor,
            textColor: Colors.white);
        Navigator.of(context).pop();
      } else {
        Toast.show(
            "Unable to add your items, please contact the admin", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: blackColor,
            textColor: Colors.white);
      }
      response.stream.transform(utf8.decoder).listen((value) {
        //print(value);
        StringCode = value.contains("error").toString();
        Message = value.contains("message").toString();
        bool b = StringCode == 'true';
        if (errors) {
          Toast.show(Message, context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              backgroundColor: redColor,
              textColor: Colors.white);
        } else {
          // Navigator.of(context).pushNamedAndRemoveUntil('/view', (Route<dynamic> route) => true);

          Toast.show(Message, context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              backgroundColor: greenColor,
              textColor: Colors.white);
        }
      });
    }
  }
}
