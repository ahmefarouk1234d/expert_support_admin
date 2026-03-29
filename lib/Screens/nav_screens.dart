import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/menu_list.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Screens/Home/Discount/add_discount.dart';
import 'package:expert_support_admin/Screens/Home/Offers/offer_type.dart';
import 'package:expert_support_admin/Screens/Home/Users/add_new_user.dart';
import 'package:expert_support_admin/Screens/Home/main_drawer.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class NavigatorScreens extends StatefulWidget {
  static String route = "/NavigatorScreens";
  final VoidCallback onSignedOut;
  const NavigatorScreens({super.key, required this.onSignedOut});

  @override
  _NavigatorScreensState createState() => _NavigatorScreensState();
}

class _NavigatorScreensState extends State<NavigatorScreens> {
  late NavScreen _navScreenList;
  late int _selectedScreen;
  late AppBloc _appBloc;
  final FirebaseManager _firebaseManager = FirebaseManager();

  @override
  void initState() {
    _selectedScreen = 0;
    super.initState();
  }

  _handleMenuTapped(int index) async {
    String signOutMenuTitle =
        AppLocalizations.of(context).translate(LocalizedKey.signOutMenuTitle);
    if (_navScreenList.menuList[index] == signOutMenuTitle) {
      _signOutConformation(signOutMenuTitle);
    } else {
      _appBloc.fromDateChange.add(null);
      _appBloc.toDateChange.add(null);

      setState(() {
        _selectedScreen = index;
      });
    }
  }

  _signOutConformation(String title) {
    String signOutMenuAlertMessage = AppLocalizations.of(context)
        .translate(LocalizedKey.signOutAlertMessage);
    Alert().conformation(
        context, title, signOutMenuAlertMessage, () => _signOut());
  }

  _signOut() async {
    try {
      await _firebaseManager.signOut();
      widget.onSignedOut();
    } catch (error) {
      print("Error signing out");
    }
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    Screen.instance.init(context);
    return StreamBuilder<AdminUserInfo>(
        stream: _appBloc.admin,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _navScreenList = MenuList(context).getMenuList(snapshot.data!.role);
            return Scaffold(
                appBar: AppBar(
                  title: Text(_navScreenList.navWidget[_selectedScreen].title),
                  actions: <Widget>[
                    ActionsAppBar(
                      title: _navScreenList.navWidget[_selectedScreen].title,
                    )
                  ],
                  elevation: 0.0,
                ),
                drawer: MainDrawer(
                    mainMenu: _navScreenList.menuList,
                    onTap: _handleMenuTapped),
                body: _navScreenList.navWidget[_selectedScreen].widget);
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
            ),
            body: Loading(),
          );
        });
  }
}

class ActionsAppBar extends StatelessWidget {
  final String title;
  const ActionsAppBar({super.key, required this.title});

  _handleAddingNewUser(BuildContext context) {
    Navigator.of(context).pushNamed(AddNewUser.route);
  }

  _handleAddingNewOrderOffer(BuildContext context) {
    Navigator.of(context).pushNamed(OfferTypeScreen.route);
    // Navigator.of(context).pushNamed(AddOrderOffer.route);
  }

  _handleAddingNewdiscount(BuildContext context) {
    Navigator.of(context).pushNamed(AddDiscount.route);
  }

  @override
  Widget build(BuildContext context) {
    if (title ==
        AppLocalizations.of(context).translate(LocalizedKey.usersMenuTitle)) {
      return AddButtonBar(
        onPressed: () => _handleAddingNewUser(context),
      );
    } else if (title ==
        AppLocalizations.of(context).translate(LocalizedKey.offerMenuTitle)) {
      return AddButtonBar(
        onPressed: () => _handleAddingNewOrderOffer(context),
      );
    } else if (title ==
        AppLocalizations.of(context)
            .translate(LocalizedKey.discountMenuTitle)) {
      return AddButtonBar(
        onPressed: () => _handleAddingNewdiscount(context),
      );
    }
    return Container();
  }
}

class AddButtonBar extends StatelessWidget {
  final VoidCallback onPressed;
  const AddButtonBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        onPressed: onPressed,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ));
  }
}
