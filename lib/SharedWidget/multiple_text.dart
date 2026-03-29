import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class MultipleLineText extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Color borderColor;
  const MultipleLineText({super.key, this.controller, this.hint, this.borderColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.screenWidth * 0.25,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        decoration: InputDecoration.collapsed(
          hintText: hint
        ),
      ),
    );
  }
}