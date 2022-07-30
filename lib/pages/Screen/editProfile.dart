import 'package:ampluserv/constants/customDialogInfo.dart';
import 'package:ampluserv/constants/inputFieldi.dart';
import 'package:ampluserv/constants/loading.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/Data.dart';
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

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String from,to,devo_title,theme_startdate,theme_type,id,message,distances;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  var _image;

  Network_Url _network_url = new Network_Url();
  RestDatasource _restDatasource = new RestDatasource();

  final TextEditingController name = new TextEditingController();
  final TextEditingController lastname = new TextEditingController();
  final TextEditingController phone = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController occupation = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController username = new TextEditingController();

  List<Map<String, dynamic>> listDeliveryTime = [{"id": 'Male',"name" : 'Male',},{"id": 'Female',"name" : 'Female',}
  ,{"id": 'Rush',"name" : 'Rush',}];
  String genders,ages,gender,age,selectedVehicleType,lastSelectedValue,str_delivery_time,str_item_cat,image;

  List<Map<String, dynamic>> listItemCategory = [{"id": '10-20',"name" : '10-20',},
  {"id": '20-30',"name" : '20-30',},{"id": '30-40',"name" : '40-50',}];


  bool passwordVisible;
  bool passwordVisibles;


  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from = prefs.getString('Session') ?? '';

    _restDatasource.ProfileDetails(from).then((res) {
      if(res["statusCode"] == "200"){
        setState(() {
          name.text = res["message"]["name"];
          lastname.text = res["message"]["lastname"];
          phone.text  = res["message"]["phone"];
          address.text = res["message"]["address"];
          occupation.text = res["message"]["occupation"];
          email.text = res["message"]["email"];
          username.text = res["message"]["username"];
          genders = res["message"]["gender"];
          ages = res["message"]["age"];
          image = res["message"]["picname"];

          //print("SSSSS" +res);
/*
          if(fetchcountry != null){
            selectedCountry = fetchcountry;
          }else {
            selectedCountry = null;
          }
          if(fetchstate != null){
            selectedIdentification = fetchstate;
          }else {
           // selectedIdentification = "";
          }
*/

        });
      } else {


      }
    }).catchError((onError) => {
    print(onError.toString())
    });
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
  Widget build(BuildContext context) {
   // _ctx = context;
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(top: 10.0),
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
                                    hintText: "Firstname",
                                    obscureText: false,
                                    controller: name,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyleBlack,
                                    textFieldColor: textFieldColor,
                                    visible: true,
                                    icon: Icons.person_pin,
                                    iconColor: Colors.white,
                                    radius: 10,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    validateFunction: validations.validateName,
                                    onSaved: (String value) {},
                                  ),

                                  new InputFieldi(
                                    hintText: "Lastname",
                                    obscureText: false,
                                    controller: lastname,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyleBlack,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    visible: true,
                                    icon: Icons.person_pin,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    onSaved: (String value) {},
                                  ),
                                  new InputFieldi(
                                    hintText: "Email",
                                    obscureText: false,
                                    controller: email,
                                    textInputType: TextInputType.emailAddress,
                                    textStyle: textStyleBlack,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    visible: false,
                                    icon: Icons.email,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    validateFunction: validations.validateName,
                                    onSaved: (String value) {},
                                  ),

                                  new InputFieldi(
                                    hintText: "Username",
                                    obscureText: false,
                                    controller: username,
                                    textInputType: TextInputType.emailAddress,
                                    textStyle: textStyleBlack,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    visible: false,
                                    icon: Icons.email,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    validateFunction: validations.validateName,
                                    onSaved: (String value) {},
                                  ),
                                  new InputFieldi(
                                    hintText: "Phone",
                                    obscureText: false,
                                    controller: phone,
                                    textInputType: TextInputType.number,
                                    textStyle: textStyleBlack,
                                    visible: true,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    icon: Icons.phone,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  new InputFieldi(
                                    hintText: "Address",
                                    obscureText: false,
                                    controller: address,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyleBlack,
                                    visible: true,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    icon: Icons.phone,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    onSaved: (String value) {},
                                  ),
                                  new InputFieldi(
                                    hintText: "Occupation",
                                    obscureText: false,
                                    controller: occupation,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyleBlack,
                                    visible: true,
                                    textFieldColor: textFieldColor,
                                    radius: 10,
                                    icon: Icons.phone,
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
                                                isEmpty: genders == null,
                                                child: new DropdownButton<String>(
                                                  hint: new Text("Gender",style: textStyle,),
                                                  value: gender,
                                                  isDense: true,
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      gender = newValue;
                                                      print(gender);

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
                                                isEmpty: age == null,
                                                child: new DropdownButton<String>(
                                                  hint: new Text("Age",style: textStyle,),
                                                  value: age,
                                                  isDense: true,
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      age = newValue;
                                                      print(age);

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
                                  Container(
                                    color: whiteColor,
                                    padding: EdgeInsets.all(10.0),
                                    margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Material(
                                          elevation: 5.0,
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: new ClipRRect(
                                              borderRadius: new BorderRadius.circular(100.0),
                                              child:_image == null
                                                  ?new GestureDetector(
                                                  onTap: (){selectCamera(context);},
                                                  child: new Container(
                                                      height: 80.0,
                                                      width: 80.0,
                                                      color: primaryColor,
                                                      child: image == null ?
                                                      new Image.asset('assets/image/1.png',fit: BoxFit.cover, height: 80.0,width: 80.0,)
                                                          : new Image.network(_network_url.ImageService(image),fit: BoxFit.cover, height: 100.0,width: 100.0,)
                                                  )
                                              ): new GestureDetector(
                                                  onTap: () {selectCamera(context);},
                                                  child: new Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    child: Image.file(_image,fit: BoxFit.cover, height: 800.0,width: 80.0,),
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
                                      child: new Text('UPDATE',style: headingWhites,),
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
                        ))
                  ],
                ),
              ],
            ),
          ],

        ),
    );
  }

  void postImage(context) async {

    if(_image == null){

      Toast.show("Please Upload Profile Image", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:redColor, textColor: Colors.white);


    } else {

      var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = _network_url.PostService('updateProfile');
      //print(myString);
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + _userModel.api_token
      };

      final multipartRequest = new http.MultipartRequest('POST', Uri.parse(uri));
      multipartRequest.headers.addAll(headers);
      var multipartFile = new http.MultipartFile("image", stream, length,
          filename: basename(_image.path));
      multipartRequest.fields['name'] = name.text;
      multipartRequest.fields['lastname'] = lastname.text;
      multipartRequest.fields['phone'] = phone.text;
      multipartRequest.fields['address'] = address.text;
      multipartRequest.fields['occupation'] = occupation.text;
      multipartRequest.fields['gender'] = gender == null? "" : gender;
      multipartRequest.fields['age'] = age == null? "" : age;
      multipartRequest.files.add(multipartFile);

      var response = await multipartRequest.send();
       if (response.statusCode == 200) {
        Toast.show("Product successfully added. ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:green1, textColor: Colors.white);
        _incrementCounter();
        //  comment.clear();
      } else {

        Toast.show("Unable to add your items, please contact the admin", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:redColor, textColor: Colors.white);

      }
      response.stream.transform(utf8.decoder).listen((value) {
        _incrementCounter();
        print(value);
        Toast.show(value, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:blackColor, textColor: Colors.white);

      });
    }

  }
}
