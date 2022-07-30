import 'package:ampluserv/models/place_item_res.dart';
import 'package:ampluserv/pages/Screen/ride_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePicker extends StatefulWidget {
  final Function(PlaceItem, bool) onSelected;
  RidePicker(this.onSelected);

  @override
  _RidePickerState createState() => _RidePickerState();
}


class _RidePickerState extends State<RidePicker> {
  PlaceItem fromAddress;
  PlaceItem toAddress;

  /*void session(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Session', id);

  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88999999),
              offset: Offset(0, 5),
              blurRadius: 5.0,
            ),
          ]),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RidePickerPage(
                            fromAddress == null ? "" : fromAddress.name,
                            (place, isFrom) {
                          widget.onSelected(place, isFrom);
                          fromAddress = place;
                          setState(() {});
                        }, true)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(FontAwesomeIcons.map,color: primaryColor,size: 15,),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(FontAwesomeIcons.times,color: primaryColor,size: 15,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        fromAddress == null ? "From" : fromAddress.name,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RidePickerPage(toAddress == null ? "" : toAddress.name,
                            (place, isTo) {
                          widget.onSelected(place, isTo);
                          toAddress = place;
                          setState(() {});
                        }, false)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(FontAwesomeIcons.search,color: primaryColor,size: 15,),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(FontAwesomeIcons.times,color: primaryColor,size: 15,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        toAddress == null ? "To" : toAddress.name,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
