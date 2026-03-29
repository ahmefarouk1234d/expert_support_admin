import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const CommonButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            width: double.infinity,
            height: Screen.screenWidth * 0.12,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(title),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            )));
  }
}
