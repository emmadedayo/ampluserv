import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:ampluserv/pages/Screen/Book.dart';
import 'package:ampluserv/pages/Screen/Profile.dart';
import 'package:ampluserv/pages/Screen/SendItems.dart';
import 'package:ampluserv/pages/Screen/homepage.dart';
import 'package:ampluserv/pages/Screen/viewItems.dart';
import 'package:ampluserv/pages/auth/login.dart';
import 'package:ampluserv/utils/Network_Url.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:ampluserv/pages/Screen/DashBoard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class Menus extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("View Items", Icons.view_list),
    new DrawerItem("Read me", Icons.book),
    new DrawerItem("Profile", Icons.payment),
    // new DrawerItem("Profile", Icons.person),
  ];

  @override
  State<StatefulWidget> createState() {
    return new _MenuStates();
  }


}

class _MenuStates extends State<Menus> implements AuthStateListener {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _ctx;
  int _selectedDrawerIndex = 0;
  var db = new DatabaseHelper();
  chcUserModel _userModel;
  String  profile_image,name,email;
  RestDatasource _restDatasource = new RestDatasource();
  Network_Url _network_url = new Network_Url();

  dbDetails() async {
    _userModel = await db.getClient();
    setState(() {
      _userModel;
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String myString = prefs.getString('Session') ?? '';
    _restDatasource.ProfileDetails(myString).then((res) {
      if(res["statusCode"] == "200"){
        setState(() {
          profile_image = res['message']['picname'];
          name = res['message']['name'];
          email = res['message']['email'];

        });
      } else {

      }
    }).catchError((onError) => {
    print(onError.toString())
    });
    print("Session" +myString);
  }

  _MenuStates() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }
  @override


  @override
  void initState() {
    super.initState();
    dbDetails();
    _incrementCounter();
  }

  void dispose() {
    super.dispose();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Homepage();
      case 1:
        return new ViewItems();
      case 2:
        return new Book();
      case 3:
        return new Profile();

      default:
        return new Text("Error");
    }
  }

  //return Share.share('My Referral Link: http://abitcrowd.com/register_ref.php?ref=pirro');
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    SystemChrome.setEnabledSystemUIOverlays([]);
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),

          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.powerOff,size: 20.0,),
            color: whiteColor,
            onPressed: () {
              _showDialog();
              //clicked(context, "Message sent");
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            Details(),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_OUT)
      Navigator.push(
          _ctx,
          MaterialPageRoute(builder: (_ctx)=> LoginScreen())
      );
  }

  logout(){
    db.deleteUsers();
  }
  logoutprefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('daily_notify');
    await prefs.remove('Session');
    await prefs.remove('Usertype');
  }
  void _showDialog() {
    if(_userModel != null){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Logout Alert"),
            content: new Text("Dear " +_userModel.name+ ",are you sure you want to logout of your session"),
            actions: <Widget>[
              FlatButton(
                padding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Color(0xFF015FFF),
                onPressed: () {
                  logoutprefs();
                  db.deleteUsers();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                },
                child: Text("Yes",
                  style: TextStyle(
                    // color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),),
                textColor: AppTheme.primary_white,
              ),
              FlatButton(
                padding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Color(0xFFF44336),
                // borderSide: BorderSide(color: Color(0xFF015FFF), width: 1.0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No",
                  style: TextStyle(
                    // color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),),
                textColor: AppTheme.primary_white,
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Loading .... "),
            content: new Text("Loading .... "),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
            ],
          );
        },
      );
    }

  }

  Details() {
    if(_userModel != null){
      return UserAccountsDrawerHeader(
        accountEmail: Text(_userModel.email,style: textBoldBlack,),
        accountName: Text(_userModel.name,style: textBoldBlack,),
        currentAccountPicture: CircleAvatar(
          //radius: 20.0,
          backgroundColor: Colors.grey,
          child: profile_image == null
              ? new Container(
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: new BorderRadius.circular(5.0),
                image: new DecorationImage(
                  image: AssetImage('assets/image/bk.png',),
                  fit: BoxFit.fill,)),
          )
              :new Container(
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(_network_url.ImageService(profile_image))
                )
            ),
          ),
        ),
        /*decoration: new BoxDecoration(
            color: Colors.transparent,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.red,
                  Colors.red,
                ],
                stops: [
                  0.0,
                  0.0
                ]),
            image: new DecorationImage(
              image: new ExactAssetImage('assets/image/bk.jpg'),
              fit: BoxFit.fill,
            )
        ),*/
      );
    } else {

      return
        UserAccountsDrawerHeader(
          accountEmail: Text("Loading ..."),
          accountName: Text("Loading ..."),
          currentAccountPicture: CircleAvatar(
            child: Text(".."),
            backgroundColor: Colors.black,
          ),
        );
    }
  }
}


