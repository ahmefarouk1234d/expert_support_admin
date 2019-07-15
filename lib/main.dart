import 'package:expert_support_admin/BlocResources/Login/auth_bloc.dart';
import 'package:expert_support_admin/BlocResources/Login/auth_provider.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc_provider.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Home/home.dart';
import 'package:expert_support_admin/Screens/NewUser/add_new_user.dart';
import 'package:expert_support_admin/Screens/Offers/add_offer.dart';
import 'package:expert_support_admin/Screens/nav_screens.dart';
import 'package:flutter/material.dart';
import 'Screens/Login/login.dart';

void main() {
  final _bloc = AppBloc();
  final _authBloc = AuthBloc();
  runApp(MyApp(
    appBloc: _bloc,
    authBloc: _authBloc,
  ));
}

class MyApp extends StatelessWidget {
  final AppBloc appBloc;
  final AuthBloc authBloc;
  MyApp({this.appBloc, this.authBloc});

  @override
  Widget build(BuildContext context) {
    return AuthBlocProvider(
      builder: (context, authBloc) => authBloc,
      onDispose: (context, authBloc) => authBloc.dispose(),
      child: AppBlocProvider(
          builder: (context, appBloc) => appBloc,
          onDispose: (context, appBloc) => appBloc.dispose(),
          child: MaterialApp(
            theme: ThemeData(primarySwatch: CommonData.mainMaterialColor),
            home: Main(),
            routes: <String, WidgetBuilder>{
              Login.route: (BuildContext context) => Login(),
              NavigatorScreens.route: (BuildContext context) => NavigatorScreens(),
              Home.route: (BuildContext context) => Home(),
              AddNewUser.route : (BuildContext context) => AddNewUser(),
              AddOffer.route: (BuildContext context) => AddOffer(),
            },
          )),
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
