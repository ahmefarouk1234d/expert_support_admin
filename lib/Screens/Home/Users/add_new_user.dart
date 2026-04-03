import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/user_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class AddNewUser extends StatelessWidget {
  static String route = "/addNewUser";

  const AddNewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      builder: (context, userBloc) => userBloc ?? UserBloc(),
      onDispose: (context, userBloc) => userBloc?.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate(LocalizedKey.userNewAppBarTitle)),
            elevation: 0.0,
          ),
          body: AddNewUserContent()),
    );
  }
}

class AddNewUserContent extends StatefulWidget {
  const AddNewUserContent({super.key});

  @override
  _AddNewUserContentState createState() => _AddNewUserContentState();
}

class _AddNewUserContentState extends State<AddNewUserContent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  late UserBloc _userBloc;

  void _showConformatiomAlert() {
    String message = AppLocalizations.of(context)
        .translate(LocalizedKey.userAddAlertMessage);
    Alert().conformation(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.conformationAlertTitle),
        message,
        () => _handleAddingNewUser());
  }

  void _showCompletedAlert({String? message}) {
    Alert().success(context, message ?? '', () {
      Common().dismiss(context);
      _navigateToUsers();
    });
  }

  void _navigateToUsers() {
    Common().dismiss(context);
  }

  void _handleAddingNewUser() async {
    try {
      Common().loading(context);
      await _userBloc.createAdminUser();
      Common().dismiss(context);
      _showCompletedAlert(
          message: AppLocalizations.of(context)
              .translate(LocalizedKey.userAddSuccessAlertMessage));
    } catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.toString(), () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    _userBloc = Provider.of<UserBloc>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
                stream: _userBloc.name,
                builder: (context, snapshot) {
                  return NewUserTextFieldForm(
                    hint: AppLocalizations.of(context)
                        .translate(LocalizedKey.usernameTitle),
                    controller: nameController,
                    onChange: _userBloc.nameChange,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _userBloc.phone,
                builder: (context, snapshot) {
                  return NewUserTextFieldForm(
                    hint: "${AppLocalizations.of(context)
                            .translate(LocalizedKey.userPhoneTitle)} ${AppLocalizations.of(context)
                            .translate(LocalizedKey.userPhoneExample)}",
                    controller: phoneController,
                    onChange: _userBloc.phoneChange,
                    isError: snapshot.hasError,
                    keyboardType: TextInputType.phone,
                    isPhoneNumber: true,
                  );
                }),
            StreamBuilder<String>(
                stream: _userBloc.email,
                builder: (context, snapshot) {
                  return NewUserTextFieldForm(
                    hint: "${AppLocalizations.of(context)
                            .translate(LocalizedKey.userEmailTitle)} ${AppLocalizations.of(context)
                            .translate(LocalizedKey.userEmailExample)}",
                    controller: emailController,
                    onChange: _userBloc.emailChange,
                    isError: snapshot.hasError,
                    keyboardType: TextInputType.emailAddress,
                  );
                }),
            StreamBuilder<String>(
                stream: _userBloc.password,
                builder: (context, snapshot) {
                  return NewUserTextFieldForm(
                    hint: AppLocalizations.of(context)
                        .translate(LocalizedKey.userPasswordPlaceholderText),
                    controller: passwordController,
                    onChange: _userBloc.passwordChange,
                    isError: snapshot.hasError,
                    isPassword: true,
                  );
                }),
            StreamBuilder<String>(
                stream: _userBloc.reEnterPassword,
                builder: (context, snapshot) {
                  return NewUserTextFieldForm(
                    hint: AppLocalizations.of(context).translate(
                        LocalizedKey.userReEnterPasswordPlaceholderText),
                    controller: reEnterPasswordController,
                    onChange: _userBloc.reEnterPasswordChange,
                    isError: snapshot.hasError,
                    isPassword: true,
                  );
                }),
            StreamBuilder<String>(
                stream: _userBloc.role,
                builder: (context, snapshot) {
                  return UserTypeDropDown(
                    userRole: snapshot.data,
                    onUserRoleSelect: (role) => _userBloc.roleChange(role ?? ''),
                  );
                }),
            Container(
              height: 16,
            ),
            StreamBuilder<bool>(
                stream: _userBloc.isValidAddFields,
                builder: (context, snapshot) {
                  return CommonButton(
                    title: AppLocalizations.of(context)
                        .translate(LocalizedKey.userAddButtonTitle),
                    onPressed: snapshot.hasData
                        ? () => _showConformatiomAlert()
                        : null,
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class NewUserTextFieldForm extends StatelessWidget {
  final String hint;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final bool isError;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool isEnabled;
  const NewUserTextFieldForm(
      {super.key, required this.hint,
      required this.controller,
      this.onChange,
      required this.isError,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.isPhoneNumber = false,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.screenWidth * 0.15,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: isError ? Colors.red : Colors.black12)),
      ),
      child: Row(
        children: <Widget>[
          isPhoneNumber
              ? SizedBox(
                  width: Screen.screenWidth * 0.12,
                  child: TextField(
                    controller: TextEditingController(text: "+966"),
                    enabled: false,
                    decoration: InputDecoration.collapsed(hintText: "+966"),
                  ),
                )
              : Container(),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChange,
              keyboardType: keyboardType,
              obscureText: isPassword,
              enabled: isEnabled,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          )
        ],
      ),
    );
  }
}

class UserTypeDropDown extends StatelessWidget {
  final String? userRole;
  final Function(String?)? onUserRoleSelect;
  UserTypeDropDown({super.key, required this.userRole, required this.onUserRoleSelect});

  final List<String> userRoleList = [
    AdminRole.customerService,
    AdminRole.technicion,
    AdminRole.accountant,
    AdminRole.supervisor,
    AdminRole.admin,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Screen.screenWidth * 0.15,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(AppLocalizations.of(context)
                .translate(LocalizedKey.userTypeDropDownPlaceholderText)),
            value: userRole,
            isExpanded: true,
            onChanged: onUserRoleSelect,
            items: userRoleList
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Container(
                        child: Text(AdminRole()
                            .getDisplayRole(role: role, context: context)),
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
