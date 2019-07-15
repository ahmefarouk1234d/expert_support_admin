import 'package:expert_support_admin/BlocResources/Login/auth_bloc.dart';
import 'package:expert_support_admin/BlocResources/Login/auth_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_notification.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Login/login_email_textfield.dart';
import 'package:expert_support_admin/Screens/Login/login_password.dart';
import 'package:expert_support_admin/Screens/Login/login_sign_in_button.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static String route = "/Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Screen.instance.init(context);
    _authBloc = AuthProvider.of(context);
    FirebaseNotifications().setUpFirebase(_authBloc);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(TextContent.appName),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            LoginEmailTextField(controller: emailController, bloc: _authBloc,),
            Container(
              height: 8,
            ),
            LoginPasswordTextField(controller: passwordController, bloc: _authBloc,),
            Container(
              height: 16,
            ),
            LoginButton(bloc: _authBloc,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }
}
