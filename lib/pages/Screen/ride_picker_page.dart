import 'package:ampluserv/Blocs/place_bloc.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/models/place_item_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RidePickerPage extends StatefulWidget {
  final String selectedAddress;
  final Function(PlaceItem, bool) onSelected;
  final bool _isFromAddress;
  RidePickerPage(this.selectedAddress, this.onSelected, this._isFromAddress);

  @override
  _RidePickerPageState createState() => _RidePickerPageState();
}

class _RidePickerPageState extends State<RidePickerPage> {
  var _addressController;
  var placeBloc = PlaceBloc();

  @override
  void initState() {
    _addressController = TextEditingController(text: widget.selectedAddress);
    super.initState();
  }

  @override
  void dispose() {
    placeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
       // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: CupertinoTextField(
                          prefix: Icon(
                            CupertinoIcons.location_solid,
                            color: greyColor2,
                            size: 28.0,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          autofocus: true,
                          decoration: BoxDecoration(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            //border: Border(bottom: BorderSide(width: 0.0, color: CupertinoColors.inactiveGray)),
                          ),
                          placeholder: 'Select address',
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onChanged: (str) {
                            placeBloc.searchPlace(str);
                          },
                          onSubmitted: (str) {
                            placeBloc.searchPlace(str);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: StreamBuilder(
                  stream: placeBloc.placeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.toString());
                      if (snapshot.data == "start") {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      print(snapshot.data.toString());
                      List<PlaceItem> places = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(places.elementAt(index).name),
                              subtitle: Text(places.elementAt(index).address),
                              onTap: () {
                                 FocusScope.of(context).requestFocus(new FocusNode());
                                 Navigator.of(context).pop();
                                 widget.onSelected(places.elementAt(index),
                                     widget._isFromAddress);
                              },
                            );
                          },
                          itemCount: places.length);
                     /* return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(places.elementAt(index).name == null ? '' : Text(places.elementAt(index).name),
                              subtitle: Text(places.elementAt(index).address == null ? '' : Text(places.elementAt(index).address),
                              onTap: () {
                                print("on tap");
                                Navigator.of(context).pop();
                                widget.onSelected(places.elementAt(index),
                                    widget._isFromAddress);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Color(0xfff5f5f5),
                              ),
                          itemCount: places.length);*/
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
