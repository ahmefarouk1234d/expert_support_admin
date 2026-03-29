import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BorderedTextField extends StatelessWidget {
  final String? header;
  final String hint;
  final TextEditingController? controller;
  final bool isError;
  final Function(String) onChange;
  final TextInputType keyboardType;
  final double? height;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool isEnabled;
  final List<TextInputFormatter>? inputFormatters;
  const BorderedTextField({
    super.key,
    this.header,
    this.hint = "",
    this.controller,
    this.isError = false,
    required this.onChange,
    this.keyboardType = TextInputType.text,
    this.height,
    this.maxLines,
    this.textDirection,
    this.isEnabled = true,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;
    
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(header ?? ''),
          Container(
            height: 8.0,
          ),
          Container(
            height: height ?? Screen.screenWidth * 0.12,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChange,
              maxLines: maxLines,
              decoration: InputDecoration.collapsed(hintText: hint),
              textDirection: textDirection,
              enabled: isEnabled,
              inputFormatters: inputFormatters
            ),
          ),
        ],
      ),
    );
  }
}