import 'dart:io';

import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Home/Offers/add_offer.dart';
import 'package:expert_support_admin/Screens/Home/Users/add_new_user.dart';
import 'package:expert_support_admin/Screens/Home/Users/users.dart';
import 'package:expert_support_admin/Screens/Home/no_role_inbox.dart';
import 'package:expert_support_admin/Screens/LoginServices/forgot_password.dart';
import 'package:expert_support_admin/Screens/LoginServices/send_verification_emai.dart';
import 'package:expert_support_admin/Screens/nav_screens.dart';
import 'package:flutter/material.dart';
import 'HelperClass/app_localizations.dart';
import 'Screens/Login/login.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Screens/Order/Common/order_details.dart';

void main() {
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
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
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
            AddOffer.route: (BuildContext context) => AddOffer(),
            Users.route: (BuildContext context) => Users(),
            ForgotPassword.route: (BuildContext context) => ForgotPassword(),
            SendVerificationEmail.route: (BuildContext context) =>
                SendVerificationEmail(),
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
  AuthStatus _authStatus = AuthStatus.notSingedIn;

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

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.signedIn) {
      return NavigatorScreens(
        onSignedOut: _signedOut,
      );
    }
    return Login(
      onSignedIn: _signedIn,
    );
  }
}
