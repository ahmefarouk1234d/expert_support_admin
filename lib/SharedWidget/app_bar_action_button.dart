import 'package:flutter/material.dart';

class AppBarActionButton extends StatelessWidget {
  AppBarActionButton({Key key, this.title, this.onPressed}): super(key: key);

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        )
      ),
    );
  }
}