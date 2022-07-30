import 'dart:convert';
class chcUserModel {
  int id;
  String username;
  String name;
  String userid;
  String client_type;
  String userlevel;
  String email;
  String api_token;
  String phone;
  chcUserModel(this.id,this.username, this.name, this.userid, this.client_type, this.userlevel, this.email, this.api_token, this.phone);

  chcUserModel.map(dynamic obj) {
    this.id = obj["id"];
    this.username = obj["username"];
    this.name = obj["name"];
    this.userid = obj["userid"];
    this.client_type = obj["client_type"];
    this.userlevel = obj["userlevel"];
    this.email = obj["email"];
    this.api_token = obj["api_token"];
    this.phone = obj["phone"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["name"] = name;
    map["userid"] = userid;
    map["client_type"] = client_type;
    map["userlevel"] = userlevel;
    map["email"] = email;
    map["api_token"] = api_token;
    map["phone"] = phone;

    return map;
  }

  chcUserModel clientFromJson(String str) {
    final jsonData = json.decode(str);
    return chcUserModel.fromMap(jsonData);
  }

  String clientToJson(chcUserModel data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  chcUserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    username = map["username"];
    name = map["name"];
    userid = map["userid"];
    userlevel = map["userlevel"];
    email = map["email"];
    api_token = map["api_token"];
  }

}