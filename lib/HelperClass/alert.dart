import 'dart:io';

import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
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

  List<Widget> _iOSAlertOkAction(Function okAction, BuildContext context){
    return <Widget>[
      CupertinoDialogAction(
        child: Text(
          AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)
          ), 
        onPressed: okAction,)
    ];
  }

  List<Widget> _iOSAlertTwoAction(Function okAction, Function cancelAction, BuildContext context){
    return <Widget>[
      CupertinoDialogAction(
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)), 
        onPressed: okAction,),
      CupertinoDialogAction(
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.cancelButtonTitle)), onPressed: cancelAction,)
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

  List<Widget> _androidAlertOkAction(Function okAction, BuildContext context){
    return <Widget>[
      FlatButton(
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)), 
        onPressed: okAction,)
    ];
  }

  List<Widget> _androidAlertTwoAction(Function okAction, Function cancelAction, BuildContext context){
    return <Widget>[
      FlatButton(
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)), 
        onPressed: okAction,),
      FlatButton(
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.cancelButtonTitle)), 
        onPressed: cancelAction,)
    ];
  }
  // ---------------------- End Android Part --------------------------

  void warning(BuildContext context, String message, Function okAction) {
    String _title = AppLocalizations.of(context).translate(LocalizedKey.warningAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction, context));
        });
  }

  void success(BuildContext context, String message, Function okAction) {
    String _title = AppLocalizations.of(context).translate(LocalizedKey.successAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction, context));
        });
  }

  void error(BuildContext context, String message, Function okAction) {
    String _title = AppLocalizations.of(context).translate(LocalizedKey.errorAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(_title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(_title, message, _androidAlertOkAction(okAction, context));
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
            }, () => Common().dismiss(context)
            , context));
        }
        return _androidAlert(title, message, _androidAlertTwoAction(
          () {
              Common().dismiss(context);
              okAction();
            }, () => Common().dismiss(context)
            , context));
      }
    );
  }

}