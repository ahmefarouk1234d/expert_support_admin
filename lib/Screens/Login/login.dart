import 'package:expert_support_admin/BlocResources/auth_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_notification.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Login/login_email_textfield.dart';
import 'package:expert_support_admin/Screens/Login/login_password.dart';
import 'package:expert_support_admin/Screens/Login/login_sign_in_button.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/Screens/LoginServices/forgot_password.dart';
import 'package:expert_support_admin/Screens/LoginServices/send_verification_emai.dart';
import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   static String route = "/Login";
//   final VoidCallback onSignedIn;
//   Login({@required this.onSignedIn});

//   @override
//   _LoginState createState() => _LoginState();
// }

class Login extends StatelessWidget {
  static String route = "/Login";
  final VoidCallback onSignedIn;
  Login({@required this.onSignedIn});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Screen.instance.init(context);
    return BlocProvider<AuthBloc>(
      builder: (context, authBloc) => authBloc ?? AuthBloc(),
      onDispose: (context, authBloc) => authBloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(TextContent.appName),
        ),
        body: LoginForm(
          onSignedIn: onSignedIn, 
          emailController: emailController, 
          passwordController: passwordController,)
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignedIn;
  LoginForm({@required this.onSignedIn, this.emailController, this.passwordController});

  _navigateToForgatPassword(BuildContext context){
    Navigator.of(context).pushNamed(ForgotPassword.route);
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    FirebaseNotifications().setUpFirebase(_authBloc);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            LoginEmailTextField(controller: emailController,),
            Container(
              height: 8,
            ),
            LoginPasswordTextField(controller: passwordController,),
            Container(
              height: 16,
            ),
            LoginButton(onSignedIn: onSignedIn,),
            Container(
              height: 8,
            ),
            LinkButton(title: "Forgot Password?", onPressed: () => _navigateToForgatPassword(context),),
          ],
        ),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  LinkButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Text(title),
      onPressed: onPressed,
      textColor: Colors.blue,
    );
  }
}