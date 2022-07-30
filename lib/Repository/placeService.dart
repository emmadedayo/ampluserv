import 'package:ampluserv/config.dart' as prefix1;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:ampluserv/models/place_item_res.dart';
import 'package:ampluserv/models/step_res.dart';
import 'package:ampluserv/models/trip_info_res.dart';

class PlaceService {
  static Future<List<PlaceItem>> searchPlace(String keyword) async {
    String language = prefix1.language;
    String region = prefix1.region;
    String apiKey = prefix1.ApiKey;
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&language=$language&region=$region&query=" +Uri.encodeQueryComponent(keyword);
    HttpClient client = new HttpClient();

    //var res = await http.get(url);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var responseBody = await utf8.decoder.bind(response).join();
    print(responseBody);
    return PlaceItem.fromJson(json.decode(responseBody));
//    if (res.statusCode == 200) {
//      print(PlaceItemRes.fromJson(json.decode(res.body)));
//      return PlaceItemRes.fromJson(json.decode(res.body));
//    } else {
//      return new List();
//    }
  }


  static Future<List<Distance>> getDistance(frm_lat, frm_lng, to_lat, to_lng) async {
    String apiKey = prefix1.ApiKey;
    String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$frm_lat,$frm_lng&destinations=$to_lat,$to_lng&key=$apiKey";
    HttpClient client = new HttpClient();

    //var res = await http.get(url);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var responseBody = await utf8.decoder.bind(response).join();
    print(responseBody);
    return Distance.fromJson(json.decode(responseBody));
//    if (res.statusCode == 200) {
//      print(PlaceItemRes.fromJson(json.decode(res.body)));
//      return PlaceItemRes.fromJson(json.decode(res.body));
//    } else {
//      return new List();
//    }
  }

  static Future<dynamic> getStep(double lat, double lng, double tolat, double tolng) async {
    String apiKey = prefix1.ApiKey;
    String str_origin = "origin=" + lat.toString() + "," + lng.toString();
    // Destination of route
    String str_dest =
        "destination=" + tolat.toString() + "," + tolng.toString();
    // Sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    // Building the parameters to the web service
    String parameters = str_origin + "&" + str_dest + "&" + sensor + "&" + mode;
    // Output format
    String output = "json";
    // Building the url to the web service
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?" +
        parameters +
        "&key=" +
        apiKey;

    print(url);
    final JsonDecoder _decoder = new JsonDecoder();
    return http.get(url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }


      TripInfoRes tripInfoRes;
      try {
        var json = _decoder.convert(res);
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps =
        _parseSteps(json["routes"][0]["legs"][0]["steps"]);

        tripInfoRes = new TripInfoRes(distance, steps);

      } catch (e) {
        throw new Exception(res);
      }

      return tripInfoRes;
    });
  }

  static List<StepsRes> _parseSteps(final responseBody) {
    var list = responseBody
        .map<StepsRes>((json) => new StepsRes.fromJson(json))
        .toList();

    return list;
  }
}