import 'dart:convert';
class DataModel {
  String id;

  DataModel(this.id);


  DataModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
  }

}