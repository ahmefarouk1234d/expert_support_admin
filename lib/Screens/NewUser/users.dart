import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/user_details_bloc.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Screens/NewUser/updateUser.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  static String route = "/Users";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: UsersContent(),
    );
  }
}

class UsersContent extends StatefulWidget {
  @override
  _UsersContentState createState() => _UsersContentState();
}

class _UsersContentState extends State<UsersContent> {
  List<AdminUserInfo> usersList;
  AppBloc _appBloc;

  @override
  void initState() {
    usersList = List();
    super.initState();
  }

  _navigateToUserDetails(AdminUserInfo admin, int index){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserDetails(admin: admin,)
    ));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.adminListDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } 
        usersList = AdminUserInfo.fromMapList(adminDocDataList: snapshot.data.documents);
        return usersList.isEmpty 
          ? NoData() 
          : UsersList(
              adminList: usersList, //.reversed.toList(), 
              onTap: _navigateToUserDetails,
            );
      }
    );
  }
}

class UsersList extends StatelessWidget {
  final List<AdminUserInfo> adminList;
  final Function(AdminUserInfo admin, int index) onTap;
  UsersList({this.adminList, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: adminList.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black12,),
        itemBuilder: (context, index) {
          final AdminUserInfo admin = adminList[index];
          bool isActive = admin.status != null && admin.status == AdminUserStatus.active;
          return Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(width: 4, color: isActive ? Colors.green : Colors.red)),
            ),
            child: ListTile(
              onTap: () => onTap(admin, index),
              title: Text(admin.email ?? ""),
              subtitle: Text("Role: " + (AdminRole().getDisplayRole(role: admin.role))),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black12,),
            ),
          );
        }
      )
    );
  }
}

class UserDetails extends StatefulWidget {
  final AdminUserInfo admin;
  UserDetails({@required this.admin});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  AdminUserInfo admin;
  UserDetailsBloc _bloc;

  @override
  void initState() {
    admin = widget.admin;
    _bloc = UserDetailsBloc();
    super.initState();
  }

  _navigateToEditUser(AdminUserInfo user){
    AdminUserInfo userToEdit = AdminUserInfo()..update(user);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UpdateUser(admin: userToEdit, userDetailsBloc: _bloc,)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        elevation: 0.0,
      ),
      body: StreamBuilder<AdminUserInfo>(
        stream: _bloc.user,
        initialData: admin,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: UserDetailsContent(
                admin: snapshot.data, 
                onEdit: () => _navigateToEditUser(snapshot.data,)
              ),
            )
          );
        }
      ),
    );
  }
}

class UserDetailsContent extends StatelessWidget {
  final AdminUserInfo admin;
  final VoidCallback onEdit;
  UserDetailsContent({@required this.admin, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
            children: <Widget>[
              UserDetailsRow(title: "Name", text: admin.name ?? "",),
              UserDetailsRow(title: "Phone", text: admin.phone ?? "",),
              UserDetailsRow(title: "email", text: admin.email ?? "",),
              UserDetailsRow(title: "Role", text: AdminRole().getDisplayRole(role: admin.role),),
              UserDetailsRow(title: "Status", text: AdminUserStatus().getDisplayStatus(status: admin.status),),
              UserDetailsRow(title: "Last Action", text: DateConvert().toStringFromTimestamp(timestamp: admin.dateUpdated),),
              Container(height: 16,),
              CommonButton(
                title: "Edit",
                onPressed: onEdit,
              ),
            ],
          );
  }
}

class UserDetailsRow extends StatelessWidget {
  final String title;
  final String text;
  UserDetailsRow({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(title),
          Container(width: 8,),
          Expanded(child: Text(text),)
        ],
      ),
    );
  }
}





