import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/db_helper/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'changePassword.dart';
import 'editProfile.dart';

class Profile extends StatefulWidget{
  _ProfileStates createState() => _ProfileStates();
}

class _ProfileStates extends State<Profile>
    with SingleTickerProviderStateMixin{
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
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green,
//          iconSize: 22.0,
          onTap: (index) {
            _curIndex = index;
            setState(() { });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.all_inclusive,
                size: 20,
                //    color: AppTheme.themeColor,
              ),
              title: Text(
                'Profile ',
                style: TextStyle(
                  //       color: AppTheme.themeColor,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group_work,
                size: 20,
                //    color: AppTheme.themeColor,
              ),
              title: Text(
                'Edit Password ',
                style: TextStyle(
                  //       color: AppTheme.themeColor,
                ),
              ),
            ),
          ]),
      body: new Center(
        child: _getWidget(),
      ),
    );
  }
  Widget _getWidget() {
    switch (_curIndex) {
      case 0:
        return Container(
          color: green2,
          child: EditProfileScreen(),
        );
        break;
      case 1:
        return Container(
          color: green2,
          child: ChangePassScreen(),
        );
        break;
    }
  }

}
