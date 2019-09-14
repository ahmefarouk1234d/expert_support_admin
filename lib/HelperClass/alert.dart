import 'dart:io';

import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Alert{
  // ---------------------- iOS Part ------------------------------
  Widget _iOSAlert(String title, String message, List<Widget> actions){
    return CupertinoAlertDialog(
      title: Text(title), 
      content: Text(message),
      actions: actions
    );
  }

  List<Widget> _iOSAlertOkAction(Function okAction){
    return <Widget>[
      CupertinoDialogAction(
        child: Text("OK"), onPressed: okAction,)
    ];
  }

  List<Widget> _iOSAlertTwoAction(Function okAction, Function cancelAction){
    return <Widget>[
      CupertinoDialogAction(
        child: Text("OK"), onPressed: okAction,),
      CupertinoDialogAction(
        child: Text("CANCEL"), onPressed: cancelAction,)
    ];
  }
  // ---------------------- End iOS Part --------------------------

  // ---------------------- Android Part ------------------------------
  Widget _androidAlert(String title, String message, List<Widget> actions){
    return AlertDialog(
      title: Text(title), 
      content: Text(message),
      actions: actions
    );
  }

  List<Widget> _androidAlertOkAction(Function okAction){
    return <Widget>[
      FlatButton(child: Text("OK"), onPressed: okAction,)
    ];
  }

  List<Widget> _androidAlertTwoAction(Function okAction, Function cancelAction){
    return <Widget>[
      FlatButton(child: Text("OK"), onPressed: okAction,),
      FlatButton(child: Text("CANCEL"), onPressed: cancelAction,)
    ];
  }
  // ---------------------- End Android Part --------------------------

  void warning(BuildContext context, String message, Function okAction) {
    String _title = "Warning";
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction));
        });
  }

  void success(BuildContext context, String message, Function okAction) {
    String _title = "Success";
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction));
        });
  }

  void error(BuildContext context, String message, Function okAction) {
    String _title = "Error";
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction));
        });
  }

  void conformation(BuildContext context, String title, String message, Function okAction) {
    showDialog(
      context: context,
      builder: (BuildContext context2){
        if (Platform.isIOS) {
          return _iOSAlert(title, message, _iOSAlertTwoAction(
            () {
              Common().dismiss(context);
              okAction();
            }, () => Common().dismiss(context)));
        }
        return _androidAlert(title, message, _androidAlertTwoAction(
          () {
              Common().dismiss(context);
              okAction();
            }, () => Common().dismiss(context)));
      }
    );
  }

}