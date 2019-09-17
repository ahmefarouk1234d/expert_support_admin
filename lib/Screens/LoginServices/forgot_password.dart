import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/under_line_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const String route = "/ForgatPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  _handleSendingResetPassword(){
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot password"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              UnderLineTextField(
                hint: "Enter your email", 
                controller: emailController,
              ),
              Container(height: 16,),
              CommonButton(
                title: "SEND",
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}