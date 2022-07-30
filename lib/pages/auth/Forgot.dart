import 'package:ampluserv/Presenter/LoginPresenter.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:flutter/material.dart';
import 'package:ampluserv/constants/inputField.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> implements LoginScreenContract {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController email = new TextEditingController();
  bool autovalidate = false;
  Validations validations = new Validations();

  LoginScreenPresenter _presenter;

  _ForgetState() {
    _presenter = new LoginScreenPresenter(this);
  }

  void _submit() {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 4), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Please Wait...")
          ],
        ),
        ));
    final model = {"email":email.text};
    _presenter.doForget(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      color: primaryColor,
                    ),
                    Positioned(
                      bottom: 450.0,
                      right: 100.0,
                      child: Container(
                        height: 400.0,
                        width: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 500.0,
                      left: 150.0,
                      child: Container(
                          height: 300.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150.0),
                              color: primaryColor.withOpacity(0.5))),
                    ),

                    new Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 100.0, 32.0, 0.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  //padding: EdgeInsets.only(top: 100.0),
                                    child: new Material(
                                      borderRadius: BorderRadius.circular(7.0),
                                      elevation: 5.0,
                                      child: new Container(
                                        width: MediaQuery.of(context).size.width - 20.0,
                                        height: MediaQuery.of(context).size.height *0.55,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: new Form(
                                            child: new Container(
                                              padding: EdgeInsets.all(30.0),
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Forget Password', style: heading35Black,
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.emailAddress,
                                                          validator: validations.validateEmail,
                                                          controller: email,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            prefixIcon: Icon(Icons.email,
                                                                color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                            hintText: 'Email',
                                                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  new ButtonTheme(
                                                    height: 45.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                      elevation: 0.0,
                                                      color: blackColor,
                                                      icon: new Text(''),
                                                      label: new Text('SIGN UP', style: headingWhite,),
                                                      onPressed: (){
                                                        _submit();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("Already have an account? ",style: textGrey,),
                                        new InkWell(
                                          onTap: () => Navigator.pushNamed(context, '/login'),
                                          child: new Text("Sign In",style: textStyleActive,),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        )
                    ),
                  ]
                  )
                ]
            ),
          )

      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    Toast.show(errorTxt, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white);
  }

  @override
  void onLoginSuccess(chcUserModel user) {
    // TODO: implement onLoginSuccess
  }

  @override
  void onRegSuccess(user) {
    Toast.show(user, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor: Colors.green, textColor: Colors.white);

    Navigator.pushNamed(context, '/login');
  }
}