import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  bool enable;
  TextEditingController controller;
  double bottomMargin;
  double radius;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  var pass;
  String passs;
  //var focusNode;
  Key key;

  //passing props in the Constructor.
  //Java like style
  InputField(
      {this.key,
        this.hintText,
        this.obscureText,
        this.textInputType,
        this.textFieldColor,
        this.icon,
        this.iconColor,
        this.bottomMargin,
        this.textStyle,
        this.validateFunction,
        this.passs,
        this.onSaved,
        this.radius,
        //this.focusNode,
        this.enable,
        this.pass,
        this.controller,
        this.hintStyle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
        child: new DecoratedBox(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(radius)),
              color: textFieldColor),
          child: new TextFormField(
            style: textStyle,
            key: key,
            controller: controller,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            onSaved: onSaved,
            //focusNode: new FocusNode(),
            enabled: enable,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: hintStyle,
              suffixIcon: pass,
              icon: new Padding(
                padding:
                const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                child: new Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              // hideDivider: true
            ),
          ),
        )));
  }
}
