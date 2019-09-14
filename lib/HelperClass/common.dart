import 'package:flutter/material.dart';

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
    Navigator.of(context, rootNavigator: true).pop();
  }
}
