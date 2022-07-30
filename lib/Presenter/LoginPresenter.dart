import 'package:ampluserv/utils/rest_ds.dart';
import 'package:ampluserv/models/ampUserModel.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(chcUserModel user);
  void onRegSuccess(user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(data) {
    api.verifyCode(data).then((chcUserModel user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }

  Login(data) {
    api.login(data).then((chcUserModel user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }

  Logins(data) {
    api.logins(data).then((chcUserModel user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }

  doSignup(data) {
    api.UserRegistration(data).then((user) {
      _view.onRegSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }

  changePassword(data,my) {
    api.changePassword(data,my).then((user) {
      _view.onRegSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }

  doForget(data) {
    api.Forget(data).then((user) {
      _view.onRegSuccess(user);
    }).catchError((Object error) =>
        _view.onLoginError(error.toString()));
  }


  message(error){
    if(error['success'] == "400"){
      return error['message'].toString();
    }
  }
}