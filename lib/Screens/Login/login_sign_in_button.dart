import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/auth_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onSignedIn;
  const LoginButton({super.key, required this.onSignedIn});

  _updateAdminInfo(
      BuildContext context, AuthBloc bloc, AppBloc appBloc, User admin) async {
    try {
      AdminUserInfo adminInfo = await bloc.reteiveAdminInfo(admin.uid);
      appBloc.adminChange.add(adminInfo);
    } catch (error) {
      String alertMessage = TextContent.requestCompleteError;
      Alert().error(context, alertMessage, () {
        Common().dismiss(context);
      });
    }
  }

  _handleLogin(BuildContext context, AuthBloc bloc, AppBloc appBloc) async {
    Common().loading(context);
    await bloc.signIn(onSuccess: (admin) async {
      // if (admin.isEmailVerified){
      //   await bloc.updateFcmToken(admin.uid);
      //   _updateAdminInfo(context, bloc, appBloc, admin);
      //   Common().dismiss(context);
      //   onSignedIn();
      // } else {
      //   Common().dismiss(context);
      //   Alert().conformation(context, "Not Verified", "Your email is not verified. Do you want to re-send verification email? ", (){
      //     Common().dismiss(context);
      //     Navigator.of(context).pushNamed(SendVerificationEmail.route);
      //   });
      // }

      await bloc.updateFcmToken(admin.user!.uid);
      _updateAdminInfo(context, bloc, appBloc, admin.user!);
      Common().dismiss(context);
      onSignedIn();
    }, onError: (error) {
      Common().dismiss(context);
      Alert().error(context, error, () {
        Common().dismiss(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = Provider.of<AuthBloc>(context);
    AppBloc appBloc = Provider.of<AppBloc>(context);
    return SizedBox(
      width: double.infinity,
      height: Screen.screenWidth * 0.13,
      child: StreamBuilder<bool>(
          stream: bloc.isValidSignUpFields,
          builder: (context, snapshot) {
            return ElevatedButton(
              onPressed: snapshot.hasData
                  ? () => _handleLogin(context, bloc, appBloc)
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                AppLocalizations.of(context)
                    .translate(LocalizedKey.loginButtontitle),
                style: TextStyle(fontSize: Screen.fontSize(size: 20)),
              ),
            );
          }),
    );
  }
}
