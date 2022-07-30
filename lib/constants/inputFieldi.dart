import 'package:flutter/material.dart';

class InputFieldi extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  bool enable;
  double radius;
  TextEditingController controller;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  var onChanged;
  bool visible;
  //var focusNode;
  Key key;

  //passing props in the Constructor.
  //Java like style
  InputFieldi(
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
        this.onSaved,
        this.onChanged,
        this.visible,
        this.radius,
        //this.focusNode,
        this.enable,
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
            onChanged: onChanged,
            //focusNode: new FocusNode(),
            enabled: enable,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              enabled: visible,
              hintStyle: hintStyle,
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
