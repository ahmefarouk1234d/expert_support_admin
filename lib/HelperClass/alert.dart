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

  List<Widget> _iOSAlertOkAction(VoidCallback okAction, BuildContext context){
    return <Widget>[
      CupertinoDialogAction(
        onPressed: okAction,
        child: Text(
          AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)
          ),)
    ];
  }

  List<Widget> _iOSAlertTwoAction(VoidCallback okAction, VoidCallback cancelAction, BuildContext context){
    return <Widget>[
      CupertinoDialogAction(
        onPressed: okAction,
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)),),
      CupertinoDialogAction(
        onPressed: cancelAction,
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.cancelButtonTitle)),)
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

  List<Widget> _androidAlertOkAction(VoidCallback okAction, BuildContext context){
    return <Widget>[
      TextButton(
        onPressed: okAction,
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)),)
    ];
  }

  List<Widget> _androidAlertTwoAction(VoidCallback okAction, VoidCallback cancelAction, BuildContext context){
    return <Widget>[
      TextButton(
        onPressed: okAction,
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.okButtonTitle)),),
      TextButton(
        onPressed: cancelAction,
        child: Text(AppLocalizations.of(context).translate(LocalizedKey.cancelButtonTitle)),)
    ];
  }
  // ---------------------- End Android Part --------------------------

  void warning(BuildContext context, String message, VoidCallback okAction) {
    String title = AppLocalizations.of(context).translate(LocalizedKey.warningAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(title, message, _androidAlertOkAction(okAction, context));
        });
  }

  void success(BuildContext context, String message, VoidCallback okAction) {
    String title = AppLocalizations.of(context).translate(LocalizedKey.successAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(title, message, _androidAlertOkAction(okAction, context));
        });
  }

  void error(BuildContext context, String message, VoidCallback okAction) {
    String title = AppLocalizations.of(context).translate(LocalizedKey.errorAlertTitle);
    showDialog(
        context: context,
        builder: (BuildContext context2){
          if (Platform.isIOS) {
            return _iOSAlert(title, message, _iOSAlertOkAction(okAction, context));
          }
          return _androidAlert(title, message, _androidAlertOkAction(okAction, context));
        });
  }

  void conformation(BuildContext context, String title, String message, VoidCallback okAction) {
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