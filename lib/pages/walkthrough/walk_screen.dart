import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import "package:ampluserv/models/WalkModel.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:flutter/services.dart';

class WalkthroughScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final List<Walkthrough> pages = [
    Walkthrough(
      icon: 'assets/image/walka.png',
      title: "Home and Office Delivery",
      description:
      "We help our customers make deliveries to their clients and also pick up packages for them.",
    ),
    Walkthrough(
      icon: 'assets/image/walkb.png',
      title: "Package Protection",
      description: "We ensure that packages sent through us get to their desired destination and in good shape.",
    ),
    Walkthrough(
      icon: 'assets/image/walkc.png',
      title: "International Shipping",
      description:
      "We help our customers send packages overseas and at affordable costs.",
    ),
    Walkthrough(
      icon: 'assets/image/walkd.png',
      title: "24/7 Support",
      description:
      "We are available round the clock to respond to any query you may have concerning our services.",
    ),
  ];

  WalkthroughScreen({this.prefs});

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: primaryColor,
              size: 6.5,
              activeSize: 8.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context,screenSize),
      ),
    );
  }

  List<Widget> _getPages(BuildContext context,screenSize) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      Walkthrough page = widget.pages[i];
      widgets.add(
        new Container(
          color: AppTheme.white,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Image.asset(
                  page.icon,
                  height: 200,
                  width: 100,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
                  page.title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Segoe UI",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  page.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Segoe UI",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: page.extraWidget,
              )
            ],
          ),
        ),
      );
    }
    widgets.add(
      new Container(
        color: AppTheme.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/image/logo.png',
                  height: 200,
                  width: 200,
                ),
              ),
              ButtonTheme(
                minWidth: screenSize.width*0.43,
                height: 45.0,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                  elevation: 0.0,
                  color: primaryColor,
                  textColor: AppTheme.white,
                  child: new Text('Get Started',
                  ),
                  onPressed: () {
                    widget.prefs.setBool('seen', true);
                    Navigator.of(context).pushNamed("/welcome");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widgets;
  }
}