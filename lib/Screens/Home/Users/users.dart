import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/user_details_bloc.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/Screens/Home/Users/updateUser.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  static String route = "/Users";

  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: UsersContent(),
    );
  }
}

class UsersContent extends StatefulWidget {
  const UsersContent({super.key});

  @override
  _UsersContentState createState() => _UsersContentState();
}

class _UsersContentState extends State<UsersContent> {
  List<AdminUserInfo> usersList = [];
  late AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToUserDetails(AdminUserInfo admin, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserDetails(
              admin: admin,
            )));
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _appBloc.adminListDocument,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading users: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Loading();
          }
          usersList =
              AdminUserInfo.fromMapList(adminDocDataList: snapshot.data!.docs);
          return usersList.isEmpty
              ? NoData()
              : UsersList(
                  adminList: usersList, //.reversed.toList(),
                  onTap: _navigateToUserDetails,
                );
        });
  }
}

class UsersList extends StatelessWidget {
  final List<AdminUserInfo> adminList;
  final Function(AdminUserInfo admin, int index)? onTap;
  const UsersList({super.key, this.adminList = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    String role = AppLocalizations.of(context).translate(LocalizedKey.role);

    return Container(
        margin: EdgeInsets.only(bottom: 24),
        child: ListView.separated(
            padding: EdgeInsets.all(8),
            itemCount: adminList.length,
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black12,
                ),
            itemBuilder: (context, index) {
              final AdminUserInfo admin = adminList[index];
              bool isActive = admin.status != null &&
                  admin.status == AdminUserStatus.active;
              IconData icon = AppLocalizations.of(context).isArabic()
                  ? Icons.keyboard_arrow_left
                  : Icons.keyboard_arrow_right;
              BoxBorder border = AppLocalizations.of(context).isArabic()
                  ? Border(
                      right: BorderSide(
                          width: 4,
                          color: isActive ? Colors.green : Colors.red))
                  : Border(
                      left: BorderSide(
                          width: 4,
                          color: isActive ? Colors.green : Colors.red));

              return Container(
                decoration: BoxDecoration(
                  border: border,
                ),
                child: ListTile(
                  onTap: () => onTap!(admin, index),
                  title: Text(admin.email ?? ""),
                  subtitle: Text("$role: ${AdminRole()
                          .getDisplayRole(role: admin.role!, context: context)}"),
                  trailing: Icon(
                    icon,
                    color: Colors.black12,
                  ),
                ),
              );
            }));
  }
}

class UserDetails extends StatefulWidget {
  final AdminUserInfo admin;
  const UserDetails({super.key, required this.admin});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late AdminUserInfo admin;
  late UserDetailsBloc _bloc;

  @override
  void initState() {
    admin = widget.admin;
    _bloc = UserDetailsBloc();
    super.initState();
  }

  void _navigateToEditUser(AdminUserInfo user) {
    AdminUserInfo userToEdit = AdminUserInfo()..update(user);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateUser(
              admin: userToEdit,
              userDetailsBloc: _bloc,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate(LocalizedKey.userDetailsAppBarTitle)),
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
                  admin: snapshot.data!,
                  onEdit: () => _navigateToEditUser(
                        snapshot.data!,
                      )),
            ));
          }),
    );
  }
}

class UserDetailsContent extends StatelessWidget {
  final AdminUserInfo admin;
  final VoidCallback onEdit;
  const UserDetailsContent({super.key, required this.admin, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserDetailsRow(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.usernameTitle),
          text: admin.name ?? "",
        ),
        UserDetailsRow(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.userPhoneTitle),
          text: admin.phone ?? "",
        ),
        UserDetailsRow(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.userEmailTitle),
          text: admin.email ?? "",
        ),
        UserDetailsRow(
          title: AppLocalizations.of(context).translate(LocalizedKey.role),
          text: AdminRole().getDisplayRole(role: admin.role!, context: context),
        ),
        UserDetailsRow(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.userStatusTitle),
          text: AdminUserStatus()
              .getDisplayStatus(status: admin.status!, context: context),
        ),
        UserDetailsRow(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.userLastActionTitle),
          text: DateConvert().toStringFromTimestamp(
              timestamp: admin.dateUpdated!,
              locale: AppLocalizations.of(context).locale.languageCode,
              isFull: true),
        ),
        Container(
          height: 16,
        ),
        CommonButton(
          title: AppLocalizations.of(context)
              .translate(LocalizedKey.userEditButtonTitle),
          onPressed: onEdit,
        ),
      ],
    );
  }
}

class UserDetailsRow extends StatelessWidget {
  final String title;
  final String text;
  const UserDetailsRow({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Container(
            width: 8,
          ),
          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
  }
}
