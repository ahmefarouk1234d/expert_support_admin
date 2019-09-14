import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/auth_bloc.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onTap;
  final List<String> mainMenu;
  MainDrawer({@required this.onTap, @required this.mainMenu});

  // final List<String> mainMenu = [
  //   TextContent.homeMenu, 
  //   TextContent.offerMenu, 
  //   TextContent.usersMune, 
  //   TextContent.signOutMenu
  // ];

  @override
  Widget build(BuildContext context) {
    AppBloc _appBloc = Provider.of<AppBloc>(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: StreamBuilder<AdminUserInfo>(
          stream: _appBloc.admin,
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

  _handleMuneAction(BuildContext context){
    Navigator.of(context).pop();
    onTap(index);
    // Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    //_authBloc = AuthProvider.of(context);
    return ListTile(
        onTap: () => _handleMuneAction(context),
        title: Text(title, style: TextStyle(color: Colors.white),
      ),
    );
  }
}
