import 'dart:convert';
class chcVerification {
  String email;
  String message;
  String type;

  chcVerification(this.email,this.message,this.type);


  chcVerification.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    message = map["message"];
    type = map["type"];
  }

}