import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class AddNewUser extends StatefulWidget {
  static String route = "/addNewUser";

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Hi new user"),),
    );
  }
}

