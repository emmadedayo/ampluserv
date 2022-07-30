import 'package:ampluserv/Presenter/ampProductPresenter.dart';
import 'package:ampluserv/constants/loading.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/ampProduct.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/pages/Screen/viewProductDetails.dart';
import 'package:ampluserv/utils/FetchDataException.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AgentViewProduct.dart';


class ViewItems extends StatefulWidget{
  _ViewItemsState createState() => _ViewItemsState();

}

class _ViewItemsState  extends State<ViewItems> implements ProductContract {
  TextEditingController prayer_title = TextEditingController();
  TextEditingController prayer_message = TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  RestDatasource _restDatasource = new RestDatasource();
  var db = new DatabaseHelper();
  chcUserModel _userModel;
  ProductPresenter _presenter;
  List<ampProductModel> _chcEventModel;
  bool _isLoading;
  String key,myString,type;

  dbDetails() async {
    _userModel = await db.getClient();
    setState(() {
      print(_userModel.api_token);
      _userModel;
    });
  }



  _ViewItemsState() {
    _presenter = new ProductPresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
    _incrementCounter();
    // controller.dispose();
  }
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    dbDetails();
    _incrementCounter();
    // autth();
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myString = prefs.getString('Session') ?? '';
    type = prefs.getString('Usertype') ?? '';
    _presenter.getPrayer(type,myString);
    print("Session" +type);
  }

  @override
  void onError(FetchDataException e) {
    //_showSnackBar(e.toString());
    print(e.toString());
  }

  @override
  void onSuccess(List<ampProductModel> items) {
    setState(() {
      _chcEventModel = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      key: scaffoldKey,
      body: _isLoading
          ?   LoadingBuilder()
          : Container(
        color: greyColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final ampProductModel prayerList = _chcEventModel[index];
                  if(prayerList != null){
                    return _historyWidgets(context, prayerList);
                  }
                  else{

                    return _historyWidgets(context, prayerList);
                  }

                },
                itemCount: _chcEventModel.length,
              ),


            ),
          ],
        ),
      ),
    );
  }

  Widget _historyWidgets(BuildContext context, ampProductModel _chcEventModel) {
    details(){
      if(type == "2"){

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> AgentViewScreen(detail: _chcEventModel)));
      } else {

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> ProductDetailScreen(detail: _chcEventModel)));
      }
    }
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
           /// _us
            onTap: () {
              details();
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  child:CachedNetworkImage(
                    imageUrl: _chcEventModel.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => new LoadingBuilder(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _chcEventModel.product_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Text("Category: "+_chcEventModel.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),

                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              //margin: EdgeInsets.only(left: 11.0),
                              child: Text("Sending Region: " +_chcEventModel.sending_region,
                                maxLines: 2,
                                style: TextStyle(
                                  //fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Text("Amount: " + _chcEventModel.grandtotal,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ),

                /*Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_chcEventModel.event_time,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(_chcEventModel.start_date,
                                textAlign: TextAlign.right,
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }



  _updateStatus(String reference, String message) {
    _showMessage('$reference \n\ $message',
        const Duration(seconds: 3));
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
}