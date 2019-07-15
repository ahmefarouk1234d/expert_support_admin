import 'package:expert_support_admin/BlocResources/Login/auth_bloc.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class LoginPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final AuthBloc bloc;
  LoginPasswordTextField({this.controller, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Screen.screenWidth * 0.12,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        padding: EdgeInsets.only(left: 8, right: 8),
        child: StreamBuilder<String>(
            stream: bloc.password,
            builder: (context, snapshot) {
              return TextField(
                controller: controller,
                onChanged: bloc.passwordChange,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration:
                    InputDecoration.collapsed(hintText: TextContent.passwordPlaceholder),
              );
            }));
  }
}