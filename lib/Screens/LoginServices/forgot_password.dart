import 'package:expert_support_admin/BlocResources/login_services.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/under_line_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const String route = "/ForgatPassword";

  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  late LoginServicesBloc _bloc;

  @override
  void initState(){
    _bloc = LoginServicesBloc();
    super.initState();
  }

  _handleSendingResetPassword() async{
    Common().loading(context);
    await _bloc.resetPassword(() => _onSuccessReset(), (error) => _onFailReset(error));
  }

  _onSuccessReset(){
    Common().dismiss(context);
    _showCompletedAlert();
  }

  _onFailReset(String error){
    Common().dismiss(context);
    Alert().error(context, error, () => Common().dismiss(context));
  }

  _showCompletedAlert(){
    Alert().success(context, AppLocalizations.of(context).translate(LocalizedKey.forgotPasswordSuccessAlertMessage), 
    () {
      Common().dismiss(context);
      emailController.clear();
      _bloc.emailChange('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(LocalizedKey.forgotPasswordAppBarTitle)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                stream: _bloc.email,
                builder: (context, snapshot) {
                  return UnderLineTextField(
                    hint: AppLocalizations.of(context).translate(LocalizedKey.forgotPasswordPlaceholderText), 
                    controller: emailController,
                    onChange: _bloc.emailChange,
                    isError: snapshot.hasError,
                    keyboardType: TextInputType.emailAddress,
                  );
                }
              ),
              Container(height: 16,),
              StreamBuilder<bool>(
                stream: _bloc.isValidField,
                builder: (context, snapshot) {
                  return CommonButton(
                    title: AppLocalizations.of(context).translate(LocalizedKey.forgotPasswordSendButtonTitle),
                    onPressed: snapshot.hasData ? () => _handleSendingResetPassword() : null,
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
