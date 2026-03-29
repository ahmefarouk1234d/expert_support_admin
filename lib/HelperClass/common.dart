import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  void loading(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  List<TextInputFormatter> getNumberOnlyInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      FilteringTextInputFormatter.digitsOnly
    ];
  }

  bool canCastToInt(String value) {
    return int.tryParse(value) != null;
  }

  bool canCastToDouble(String value) {
    return double.tryParse(value) != null;
  }

  bool canCastToNum(String value) {
    return num.tryParse(value) != null;
  }

  void removeFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  String getAppVersion() {
    return "Version 1.0";
  }
}
