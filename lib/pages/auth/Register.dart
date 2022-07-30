import 'package:ampluserv/Presenter/LoginPresenter.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:flutter/material.dart';
import 'package:ampluserv/constants/inputField.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:toast/toast.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements LoginScreenContract {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = true;
  Validations validations = new Validations();

  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController phone = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  RestDatasource _restDatasource = new RestDatasource();
  List<Map<String, dynamic>> listUserType = [{"id": '2',"name" : 'Agent',},
  {"id": '3',"name" : 'Client',}];
  List<Map<String, dynamic>> ClientType = [{"id": 'Individual',"name" : 'Individual',},
  {"id": 'Business',"name" : 'Business',}];
  String selectedUsertype,selectedClientType,userlevel,client_type;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  LoginScreenPresenter _presenter;

  _SignUpScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  bool _isTextFieldVisible = true;
  bool passwordVisible;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                  image: ExactAssetImage('assets/image/login.jpeg'),fit: BoxFit.cover)),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Image.asset(
                      'assets/image/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                    child: new InputField(
                      hintText: "Fullname",
                      obscureText: false,
                      controller: name,
                      radius: 30.0,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      icon: Icons.person_pin,
                      iconColor: Colors.white,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),

                      onSaved: (String value) {},
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: new InputField(
                      hintText: "Username",
                      obscureText: false,
                      controller: username,
                      radius: 30.0,
                      textInputType: TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      icon: Icons.person_pin,
                      iconColor: Colors.white,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      onSaved: (String value) {},
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child:new InputField(
                      hintText: "Email",
                      obscureText: false,
                      controller: email,
                      radius: 30.0,
                      textInputType: TextInputType.emailAddress,
                      textStyle: textStyleWhite,
                      textFieldColor: textFieldColor,
                      icon: Icons.email,
                      iconColor: Colors.white,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      onSaved: (String value) {},
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child:new InputField(
                      hintText: "Phone Number",
                      obscureText: false,
                      controller: phone,
                      textInputType: TextInputType.number,
                      textStyle: textStyleWhite,
                      radius: 30.0,
                      textFieldColor: textFieldColor,
                      icon: Icons.phone,
                      iconColor: Colors.white,
                      bottomMargin: 20.0,
                      hintStyle: TextStyle(color: Colors.white),
                      onSaved: (String value) {},
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: DropdownButtonHideUnderline(
                        child: Container(
                          // padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 2.0),
                          child: new InputDecorator(
                            decoration: const InputDecoration(
                              //fillColor: Colors.blue
                            ),
                            isEmpty: selectedUsertype == null,
                            child: new DropdownButton<String>(
                              hint: new Text("Select User Type",style: textStyleWhite,),
                              value: selectedUsertype,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedUsertype = newValue;
                                  print(selectedUsertype);
                                  //getState(selectedUsertype);
                                  if(selectedUsertype == "3"){
                                    _isTextFieldVisible = !_isTextFieldVisible;
                                  } else {
                                    _isTextFieldVisible = _isTextFieldVisible;
                                  }

                                });
                              },
                              items: listUserType.map((value) {
                                return new DropdownMenuItem<String>(
                                  value: value['id'],
                                  child: new Text(value['name'],style: textGreen,),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                    ),
                  ),
                  _isTextFieldVisible
                  ?
                  SizedBox(
                    height: 25.0,
                  )
                  :
                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: DropdownButtonHideUnderline(
                        child: Container(
                          //  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 2.0),
                          child: new InputDecorator(
                            decoration: const InputDecoration(
                            ),
                            isEmpty: selectedClientType == null,
                            child: new DropdownButton<String>(
                              hint: new Text("Select Client Type",style: textStyleWhite,),
                              value: selectedClientType,
                              isDense: true,
                              onChanged: (String newValues) {
                                setState(() {
                                  selectedClientType = newValues;
                                  print(selectedClientType);
                                  // getState(selectedCountry);

                                });
                              },
                              items: ClientType.map((value) {
                                return new DropdownMenuItem<String>(
                                  value: value['id'],
                                  child: new Text(value['name'],style: textGreen,),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                    child: new InputField(
                      hintText: "Password",
                      obscureText: passwordVisible,
                      textInputType:
                      TextInputType.text,
                      textStyle: textStyleWhite,
                      textFieldColor:
                      textFieldColor,
                      controller: password,
                      radius: 30.0,
                      icon: Icons.lock_open,
                      iconColor: Colors.white,
                      bottomMargin: 20.0,
                      pass: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: whiteColor,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      onSaved: (String value){},
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Material(
                        borderRadius: BorderRadius.circular(5.0),
                        color: primaryColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          elevation: 0.0,
                          onPressed: () {
                            _signUp();
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: textStyleWhite,
                          ),
                        )),
                  ),

                  new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
                    child: new GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: new Text("Back to login?",
                        style: textStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    if(selectedUsertype != null){
      userlevel = selectedUsertype;
    }
    else{
      userlevel = "";
    }
    if(selectedClientType != null){
      client_type = selectedClientType;
    }
    else{
      client_type = "";
    }
    final model = {"name":name.text,"username":username.text,"phone":phone.text,"password":password.text,"email":email.text
      ,"userlevel":userlevel,"client_type":client_type};
    _presenter.doSignup(model);
  }

  _updateStatus(String reference, String message) {
    _showMessage('$reference \n\ $message',
        const Duration(seconds: 8));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
    Toast.show(errorTxt, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP, backgroundColor:redColor, textColor: Colors.white);

  }

  @override
  void onLoginSuccess(chcUserModel user) {
    // TODO: implement onLoginSuccess
  }

  @override
  void onRegSuccess(user) {
    _updateStatus("", user);
    Toast.show("Account Created Successfully, Please Check Your Mail For Confirmation", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP, backgroundColor:greenColor, textColor: Colors.white);
    Navigator.of(context).pushReplacementNamed("/login");
  }

   getState(String selectedUsertype) {
    return Padding(
      padding:
      EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: DropdownButtonHideUnderline(
          child: Container(
            //  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 2.0),
            child: new InputDecorator(
              decoration: const InputDecoration(
              ),
              isEmpty: selectedClientType == null,
              child: new DropdownButton<String>(
                hint: new Text("Select Client Type",style: textStyleWhite,),
                value: selectedClientType,
                isDense: true,
                onChanged: (String newValues) {
                  setState(() {
                    selectedClientType = newValues;
                    print(selectedClientType);
                    // getState(selectedCountry);

                  });
                },
                items: ClientType.map((value) {
                  return new DropdownMenuItem<String>(
                    value: value['id'],
                    child: new Text(value['name'],style: textStyle,),
                  );
                }).toList(),
              ),
            ),
          )
      ),
    );
  }
}
