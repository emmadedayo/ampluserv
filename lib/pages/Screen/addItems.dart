import 'package:ampluserv/constants/inputField.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/keys.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:ampluserv/constants/customDialogInfo.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const double _kPickerSheetHeight = 216.0;

class AddItems extends StatefulWidget {
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController items_name = new TextEditingController();
  final TextEditingController sending_from = new TextEditingController();
  final TextEditingController pick_up_address = new TextEditingController();
  final TextEditingController sending_to = new TextEditingController();
  final TextEditingController delivered_address = new TextEditingController();
  final TextEditingController itemweight = new TextEditingController();

  RestDatasource _restDatasource = new RestDatasource();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _blackVisible = false;
  VoidCallback onBackPress;
  BuildContext _ctx;
  String budget,d;
  List<Map<String, dynamic>> listDeliveryTime = [{"id": 'Regular',"name" : 'Regular',},{"id": 'Express',"name" : 'Express',}
  ,{"id": 'Rush',"name" : 'Rush',}];
  String selectedDeliveryTime,selectedItemCategory,selectedVehicleType;
  List<Map<String, dynamic>> listItemCategory = [{"id": 'Electronics',"name" : 'Electronics',},
  {"id": 'House hold Item',"name" : 'House hold Item',},{"id": 'Construction materials',"name" : 'Construction materials',}
  ,{"id": 'medical materials',"name" : 'medical materials',}
  ,{"id": 'dangerous goods',"name" : 'dangerous goods',}
  ,{"id": 'skid of flooring',"name" : 'skid of flooring',}
  ,{"id": 'boxes  & others',"name" : 'boxes  & others',}];

  List<Map<String, dynamic>> VehicleTypeCategory = [{"id": 'Car',"name" : 'Car',},
  {"id": 'SUV',"name" : 'SUV',},{"id": 'SUV',"name" : 'SUV',}
  ,{"id": 'VAN',"name" : 'VAN',}
  ,{"id": 'CUB VAN',"name" : 'CUB VAN',}
  ,{"id": '5 TON TRUCK WITH TAILGATE',"name" : '5 TON TRUCK WITH TAILGATE',}];

  bool autovalidate = true;
  Validations validations = new Validations();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    _ctx = context;
    Size screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    new InputField(
                      hintText: "Items Name",
                      obscureText: false,
                      controller: items_name,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 10.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
                    ),
                    new InputField(
                      hintText: "Send From",
                      obscureText: false,
                      controller: sending_from,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
                    ),
                    new InputField(
                      hintText: "Detailed Pickup Address",
                      obscureText: false,
                      controller: pick_up_address,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
                    ),
                    new InputField(
                      hintText: "Sending To",
                      obscureText: false,
                      controller: sending_to,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
                    ),
                    new InputField(
                      hintText: "Detailed Delivery Address",
                      obscureText: false,
                      controller: delivered_address,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
                    ),
                    new InputField(
                      hintText: "Item Weight",
                      obscureText: false,
                      controller: itemweight,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      validateFunction: validations.validateName,
                      onSaved: (String value) {},
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
                                    hint: new Text("Delivery Time",style: textStyle,),
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
                                        value: value['code'],
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
                                        value: value['code'],
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
                                    hint: new Text("Pickup Vehicle Type",style: textStyle,),
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
                    ButtonTheme(
                      minWidth: screenSize.width,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        elevation: 0.0,
                        color: primaryColor,
                        child: new Text('Submit',style: headingWhite,),
                        onPressed: (){
                          //_signUp();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Offstage(
              offstage: !_blackVisible,
              child: GestureDetector(
                onTap: () {},
                child: AnimatedOpacity(
                  opacity: _blackVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],

        ),
      ),

    );
  }

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
