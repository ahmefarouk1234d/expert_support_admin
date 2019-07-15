import 'package:expert_support_admin/BlocResources/Login/auth_bloc.dart';
import 'package:expert_support_admin/BlocResources/Login/auth_provider.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/Main/app_bloc_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Screens/Login/login.dart';
import 'package:expert_support_admin/Screens/NewUser/add_new_user.dart';
import 'package:expert_support_admin/Screens/Offers/add_offer.dart';
import 'package:expert_support_admin/main.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onTap;
  MainDrawer({@required this.onTap});

  final List<String> mainMenu = [
    TextContent.homeMenu, 
    TextContent.offerMenu, 
    TextContent.usersMune, 
    TextContent.signOutMenu
  ];

  @override
  Widget build(BuildContext context) {
    AuthBloc _authBloc = AuthProvider.of(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: StreamBuilder<AdminUserInfo>(
          stream: _authBloc.admin,
          builder: (context, snapshot) {
            print("admin info: ${snapshot.data}");
            return Column(
              children: <Widget>[
                MenuHeader(),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(8),
                    itemCount: mainMenu.length,
                    itemBuilder: (context, index) => MainDrawerRow(index, mainMenu[index], (index) => onTap(index)),
                    separatorBuilder: (context, index) => Divider(color: Colors.black54,),
                  )
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(child: Center(child: Text("Export support logo")),);
  }
}

class MainDrawerRow extends StatelessWidget {
  final int index;
  final String title;
  final Function(int) onTap;
  MainDrawerRow(this.index, this.title, this.onTap);

  FirebaseManager _firebaseManager = FirebaseManager();

  _dismissDrawer(BuildContext context){ 
    onTap(index);
    Navigator.of(context).pop(); 
  }

  _goToLogin(BuildContext context){
    final _bloc = AppBloc();
    final _authBloc = AuthBloc();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MyApp(authBloc: _authBloc, appBloc: _bloc,)));
  }

  _signOut(BuildContext context) async{
    try{
      await _firebaseManager.signOut();
      _goToLogin(context);
    } catch(error){
      print("Error signing out");
    }
  }

  _handleMuneAction(BuildContext context){
    if (title == TextContent.signOutMenu){
      _signOut(context);
      return;
    }
    _dismissDrawer(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => _handleMuneAction(context),
        title: Text(title, style: TextStyle(color: Colors.white),
      ),
    );
  }
}
