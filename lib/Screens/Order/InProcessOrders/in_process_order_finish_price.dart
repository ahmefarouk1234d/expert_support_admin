import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class InProcessFinishOrderPriceTextField extends StatelessWidget {
  const InProcessFinishOrderPriceTextField({super.key, this.title, this.controller, this.borderColor, this.onChange});

  final String? title;
  final TextEditingController? controller;
  final Color? borderColor;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title ?? '')),
        Container(width: 16,),
        Container(
          width: Screen.screenWidth * 0.25,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor ?? Colors.black, width: 2),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChange,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration.collapsed(
              hintText: "0.0"
            ),
          ),
        )
      ],
    );
  }
}