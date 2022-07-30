import 'dart:async';
import 'package:ampluserv/constants/customDialogInfo.dart';
import 'package:ampluserv/constants/loading.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/ampProduct.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/utils/Network_Url.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as Math;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;


class AgentViewScreen extends StatefulWidget {
  ampProductModel detail;
  AgentViewScreen({this.detail});
  _AgentViewScreenState createState() => _AgentViewScreenState();
}

class _AgentViewScreenState extends State<AgentViewScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var db = new DatabaseHelper();
  bool isOffline = false;
  bool errors;
  StreamSubscription _connectionChangeStream;
  chcUserModel _userModel;
  List<ampProductModel> _dayModel;
  var _image;
  Network_Url _network_url = new Network_Url();
  RestDatasource _restDatasource = new RestDatasource();
  String lastSelectedValue,from,image,
      id,product_name,category,item_weight,sending_region,pickupaddress,receiving_region,pickup_vehicle,deliveryaddress,distance,distance_reduction
  ,duedate,time_due,agent_name,agent_email,agent_phone,agent_accepted,agent_accepted_date,item_delivered,item_delivery_date,delivery_slip,
      base_charge,distance_charge,weight_charge,tax,delivery_time_charge,delivery_time,total_no_tax,fuel_subcharge,fuel_subcharge_percentage,
      discount,agent_earning,grandtotal,StringCode,Message;
  ampProductModel _models;

  int photoIndex = 0;
  int number = 0;
  int amount;
  int total;

  dbDetails() async {
    _userModel = await db.getClient();
    setState(() {
      _userModel;
    });
  }

  Future getImageLibrary() async {
    var gallery =
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(gallery.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image,500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));
    setState(() {
      _image = compressImg;
    });
  }

  Future cameraImage() async {
    var gallery =
    await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(gallery.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));
    setState(() {
      _image = compressImg;
    });
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera(context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: const Text('Select Camera'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Photo Library'),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from = prefs.getString('Session') ?? '';
    _restDatasource.AgentList(widget.detail.id,from).then((res) {
      if(res["status"] == "200"){
        final List graph = (res['message'] as List).map((contactRaw) => ampProductModel.fromMap(contactRaw)).toList();
        setState(() {
          for(ampProductModel _dayModels in graph){
            _models = _dayModels;
           // load(_models.agent_accepted,context);
          }

        });
      } else {


      }
    }).catchError((onError) => {
    print(onError.toString())
    });
  }
  @override
  void initState() {
    dbDetails();
    _incrementCounter();
    /*ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);*/
    super.initState();
   // print("HELP "+_models.receiving_region);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  void dispose() {
    // _incrementCounter();
    /* ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);*/
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return (isOffline) ?
    new Scaffold(
        key: _scaffoldKey,
        body: _no_internet(context)
    ):
    new Scaffold(
      key: _scaffoldKey,
      body: _models == null ?
      LoadingBuilder()
      :ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    child:CachedNetworkImage(
                      imageUrl: 'https://www.app.ampluserv.com/'+_models.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => new LoadingBuilder(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0,top:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: AppTheme.themeColor,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(_models.product_name == null ? "" :_models.product_name,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Segoe UI',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 14.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 + 30.0,
                      child: Text(_models.sending_region == null ? "" :_models.sending_region,
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          color: Colors.grey.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(_models.grandtotal,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Segoe UI',
                            fontSize: 18.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.grey[100],
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DESCRIPTION",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )),
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Items Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.product_name == null ? "" :_models.product_name)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Grand Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.grandtotal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Category",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.category == null ? "" :_models.category)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Item Weight Charge',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.item_weight == null ? "" :_models.item_weight,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Sending From ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.sending_region == null ? "" :_models.sending_region)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Pickup Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.pickupaddress == null ? "" :_models.pickupaddress,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "To",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.receiving_region == null ? "" :_models.receiving_region)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Delivery Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.deliveryaddress == null ? "" :_models.deliveryaddress,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Pickup Vehicle",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.pickup_vehicle == null ? "" :_models.pickup_vehicle)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'KM Distance',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.discount == null ? "" :_models.discount,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "KM Reduction",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.distance_reduction == null ? "" :_models.distance_reduction)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Due Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.duedate == null ? "" :_models.duedate,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Due Time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.time_due == null ? "" :_models.time_due)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.grey[100],
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "AGENT DETAILS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )),
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Agent Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.agent_name == null ? "" :_models.agent_name)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Agent Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(_models.agent_email == null ? "" :_models.agent_email,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Agent Phone",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.agent_phone == null ? "" :_models.agent_phone)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Agent Accepted and on transit',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.agent_accepted == null ? "" :_models.agent_accepted,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Date Accepted",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.agent_accepted_date == null ? "" :_models.agent_accepted_date)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Item Delivered',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.item_delivered == null ? "" :_models.item_delivered,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Item Delivery Date:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.item_delivery_date == null ? "" :_models.item_delivery_date)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.grey[100],
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHARGES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )),
              ),

              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Base Charge",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.base_charge == null ? "" :_models.base_charge)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'KM Charge',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.distance_charge == null ? "" :_models.distance_charge,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Weight Charged",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.weight_charge == null ? "" :_models.weight_charge)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Waiting Time Charge',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.delivery_time_charge == null ? "" :_models.delivery_time_charge  + '\n' +_models.delivery_time == null ? "" :_models.delivery_time,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.grey[100],
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHARGES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.total_no_tax == null ? "" :_models.total_no_tax)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Fuel Subcharge',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.fuel_subcharge == null ? "" :_models.fuel_subcharge+
                                      '\n'+_models.fuel_subcharge_percentage == null ? "" :_models.fuel_subcharge_percentage,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total (Inclusive)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.total_no_tax == null ? "" :_models.total_no_tax)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Discount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text(_models.discount == null ? "" :_models.discount,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "HST",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text(_models.tax == null ? "" :_models.tax)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Total Charges',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //null
                                  child: Text("\U+0024"+_models.grandtotal == null ? "" :_models.grandtotal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.grey[100],
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "RECEIPT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    )),
              ),
              Container(
                color: whiteColor,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(50.0),
                      child: new ClipRRect(
                          borderRadius: new BorderRadius.circular(2.0),
                          child:_image == null
                              ?new GestureDetector(
                              onTap: (){selectCamera(context);},
                              child: new Container(
                                  height: 150.0,
                                  width: 150.0,
                                  color: primaryColor,
                                  child: image == null ?
                                  new Image.asset('assets/image/1.png',fit: BoxFit.cover, height: 150.0,width: 150.0,)
                                      : new Image.network(_network_url.ImageService(image),fit: BoxFit.cover, height: 150.0,width: 150.0,)
                              )
                          ): new GestureDetector(
                              onTap: () {selectCamera(context);},
                              child: new Container(
                                height: 150.0,
                                width: 150.0,
                                child: Image.file(_image,fit: BoxFit.cover, height: 800.0,width: 80.0,),
                              )
                          )
                      ),
                    ),
                  ],
                ),
              ),

              new SizedBox(
                height: 20.0,
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 7.0,
        color: Colors.white,
        child: Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child:
          load(_models==null ? "loading":_models.agent_accepted ,context),

        ),
      ),
    );
  }

   _showDialog(context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Accept & Move Item"),
            content: new Text("Please note that accepting means you have collected the item and moving to destination"),
            actions: <Widget>[
              FlatButton(
                padding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Color(0xFF015FFF),
                onPressed: () {
                  Navigator.of(context).pop();
                  button_accept(context);

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
    }

  dialogInfo(message,context){
    return customDialogInfo(
      title: "Acceptance Response",
      body: message,
      onTap: (){
        Navigator.of(context).pop();
      },
    );
  }

button_accept(context){
  _scaffoldKey.currentState.showSnackBar(
      new SnackBar(duration: new Duration(seconds: 6), content:
      new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  Please Wait...")
        ],
      ),
      ));
  final model = {"id":_models.id};
  print(model);
  _restDatasource.UpdateAgentForm(model,from).then((res) {
    if(res["statusCode"].toString() == "200"){
      //donation_amount.clear();
      setState(() {
        _incrementCounter();
      });

     // Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:greenColor, textColor: Colors.white);

    //  showDialog(context: context, child: dialogInfo(res["message"],context));

    } else {
      _updateStatus("", res["message"].toString());
    }

  }).catchError((onError) => {
  // print(onError.toString())
  _updateStatus("Server Response", onError.toString())
  });
}

  _no_internet(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.fromLTRB(screenSize.width*0.13, 0.0, screenSize.width*0.13, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
              height: 300.0,
              width: 200.0,
              child: new Image.asset('assets/nonetwork.gif',fit: BoxFit.cover, height: 100.0,width: 100.0,)
          ),
          Container(
            child: Text("No Network Connection",style: headingBlack,),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0,top: 20.0),

            child: Text("Turn on your mobile network or connect to a wifi",style: textStyle,),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0),),

        ],
      ),
    );
  }

  Widget colorItems(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget materialItems(IconData icon, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.grey,
            size: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
          ),
          Text(
            percentage,
            style: TextStyle(
                fontFamily: 'Segoe UI',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          )
        ],
      ),
    );
  }


  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 3));
  }

  _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  //updateItem
  void postImage(context) async {

    if(_image == null){

      Toast.show("Please Upload Profile Image", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:redColor, textColor: Colors.white);


    } else {

      var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = _network_url.PostService('updateItem');
      //print(myString);
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + _userModel.api_token
      };

      final multipartRequest = new http.MultipartRequest('POST', Uri.parse(uri));
      multipartRequest.headers.addAll(headers);
      var multipartFile = new http.MultipartFile("image", stream, length,
          filename: basename(_image.path));
      multipartRequest.fields['id'] = _models.id;
      multipartRequest.files.add(multipartFile);

      var response = await multipartRequest.send();
      // var res = json.decode(response.stream.transform(streamTransformer))

      if (response.statusCode == 200) {
        Toast.show("Product successfully added. ", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: blackColor,
            textColor: Colors.white);
        Navigator.of(context).pop();
      } else {
        Toast.show(
            "Unable to add your items, please contact the admin", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: blackColor,
            textColor: Colors.white);
      }
      response.stream.transform(utf8.decoder).listen((value) {
        //print(value);
        StringCode = value.contains("error").toString();
        Message = value.contains("message").toString();

        if (errors) {
          Toast.show(Message, context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              backgroundColor: redColor,
              textColor: Colors.white);
        } else {
          Navigator.of(context).pop();

          Toast.show(Message, context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              backgroundColor: greenColor,
              textColor: Colors.white);
        }
      });
    }

  }

  load(agent_accepted,context) {

    if(agent_accepted == null){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Container(
        color: green2,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: ()  {
            _showDialog(context);

          },
          child: Center(
            child: Text(
              'Accept',
              style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 19.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),),

          ),
        ),
      ),
    ]);
    } else  {

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: green2,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: ()  {
                  postImage(context);
                },
                child: Center(
                  child: Text(
                    'Deliver Item',
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 19.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),

                ),
              ),
            ),
          ]);
    }
  }

}
