import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:ampluserv/pages/Menu/Menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class NewM extends StatefulWidget{
  _NewMStates createState() => _NewMStates();
}

class _NewMStates extends State<NewM>
    with SingleTickerProviderStateMixin {
  int _curIndex = 0;
  BuildContext _ctx;

  @override
  void initState() {
    super.initState();
    //  controller = new TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Menu();
  }

}
