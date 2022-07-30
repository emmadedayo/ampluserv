import 'package:ampluserv/Presenter/LoginPresenter.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';


class ChangePassScreen extends StatefulWidget {

  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> implements LoginScreenContract {
  String from,to,devo_title,theme_startdate,theme_type,id,message,distances;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  var _image;

  Network_Url _network_url = new Network_Url();
  RestDatasource _restDatasource = new RestDatasource();

  final TextEditingController password = new TextEditingController();
  final TextEditingController confirm_password = new TextEditingController();


  bool passwordVisible;
  bool passwordVisibles;


  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from = prefs.getString('Session') ?? '';
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

  LoginScreenPresenter _presenter;

  _ChangePassScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  void _signUp(){

    scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 4), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Please Wait...")
          ],
        ),
        ));
    final model = {"password":password.text,"password_confirmation":confirm_password.text};
    _presenter.changePassword(model,from);
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
      key: scaffoldKey,
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
                                  hintText: "Password",
                                  obscureText: false,
                                  controller: password,
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
                                  hintText: "Confirm Password",
                                  obscureText: false,
                                  controller: confirm_password,
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

                                ButtonTheme(
                                  minWidth: screenSize.width,
                                  height: 50.0,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                    elevation: 0.0,
                                    color: primaryColor,
                                    child: new Text('CHANGE PASSWORD',style: headingWhites,),
                                    onPressed: (){
                                      _signUp();
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

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
    password.clear();
    confirm_password.clear();
    print(errorTxt);
    Toast.show(errorTxt, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP, backgroundColor:redColor, textColor: Colors.white);

  }

  @override
  void onLoginSuccess(chcUserModel user) {
    // TODO: implement onLoginSuccess
  }

  @override
  void onRegSuccess(user) {
    // TODO: implement onRegSuccess
    password.clear();
    confirm_password.clear();
    Toast.show(user, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP, backgroundColor:green1, textColor: Colors.white);

  }
}
