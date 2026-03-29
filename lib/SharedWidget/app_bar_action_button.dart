import 'package:flutter/material.dart';

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({super.key, this.title, this.onPressed});

  final String? title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title ?? '',
          style: TextStyle(color: Colors.white),
        )
      ),
    );
  }
}