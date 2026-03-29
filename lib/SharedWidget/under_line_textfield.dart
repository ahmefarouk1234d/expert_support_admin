import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class UnderLineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isError;
  final Function(String)? onChange;
  final String hint;
  final bool isPassowrd;
  final TextInputType keyboardType;
  const UnderLineTextField({super.key, this.onChange, this.isError = false, this.controller, this.hint = "", this.isPassowrd = false, this.keyboardType = TextInputType.text});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.screenWidth * 0.15,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: isError ? Colors.red : Colors.black12)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChange,
              obscureText: isPassowrd,
              keyboardType: keyboardType,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }
}