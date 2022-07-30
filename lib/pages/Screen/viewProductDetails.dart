import 'dart:async';
import 'dart:io';
import 'dart:convert' show utf8, base64;
import 'package:ampluserv/constants/keys.dart';
import 'package:ampluserv/constants/loading.dart';
import 'package:ampluserv/constants/style.dart';
import 'package:ampluserv/constants/theme.dart';
import 'package:ampluserv/db_helper/DatabaseHelper.dart';
import 'package:ampluserv/models/ampProduct.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/utils/rest_ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  ampProductModel detail;
  ProductDetailScreen({this.detail});
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var db = new DatabaseHelper();
  bool isOffline = false;
  StreamSubscription _connectionChangeStream;
  chcUserModel _userModel;
  BuildContext _ctx;
   String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  String card,payment_type;

  RestDatasource _restDatasource = new RestDatasource();

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


  List<Map<String, dynamic>> payment = [{"id": 'Bitcoin',"name" : 'Bitcoin',},{"id": 'Bank Transfer',"name" : 'Bank Transfer',},
  {"id": 'Card',"name" : 'Card',},{"id": 'TatCoin',"name" : 'TatCoin',}];

  @override
  void initState() {
    dbDetails();
    /*ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);*/
    super.initState();
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
      body: ListView(
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
                      imageUrl: widget.detail.image,
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
                child: Text(widget.detail.product_name == null ? "" :widget.detail.product_name,
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
                      child: Text(widget.detail.sending_region == null ? "" :widget.detail.sending_region,
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
                      child: Text(widget.detail.grandtotal,
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
                            Text(widget.detail.product_name == null ? "" :widget.detail.product_name)
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
                                  child: Text(widget.detail.grandtotal,
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
                            Text(widget.detail.category == null ? "" :widget.detail.category)
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
                                  child: Text(widget.detail.item_weight == null ? "" :widget.detail.item_weight,
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
                            Text(widget.detail.sending_region == null ? "" :widget.detail.sending_region)
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
                                  child: Text(widget.detail.pickupaddress == null ? "" :widget.detail.pickupaddress,
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
                            Text(widget.detail.receiving_region == null ? "" :widget.detail.receiving_region)
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
                                  child: Text(widget.detail.deliveryaddress == null ? "" :widget.detail.deliveryaddress,
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
                            Text(widget.detail.pickup_vehicle == null ? "" :widget.detail.pickup_vehicle)
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
                                  child: Text(widget.detail.distance == null ? "" :widget.detail.distance+ "km",
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
                            Text(widget.detail.distance_reduction == null ? "" :widget.detail.distance_reduction + "km")
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
                                  child: Text(widget.detail.duedate == null ? "" :widget.detail.duedate,
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
                            Text(widget.detail.time_due == null ? "" :widget.detail.time_due)
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
                            Text(widget.detail.agent_name == null ? "" :widget.detail.agent_name)
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
                                  child: Text(widget.detail.agent_email == null ? "" :widget.detail.agent_email,
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
                            Text(widget.detail.agent_phone == null ? "" :widget.detail.agent_phone)
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
                                  child: Text(widget.detail.agent_accepted == null ? "" :widget.detail.agent_accepted,
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
                            Text(widget.detail.agent_accepted_date == null ? "" :widget.detail.agent_accepted_date)
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
                                  child: Text(widget.detail.item_delivered == null ? "" :widget.detail.item_delivered,
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
                            Text(widget.detail.item_delivery_date == null ? "" :widget.detail.item_delivery_date)
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
                            Text(widget.detail.base_charge == null ? "" :widget.detail.base_charge)
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
                                  child: Text(widget.detail.distance_charge == null ? "" :widget.detail.distance_charge,
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
                            Text(widget.detail.weight_charge == null ? "" :widget.detail.weight_charge)
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
                                  child: Text(widget.detail.delivery_time_charge == null ? "" :widget.detail.delivery_time_charge  + '\n' +widget.detail.delivery_time == null ? "" :widget.detail.delivery_time,
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
                            Text(widget.detail.total_no_tax == null ? "" :widget.detail.total_no_tax)
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
                                  child: Text(widget.detail.fuel_subcharge == null ? "" :widget.detail.fuel_subcharge+
                                      '\n'+widget.detail.fuel_subcharge_percentage == null ? "" :widget.detail.fuel_subcharge_percentage,
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
                            Text(widget.detail.total_no_tax == null ? "" :widget.detail.total_no_tax)
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
                                  child: Text(widget.detail.discount == null ? "" :widget.detail.discount,
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
                            Text(widget.detail.tax == null ? "" :widget.detail.tax)
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
                                  child: Text("\U+0024"+widget.detail.grandtotal == null ? "" :widget.detail.grandtotal,
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
              /*Container(
                //height: 215,
                width: double.infinity,
                padding:
                EdgeInsets.only(left: 20, right: 20, bottom: 10),
                color: Colors.white,
                child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 10.0),
                      child: new InputDecorator(
                        decoration: const InputDecoration(
                        ),
                        isEmpty: payment_type == null,
                        child: new DropdownButton<String>(
                          hint: new Text("Select Payment Option",style: textStyle,),
                          value: payment_type,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              payment_type = newValue;
                              //print(selected_bank);
                            });
                          },
                          items: payment.map((value) {
                            return new DropdownMenuItem<String>(
                              value: value['id'],
                              child: new Text(value['name'],style: textStyle,),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                ),

              ),*/
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: redColor,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: ()  {
                      _showDialog(context);
                    },
                    child: Center(
                      child: Text(
                        'Cancel Delivery',
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 19.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),

                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
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

  _showDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Product Cancellation"),
          content: new Text("Do you want to cancel your product"),
          actions: <Widget>[
            FlatButton(
              padding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              color: Color(0xFF015FFF),
              onPressed: () {
                Navigator.of(context).pop();
                button_accept();

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

  button_accept(){
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 6), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Please Wait...")
          ],
        ),
        ));
    final model = {"id":widget.detail.id};
    print(model);
    _restDatasource.DeleteD(model,_userModel.api_token).then((res) {
      if(res["status"].toString() == "200"){
        //donation_amount.clear();
       Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:greenColor, textColor: Colors.white);
       Navigator.of(context).pushReplacementNamed("/menu");
      } else {
        _updateStatus("", res["message"].toString());
      }

    }).catchError((onError) => {
    // print(onError.toString())
    _updateStatus("Server Response", onError.toString())
    });
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



  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
