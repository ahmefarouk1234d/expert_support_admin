import 'package:expert_support_admin/BlocResources/Login/auth_bloc.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Home/home.dart';
import 'package:expert_support_admin/Screens/nav_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final AuthBloc bloc;
  LoginButton({this.bloc});

  _handleLogin(BuildContext context) async{
    try{
      Common.loading(context);
      FirebaseUser user = await bloc.signIn();
      print("user: $user"); 
      _handleUpdateUserInfo(context, user.uid);
    } catch (error){
      print("Error signing in: ${error.toString()}");
      Common.dismiss(context);
    }
  }

  _handleUpdateUserInfo(BuildContext context, String userId) async{
    try{
      bloc.saveAdminInfo(userId);
      await bloc.updateAdminDetails(userId);
      Common.dismiss(context);
      _navigteToHome(context);
    } catch (error){
      print("Error update user in: ${error.toString()}");
    }
  }

  _navigteToHome(BuildContext context){
    Navigator.of(context).pushReplacementNamed(NavigatorScreens.route);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Screen.screenWidth * 0.12,
      child: StreamBuilder<bool>(
          stream: bloc.isValidSignUpFields,
          builder: (context, snapshot) {
            return RaisedButton(
              onPressed: snapshot.hasData ? () =>  _handleLogin(context) : null,
              child: Text(TextContent.loginButtonTitle),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
            );
          }),
    );
  }
}