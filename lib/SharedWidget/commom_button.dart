import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed; 
  CommonButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            width: double.infinity,
            height: Screen.screenWidth * 0.12,
            child: RaisedButton(
              onPressed: onPressed,
              child: Text(title),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            )));
  }
}
