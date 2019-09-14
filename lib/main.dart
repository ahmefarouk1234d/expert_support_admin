import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Home/no_role_inbox.dart';
import 'package:expert_support_admin/Screens/NewUser/add_new_user.dart';
import 'package:expert_support_admin/Screens/NewUser/users.dart';
import 'package:expert_support_admin/Screens/Offers/add_offer.dart';
import 'package:expert_support_admin/Screens/Order/PendingOrders/pending_order_details.dart';
import 'package:expert_support_admin/Screens/nav_screens.dart';
import 'package:flutter/material.dart';
import 'Screens/Home/PendingOrders/pending_inbox.dart';
import 'Screens/Login/login.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';

import 'Screens/Order/Common/order_details.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   static String route = "/MyApp";
//   final AppBloc appBloc;
//   final AuthBloc authBloc;
//   MyApp({this.appBloc, this.authBloc});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

class MyApp extends StatelessWidget {
  static String route = "/MyApp";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      builder: (context, appBloc) => appBloc ?? AppBloc(),
      onDispose: (context, appBloc) => appBloc.dispose(),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: CommonData.mainMaterialColor),
        home: Main(),
        routes: <String, WidgetBuilder>{
          NoRoleInbox.route: (BuildContext context) => NoRoleInbox(),
          OrderDetails.route: (BuildContext context) => OrderDetails(),
          AddNewUser.route : (BuildContext context) => AddNewUser(),
          AddOffer.route: (BuildContext context) => AddOffer(),
          PendingInbox.route: (BuildContext context) => PendingInbox(),
          PendingOrderDetails.route: (BuildContext context) => PendingOrderDetails(),
          Users.route: (BuildContext context) => Users(),
        },
      )
    );
  }
}

class Main extends StatefulWidget {
  static String route = "/Main";

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AuthStatus _authStatus = AuthStatus.notSingedIn;

  @override
  void initState() {
    super.initState();
  }

  _signedIn(){
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  _signedOut(){
    setState(() {
      _authStatus = AuthStatus.notSingedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.signedIn){
      return NavigatorScreens(onSignedOut: _signedOut,);
    }
    return Login(onSignedIn: _signedIn,);
  }
}