import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/user_bloc.dart';
import 'package:expert_support_admin/BlocResources/user_details_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Screens/Home/Users/add_new_user.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateUser extends StatelessWidget {
  static String route = "/addNewUser";
  final AdminUserInfo admin;
  final UserDetailsBloc userDetailsBloc;
  const UpdateUser({super.key, required this.admin, required this.userDetailsBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      builder: (context, userBloc) => userBloc ?? UserBloc(),
      onDispose: (context, userBloc) => userBloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate(LocalizedKey.userUpdateAppBarNameTitle)),
          elevation: 0.0,
        ),
        body: UpdateUserContent(admin: admin, userDetailsBloc: userDetailsBloc,)
      ),
    );
  }
}

class UpdateUserContent extends StatefulWidget {
  final AdminUserInfo admin;
  final UserDetailsBloc userDetailsBloc;
  const UpdateUserContent({super.key, required this.admin, required this.userDetailsBloc});
  
  @override
  _UpdateUserContentState createState() => _UpdateUserContentState();
}

class _UpdateUserContentState extends State<UpdateUserContent> {
  TextEditingController? nameController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? reEnterPasswordController;
  late AdminUserInfo admin;
  late UserBloc _userBloc;
  String? phoneWithNoAreaCode;
  late bool isIntials;
  String? adminRole;

  @override
  void initState() {
    admin = widget.admin;
    isIntials = false;
    super.initState();
  }

  void _initialValues(){
    String name = admin.name ?? '';
    String phone = admin.phone ?? '';
    String email = admin.email ?? '';
    String role = admin.role ?? '';

    nameController = TextEditingController(text: name);
    _userBloc.nameChange(name);
      phoneWithNoAreaCode = phone.replaceAll('+966', '');
    phoneController = TextEditingController(text: phoneWithNoAreaCode);
    _userBloc.phoneChange(phoneWithNoAreaCode ?? '');
      emailController = TextEditingController(text: email);
    _userBloc.emailChange(email);
      _userBloc.roleChange(role);
    adminRole = role;
      isIntials = true;
  }

  void _showConformatiomAlertForUpdate() {
    String message = AppLocalizations.of(context).translate(LocalizedKey.userUpdateAlertMessage);
    Alert().conformation(
        context, AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, () => _updateAdminInfo());
  }
 
  void _updateAdminInfo() async{
    try {
      Common().loading(context);
      _userBloc.updateAdminInfo(admin.id ?? '');

      admin.name = nameController!.text;
      admin.email = emailController!.text;
      admin.phone =  "+966${phoneController!.text}";
      admin.role = adminRole;
      admin.dateUpdated = DateTime.now().toUtc().millisecondsSinceEpoch;
      widget.userDetailsBloc.userChange.add(admin);

      Common().dismiss(context);
      _showCompletedAlert(message: AppLocalizations.of(context).translate(LocalizedKey.userUpdateSuccessAlertMessage));
    } on PlatformException catch (e){
      Alert().error(context, e.message ?? '', () => Common().dismiss(context));
    }
  }

  void _showConformatiomAlertForDelete() {
    String message = AppLocalizations.of(context).translate(LocalizedKey.userDeleteAlertMessage);
    Alert().conformation(
        context,AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, () => _deleteAdminInfo());
  }

  void _deleteAdminInfo() async{
    try {
      Common().loading(context);
      _userBloc.deleteAdminInfo(widget.admin.id ?? '');

      admin.status = AdminUserStatus.deleted;
      admin.dateUpdated = DateTime.now().toUtc().millisecondsSinceEpoch;
      widget.userDetailsBloc.userChange.add(admin);

      Common().dismiss(context);
      _showCompletedAlert(message: AppLocalizations.of(context).translate(LocalizedKey.userDeleteSuccessAlertMessage));
    } on PlatformException catch (e){
      Alert().error(context, e.message ?? '', () => Common().dismiss(context));
    }
  }

  void _showCompletedAlert({String? message}){
    Alert().success(context, message ?? '', () {
      Common().dismiss(context);
      _navigateToUserDetails();
    });
  }

  void _navigateToUserDetails(){
    Common().dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    _userBloc = Provider.of<UserBloc>(context);
    if (!isIntials) _initialValues();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _userBloc.name,
              builder: (context, snapshot) {
                return NewUserTextFieldForm(
                  hint: AppLocalizations.of(context).translate(LocalizedKey.usernameTitle),
                  controller: nameController,
                  onChange: _userBloc.nameChange,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.phone,
              builder: (context, snapshot) {
                return NewUserTextFieldForm(
                  hint: "${AppLocalizations.of(context).translate(LocalizedKey.userPhoneTitle)} ${AppLocalizations.of(context).translate(LocalizedKey.userPhoneExample)}",
                  controller: phoneController,
                  onChange: _userBloc.phoneChange,
                  isError: snapshot.hasError,
                  keyboardType: TextInputType.phone,
                  isPhoneNumber: true,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.email,
              builder: (context, snapshot) {
                return NewUserTextFieldForm(
                  hint: "${AppLocalizations.of(context).translate(LocalizedKey.userEmailTitle)} ${AppLocalizations.of(context).translate(LocalizedKey.userEmailExample)}",
                  controller: emailController,
                  onChange: _userBloc.emailChange,
                  isError: snapshot.hasError,
                  isEnabled: false,
                  keyboardType: TextInputType.emailAddress,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.role,
              builder: (context, snapshot) {
                return UserTypeDropDown(
                  userRole: snapshot.data,
                  onUserRoleSelect: (value) {
                    adminRole = value;
                    _userBloc.roleChange(value ?? '');
                  },
                );
              }
            ),
            Container(
              height: 16,
            ),
            StreamBuilder<bool>(
              stream: _userBloc.isValidUpdateFields,
              builder: (context, snapshot) {
                return CommonButton(
                  title: AppLocalizations.of(context).translate(LocalizedKey.userUpdateButtonTitle),
                  onPressed: snapshot.hasData ? () => _showConformatiomAlertForUpdate() : null,
                );
              }
            ),
            Container(height: 16,),
            CommonButton(
              title: AppLocalizations.of(context).translate(LocalizedKey.userDeleteButtonTitle),
              onPressed: () => _showConformatiomAlertForDelete(),
            ),
          ],
        ),
      ),
    );
  }
}