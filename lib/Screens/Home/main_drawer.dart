import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onTap;
  final List<String> mainMenu;
  const MainDrawer({super.key, required this.onTap, required this.mainMenu});

  // final List<String> mainMenu = [
  //   TextContent.homeMenu, 
  //   TextContent.offerMenu, 
  //   TextContent.usersMune, 
  //   TextContent.signOutMenu
  // ];

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = Provider.of<AppBloc>(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: StreamBuilder<AdminUserInfo>(
          stream: appBloc.admin,
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                MenuHeader(adminName: snapshot.hasData ? (snapshot.data!.name ?? "") : "",),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(8),
                    itemCount: mainMenu.length,
                    itemBuilder: (context, index) => MainDrawerRow(index, mainMenu[index], (index) => onTap(index)),
                    separatorBuilder: (context, index) => Divider(color: Colors.black54,),
                  )
                ),
                Text(Common().getAppVersion())
              ],
            );
          }
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  final String adminName;
  const MenuHeader({super.key, this.adminName = ""});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Center(child: Text(adminName, style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}

class MainDrawerRow extends StatelessWidget {
  final int index;
  final String title;
  final Function(int) onTap;
  const MainDrawerRow(this.index, this.title, this.onTap, {super.key});

  void _handleMuneAction(BuildContext context){
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
