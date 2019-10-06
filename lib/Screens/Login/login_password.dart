import 'package:expert_support_admin/BlocResources/auth_bloc.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class LoginPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  LoginPasswordTextField({this.controller});

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = Provider.of<AuthBloc>(context);
    return Container(
        height: Screen.screenWidth * 0.13,
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
                style: TextStyle(fontSize: Screen.fontSize(size: 20)),
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration:
                    InputDecoration.collapsed(hintText: TextContent.passwordPlaceholder),
              );
            }));
  }
}