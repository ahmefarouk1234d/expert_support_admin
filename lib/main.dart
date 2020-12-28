import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/code.dart';
import 'package:expert_support_admin/Screens/Home/Discount/add_discount.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_order_offer.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_packages.dart';
import 'package:expert_support_admin/Screens/Home/Offers/offer_type.dart';
import 'package:expert_support_admin/Screens/Home/Users/add_new_user.dart';
import 'package:expert_support_admin/Screens/Home/Users/users.dart';
import 'package:expert_support_admin/Screens/Home/no_role_inbox.dart';
import 'package:expert_support_admin/Screens/LoginServices/forgot_password.dart';
import 'package:expert_support_admin/Screens/LoginServices/send_verification_emai.dart';
import 'package:expert_support_admin/Screens/nav_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HelperClass/app_localizations.dart';
import 'Screens/Login/login.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Screens/Order/Common/order_details.dart';
import 'SharedWidget/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   static String route = "/MyApp";

//   @override
//   _MyAppState createState() => _MyAppState();
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
        builder: (context, appBloc) => appBloc ?? AppBloc(),
        onDispose: (context, appBloc) => appBloc.dispose(),
        child: MaterialApp(
          theme: ThemeData(
              primarySwatch: CommonData.mainMaterialColor,
              fontFamily: 'BigVesta'),
          // List all of the app's supported locales here
          supportedLocales: Code.localCodes,
          //These delegates make sure that the localization data for the proper language is loaded
          localizationsDelegates: [
            // A class which loads the translations from JSON files
            AppLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if local is null, use the first one
            if (locale == null) {
              debugPrint("*language locale is null!!!");
              return supportedLocales.first;
            }
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (Platform.isIOS) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              } else {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          home: Main(),
          routes: <String, WidgetBuilder>{
            NoRoleInbox.route: (BuildContext context) => NoRoleInbox(),
            OrderDetails.route: (BuildContext context) => OrderDetails(),
            AddNewUser.route: (BuildContext context) => AddNewUser(),
            AddOrderOffer.route: (BuildContext context) => AddOrderOffer(),
            Users.route: (BuildContext context) => Users(),
            ForgotPassword.route: (BuildContext context) => ForgotPassword(),
            SendVerificationEmail.route: (BuildContext context) =>
                SendVerificationEmail(),
            AddDiscount.route: (BuildContext context) => AddDiscount(),
            OfferTypeScreen.route: (BuildContext context) => OfferTypeScreen(),
            AddPackages.route: (BuildContext context) => AddPackages(),
          },
        ));
  }
}

class Main extends StatefulWidget {
  static String route = "/Main";

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AuthStatus _authStatus; // = AuthStatus.notSingedIn;
  final _firebaseManager = FirebaseManager();

  get adminID => null;

  @override
  void initState() {
    super.initState();
  }

  _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSingedIn;
    });
  }

  _checkSignIn(AppBloc appBloc) async {
    User user = await _firebaseManager.getUser();
    if (user == null) {
      setState(() {
        _authStatus = AuthStatus.notSingedIn;
      });
    } else {
      DocumentSnapshot _adminDoc =
          await _firebaseManager.getAdminInfo(user.uid);
      AdminUserInfo _adminInfo = AdminUserInfo.fromMap(_adminDoc)
        ..id = user.uid;
      appBloc.adminChange.add(_adminInfo);
      setState(() {
        _authStatus = AuthStatus.signedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Screen.instance.init(context);
    AppBloc _appBloc = Provider.of<AppBloc>(context);
    if (_authStatus != null) {
      if (_authStatus == AuthStatus.signedIn) {
        return NavigatorScreens(
          onSignedOut: _signedOut,
        );
      }
      return Login(
        onSignedIn: _signedIn,
      );
    }
    _checkSignIn(_appBloc);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Loading(),
    );
  }
}
