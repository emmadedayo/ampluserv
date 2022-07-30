import 'package:ampluserv/constants/ScreenLoading.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/pages/Menu/Menus.dart';
import 'package:ampluserv/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:ampluserv/constants/style.dart';
//import 'package:flutter_map_booking/Screen/Home/home3.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:ampluserv/constants/inputField.dart';
import 'package:ampluserv/constants/validations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/chcVerification.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:ampluserv/Presenter/LoginPresenter.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class aLoginScreen extends StatefulWidget {
  @override
  _aLoginScreenState createState() => _aLoginScreenState();
}

class _aLoginScreenState extends State<aLoginScreen> implements LoginScreenContract,AuthStateListener  {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController username = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  LoginScreenPresenter _presenter;
  BuildContext _ctx;
  bool passwordVisible;
  bool _loadingVisible = false;
  _aLoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() async{
    if (formKey.currentState.validate()) {
      // No any error in validation
      formKey.currentState.save();
      /*print("Name $name");
      print("Mobile $mobile");
      print("Email $email");*/

      await _changeLoadingVisible();
      final model = {"email":username.text,"password":password.text};
      _presenter.Logins(model);

    } else {
      Toast.show("All fields are required", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: redColor, textColor: Colors.white);
      setState(() {
        autovalidate = true;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    super.dispose();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _ctx = context;
    return Scaffold(
      key: scaffoldKey,
      body:  LoadingScreen(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                      image: ExactAssetImage('assets/image/login.jpeg'),fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    flex: 4,
                    child: new Center(
                      child: Image.asset(
                        'assets/image/logo.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 20.0),
                        child: new Form(
                          key: formKey,
                          autovalidate: autovalidate,
                          child: new Column(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new InputField(
                                    hintText: "Email / Username",
                                    obscureText: false,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyleWhite,
                                    textFieldColor: textFieldColor,
                                    icon: Icons.person,
                                    iconColor: Colors.white,
                                    controller: username,
                                    radius: 30.0,
                                    bottomMargin: 25.0,
                                    hintStyle: TextStyle(color: Colors.white),
                                    validateFunction: validations.validateLogin,
                                    onSaved: (String value) {},
                                  ),
                                  new InputField(
                                    hintText: "Password",
                                    controller: password,
                                    obscureText: passwordVisible,
                                    textInputType:
                                    TextInputType.text,
                                    textStyle: textStyleWhite,
                                    textFieldColor:
                                    textFieldColor,
                                    icon: Icons.lock_open,
                                    radius: 30.0,
                                    iconColor: Colors.white,
                                    bottomMargin: 25.0,
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
                                    validateFunction: validations
                                        .validatePassword,
                                    onSaved: (String value){},
                                  )],
                              ),
                              ButtonTheme(
                                minWidth: screenSize.width,
                                height: 50.0,
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                  elevation: 0.0,
                                  color: primaryColor,
                                  child: new Text('LOGIN',style: headingWhite,),
                                  onPressed: (){
                                    _submit();
                                  },
                                ),
                              ),

                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> LoginScreen())
                                  );
                                },
                                child:Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("Click here to login as user",style: textStyleActive,),
                                      ],
                                    )
                                ),
                              ),
                              /* new Container(
                                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text("Agent Login ",style: textGrey,),
                                    new InkWell(
                                      onTap: () => Navigator.pushNamed(context, '/alogin'),
                                      child: new Text("Agent Login",style: textStyleActive,),
                                    ),
                                  ],
                                )
                            ),*/
                              new Container(
                                  padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 30.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        flex: 2,
                                        child: new GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, '/signup'),
                                          child: new Text("Create new account?",
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      new Expanded(
                                        flex: 2,
                                        child: new GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, '/forget'),
                                          child: new Text("Forgot Password?",
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }
  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }
  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_IN)
      Navigator.push(
          _ctx,
          MaterialPageRoute(builder: (_ctx)=> Menus())
      );
    // Navigator.of(_ctx).pushReplacementNamed("/meuns");
    //Navigator.of(context).pushNamedAndRemoveUntil('/menu', (Route<dynamic> route) => true);
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
    _changeLoadingVisible();
    Toast.show(errorTxt, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:redColor, textColor: Colors.white);

    //print(errorTxt.toString());
    //  setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(chcUserModel user) async {
    Toast.show("Login Successful", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:greenColor, textColor: Colors.white);

    //setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.deleteUsers();
    await db.saveUser(user);
    session(user.api_token,user.userlevel);
    await Navigator.pushNamed(context, '/menus');
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  void session(id,type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Session', id);
    await prefs.setString('Usertype', type);
  }



  @override
  void onRegSuccess(user) {
    // TODO: implement onRegSuccess
  }
}
