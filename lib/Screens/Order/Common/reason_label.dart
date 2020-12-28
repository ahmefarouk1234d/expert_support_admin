import 'package:flutter/material.dart';

class ReasonLabel extends StatelessWidget {
  final String header;
  final String reason;
  ReasonLabel({this.header, this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: <Widget>[
          Text(
            header + ": ",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: Text(reason),
          ),
        ],
      ),
    );
  }
}