import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class PhoneBorderedTextfield extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  final TextInputType keyboardType;
  final double height;
  final TextDirection textDirection;
  PhoneBorderedTextfield({
    Key key,
    this.header,
    this.hint = "",
    this.controller,
    this.isError = false,
    @required this.onChange,
    this.keyboardType = TextInputType.text,
    this.height,
    this.textDirection
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(header),
          Container(
            height: 8.0,
          ),
          Container(
            height: Screen.screenWidth * 0.12,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              textDirection: textDirection,
              children: <Widget>[
                SizedBox(
                  width: Screen.screenWidth * 0.12,
                  child: TextField(
                      controller: TextEditingController(text: "+966"),
                      enabled: false,
                      decoration: InputDecoration.collapsed(hintText: "+966"),
                      textDirection: textDirection,),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    onChanged: onChange,
                    decoration: InputDecoration.collapsed(hintText: hint),
                    textDirection: textDirection,
                    inputFormatters: Common().getNumberOnlyInputFormatters(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}