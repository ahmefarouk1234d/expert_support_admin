import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/user_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewUser extends StatelessWidget {
  static String route = "/addNewUser";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      builder: (context, userBloc) => userBloc ?? UserBloc(),
      onDispose: (context, userBloc) => userBloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New User"),
          elevation: 0.0,
        ),
        body: AddNewUserContent()
      ),
    );
  }
}

class AddNewUserContent extends StatefulWidget {

  @override
  _AddNewUserContentState createState() => _AddNewUserContentState();
}

class _AddNewUserContentState extends State<AddNewUserContent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  UserBloc _userBloc;

  _showConformatiomAlert() {
    String message = "Are are sure you want to add new user";
    Alert().conformation(
        context, "Conformation", message, () => _handleAddingNewUser());
  }
 
  _saveAdminInfo(String id) async{
    try {
      _userBloc.saveAdminInfo(id);
    } on PlatformException catch (e){
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  _sendEmailVerification(FirebaseUser firebaseUser) async {
    try{
      await firebaseUser.sendEmailVerification();
    } on PlatformException catch(e){
      print(e.message);
      String alertMessage = "Could not be able to send email verification.";
      Alert().error(context, alertMessage, (){
        Common().dismiss(context);
      });
    }
  }

  _showCompletedAlert({String message}){
    Alert().success(context, message, () {
      Common().dismiss(context);
      _navigateToUsers();
    });
  }

  _navigateToUsers(){
    Common().dismiss(context);
  }

  _handleAddingNewUser() async{
    try{
      Common().loading(context);
      await _userBloc.signUp(
        onSuccess: (firebaseUser) async{
          await _saveAdminInfo(firebaseUser.uid);
          _sendEmailVerification(firebaseUser);
          Common().dismiss(context);
          _showCompletedAlert(message: "User has been added successfully");
        }, 
        onError: (error){
          Common().dismiss(context);
          Alert().error(context, error, () => Common().dismiss(context));
        }
      );
    } catch (e){
      Common().dismiss(context);
      print(e.toString());
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
                  hint: "Name",
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
                  hint: "Phone (ex: 512345678)",
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
                  hint: "Email (ex: example@email.com)",
                  controller: emailController,
                  onChange: _userBloc.emailChange,
                  isError: snapshot.hasError,
                  keyboardType: TextInputType.emailAddress,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.password,
              builder: (context, snapshot) {
                return NewUserTextFieldForm(
                  hint: "User's Password",
                  controller: passwordController,
                  onChange: _userBloc.passwordChange,
                  isError: snapshot.hasError,
                  isPassword: true,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.reEnterPassword,
              builder: (context, snapshot) {
                return NewUserTextFieldForm(
                  hint: "Re-enter User's Password",
                  controller: reEnterPasswordController,
                  onChange: _userBloc.reEnterPasswordChange,
                  isError: snapshot.hasError,
                  isPassword: true,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _userBloc.role,
              builder: (context, snapshot) {
                return UserTypeDropDown(
                  userRole: snapshot.data,
                  onUserRoleSelect: _userBloc.roleChange,
                );
              }
            ),
            Container(
              height: 16,
            ),
            StreamBuilder<bool>(
              stream: _userBloc.isValidAddFields,
              builder: (context, snapshot) {
                return CommonButton(
                  title: "ADD",
                  onPressed: snapshot.hasData ? () => _showConformatiomAlert() : null,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class NewUserTextFieldForm extends StatelessWidget {
  final String hint;
  final Function(String) onChange;
  final TextEditingController controller;
  final bool isError;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool isEnabled;
  NewUserTextFieldForm({
    @required this.hint, 
    @required this.controller,
    this.onChange,
    @required this.isError,
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
        border: Border(bottom: BorderSide(width: 1, color: isError ? Colors.red : Colors.black12)),
      ),
      child: Row(
        children: <Widget>[
          isPhoneNumber 
          ? SizedBox(
            width: Screen.screenWidth * 0.12,
            child: TextField(
                controller: TextEditingController(text: "+966"),
                enabled: false,
                decoration: InputDecoration.collapsed(hintText: "+966"),),
          ) : Container(),
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
  final String userRole;
  final Function(String) onUserRoleSelect;
  UserTypeDropDown({@required this.userRole, @required this.onUserRoleSelect});

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
          hint: Text("User Type"),
          value: userRole,
          isExpanded: true,
          onChanged: onUserRoleSelect,
          items: userRoleList
              .map((role) => DropdownMenuItem(
                    child: Container(child: Text(AdminRole().getDisplayRole(role: role)),),
                    value: role,
                  ))
              .toList(),
        ),
      )
    );
  }
}
