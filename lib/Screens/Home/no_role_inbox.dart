import 'package:flutter/material.dart';


class NoRoleInbox extends StatefulWidget {
  static const route = "/Home";

  @override
  _NoRoleInboxState createState() => _NoRoleInboxState();
}

class _NoRoleInboxState extends State<NoRoleInbox> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Could not get your role. Please contact support for more info with you email."),),
    );
  }
}