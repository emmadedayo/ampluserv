import 'dart:async';
import 'package:ampluserv/utils/network.dart';
import 'package:ampluserv/utils/Network_Url.dart';
import 'package:ampluserv/models/ampUserModel.dart';
import 'package:ampluserv/models/ampProduct.dart';


class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  Network_Url _network_url = new Network_Url();

  Future UserRegistration(data) {
    final url = _network_url.PostService('register');
    return _netUtil.post(url, body: data).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res["message"];
    });
  }

  Future changePassword(data,myString) {
    final url = _network_url.PostService('changePassword');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
       print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res["message"];
    });
  }

  Future Forget(data) {
    final url = _network_url.PostService('forget');
    return _netUtil.post(url, body: data).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res["message"];
    });
  }

  Future ProfileDetails(myString){
    final url = _network_url.GetService('user');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      print(res['message']);
      return res;
    });
  }


  /*Future AgentList(myString){
    final url = _network_url.GetService('user');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      print(res['message']);
      return res;
    });
  }*/

  Future AgentList(data,myString) {
    final url = _network_url.GetbyID('details',data);
  //  print(url);
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

/*  Future changePassword(myString){
    final url = _network_url.GetService('deposit');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      //print(res['message'])
      return res;
    });
  }*/

  Future ResendCode(data) {
    final url = _network_url.PostService('resend');
    // print(url);
    return _netUtil.post(url, body: data).then((dynamic res) {
      if(res["statusCode"] == "400"){
        // print(res["message"]);
        // throw new Exception(res["message"]);
      }
      print(res.toString());
      //  if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }


  Future getDeposit(myString){
    final url = _network_url.GetService('deposit');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      //print(res['message'])
      return res;
    });
  }

  Future DashBoard(myString){
    final url = _network_url.GetService('dashboard');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      //print(res['message'])
      return res;
    });
  }

  Future<chcUserModel> verifyCode(data) {
    final url = _network_url.PostService('verifyCode');
    return _netUtil.post(url, body:data).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return new chcUserModel.map(res["message"]);
    });
  }

  Future<chcUserModel> login(data) {
    final url = _network_url.PostService('login');
    return _netUtil.post(url, body:data).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return new chcUserModel.map(res["message"]);
    });
  }

  Future<chcUserModel> logins(data) {
    final url = _network_url.PostService('logins');
    return _netUtil.post(url, body:data).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return new chcUserModel.map(res["message"]);
    });
  }

  Future UpdateAgentForm(data,myString) {
    final url = _network_url.PostService('acceptItem');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
        print(res.toString());
        if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future DeleteD(data,myString) {
    final url = _network_url.PostService('delete');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }




  Future UpdatePayment(data,myString) {
    final url = _network_url.PostService('postpayment');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }


  Future UpdateStatus(data,myString) {
    final url = _network_url.PostService('postdeposit');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future UpdateBid(data,myString) {
    final url = _network_url.PostService('postsales');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future PostBidding(data,myString) {
    final url = _network_url.PostService('postbid');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }


  Future Profile(data,myString) {
    final url = _network_url.PostService('postbid');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      // print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }


  Future<List<ampProductModel>> AmpProduct(data,myString) {
     final url = _network_url.GetbyID('myItems',data);
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.get(url,headers: headers,).then((res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["message"]);
      final List contactItems = res["message"];
      return contactItems.map( (contactRaw) => ampProductModel.fromMap(contactRaw)).toList();
    });
  }



  Future PostPrayer(data,myString) {
    final url = _network_url.PostService('postrequest');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
       //print(res.toString());
     // if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future PostTestimony(data,myString) {
    final url = _network_url.PostService('posttestimony');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      print(res.toString());
      // if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }
  Future PostSuggestion(data,myString) {
    final url = _network_url.PostService('postsuggestion');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      print(res.toString());
      // if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future PostForum(data,myString) {
    final url = _network_url.PostService('postforum');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      print(res.toString());
      // if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

  Future PostForumComment(data,myString) {
    final url = _network_url.PostService('postforumcomment');
    Map<String, String> headers = {'Authorization': 'Bearer ' + myString};
    return _netUtil.post(url, body: data,headers: headers,).then((dynamic res) {
      print(res.toString());
      // if(res["error"]) throw new Exception(res["message"]);
      return res;
    });
  }

}
