import 'package:expert_support_admin/BlocResources/change_password_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangePasswordContent(),
    );
  }
}

class ChangePasswordContent extends StatefulWidget {
  @override
  _ChangePasswordContentState createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<ChangePasswordContent> {
  TextEditingController newPasswordController = TextEditingController();
  ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    _changePasswordBloc = ChangePasswordBloc();
    super.initState();
  }

  _showCompletedAlert(){
    Alert().success(context, 
    AppLocalizations.of(context).translate(LocalizedKey.changePasswordSuccessAlertMessage), 
    () {
      Common().dismiss(context);
      newPasswordController.clear();
      _changePasswordBloc.newPasswordChange(null);
    });
  }

  _handleChangePassword() async{
    Common().loading(context);
    _changePasswordBloc.changePassword(
      (){
        print("Password change successfully");
        Common().dismiss(context);
        _showCompletedAlert();
      }, (error){
        print("error: $error");
        Common().dismiss(context);
      });
  }

  _showConformatiomAlert() {
    String message = AppLocalizations.of(context).translate(LocalizedKey.changePasswordAlertMessage);
    Alert().conformation(
        context, "Conformation", message, () => _handleChangePassword());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _changePasswordBloc.newPassword,
              builder: (context, snapshot) {
                return ChangePasswordTextField(
                  hint: AppLocalizations.of(context).translate(LocalizedKey.newPasswordPlaceholderText), 
                  controller: newPasswordController,
                  isError: snapshot.hasError,
                  onChange: _changePasswordBloc.newPasswordChange,);
              }
            ),
            Container(height: 16,),
            StreamBuilder<bool>(
              stream: _changePasswordBloc.isValidField,
              builder: (context, snapshot) {
                return CommonButton(
                  title: AppLocalizations.of(context).translate(LocalizedKey.changePasswordButtonTitle),
                  onPressed: snapshot.hasData ? () => _showConformatiomAlert() : null,
                );
              }
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _changePasswordBloc.dispose();
    super.dispose();
  }
}

class ChangePasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  final String hint;
  ChangePasswordTextField({this.onChange, this.isError = false, this.controller, this.hint});


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
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChange,
              obscureText: true,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }
}