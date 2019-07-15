import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Screens/Home/home.dart';
import 'package:expert_support_admin/Screens/Home/main_drawer.dart';
import 'package:expert_support_admin/Screens/NewUser/add_new_user.dart';
import 'package:expert_support_admin/Screens/Offers/add_offer.dart';
import 'package:flutter/material.dart';

class NavScreen{
  Widget widget;
  String title;

  NavScreen({@required this.title, @required this.widget});
}

class NavigatorScreens extends StatefulWidget {
  static String route = "/NavigatorScreens";

  @override
  _NavigatorScreensState createState() => _NavigatorScreensState();
}

class _NavigatorScreensState extends State<NavigatorScreens> {
  List<NavScreen> _navScreenList;
  int _selectedScreen;

  @override
  void initState() {
    _navScreenList = [
    NavScreen(title: TextContent.homeTitle, widget: Home()), 
    NavScreen(title: TextContent.offerTitle, widget: AddOffer()), 
    NavScreen(title: TextContent.usersTitle, widget: AddNewUser())];
    _selectedScreen = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_navScreenList[_selectedScreen].title),
          elevation: 0.0,
        ),
        drawer: MainDrawer(onTap: (index){
          setState(() {
            _selectedScreen = index;
          });
        }),
        body: _navScreenList[_selectedScreen].widget,
      );
  }
}