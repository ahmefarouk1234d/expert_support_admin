import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  loading(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  getNumberOnlyInputFormatters() {
    return [
      WhitelistingTextInputFormatter(RegExp("[0-9]")),
      WhitelistingTextInputFormatter.digitsOnly
    ];
  }

  bool canCastToInt(String value) {
    if (value == null) {
      return false;
    }
    return int.tryParse(value) != null;
  }

  bool canCastToDouble(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  bool canCastToNum(String value) {
    if (value == null) {
      return false;
    }
    return num.tryParse(value) != null;
  }
}
