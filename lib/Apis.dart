import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Apis {
  static const domain = 'https://maps.googleapis.com/maps/api/directions/json?';

  getCallAPI(String uri) async {
    HttpClient client = new HttpClient();
    uri = domain+uri;
    HttpClientRequest request = await client.getUrl(Uri.parse(uri));
    HttpClientResponse response = await request.close();
    var responseBody = await utf8.decoder.bind(response).join();

    return json.decode(responseBody);
  }


  getCallAPIAuth(String uri) async {
    HttpClient client = new HttpClient();
    uri = domain+uri;
    HttpClientRequest request = await client.getUrl(Uri.parse(uri));
    HttpClientResponse response = await request.close();
    var responseBody = await utf8.decoder.bind(response).join();
    return json.decode(responseBody);
  }

  getWithJWT(String uri, String jwt) async {
    HttpClient client = new HttpClient();
    uri = domain+uri;
    HttpClientRequest request = await client.getUrl(Uri.parse(uri));
    request.headers.contentType = new ContentType(
        "application", "x-www-form-urlencoded",
        charset: "utf-8");
    request.headers.set("Authorization", 'Bearer $jwt');
    HttpClientResponse response = await request.close();
    var responseBody = await utf8.decoder.bind(response).join();
    return json.decode(responseBody);
  }

  postCallAPIJWT(String uri, String message, String jwt) async {
    uri = domain+uri+"?"+message;
    print(uri);
    var res = await http.post(
        Uri.parse(uri),
        headers:{
          "Content-Type":"application/x-www-form-urlencoded" ,
          "Authorization":'Bearer $jwt' ,
        } ,
        body: message,
        encoding: Encoding.getByName("utf-8")
    ).then((response) {
      return json.decode(response.body);
    });
    return res;
  }

  postCallAPIJWTUpdate(String uri, String message, String jwt) async {
    uri = domain+uri+"?"+message;
    var res = await http.post(
        Uri.parse(uri),
        headers:{
          "Content-Type":"application/x-www-form-urlencoded" ,
          "Authorization":'Bearer $jwt' ,
        } ,
        body: message,
        encoding: Encoding.getByName("utf-8")
    ).then((response) {
      return json.decode(response.body);
    });
    return res;
  }

  postCallAPI(String uri, String message) async {
    uri = domain+uri+"?"+message;
    var res = await http.post(
        Uri.parse(uri),
        headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: message,
        encoding: Encoding.getByName("utf-8")
    ).then((response) {
      return json.decode(response.body);
    });
    return res;
  }
}
