import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SharedBloc extends Validator {
  final _iosLink = BehaviorSubject<String>();
  final _androidLink = BehaviorSubject<String>();

  final FirebaseManager _firebaseManager = FirebaseManager();

  SharedBloc({
    required String ios,
    required String android
  }) {
    _iosLink.add(ios);
    _androidLink.add(android);
  }

  Stream<String> get iosLink => _iosLink.stream.transform(validateTextField);
  Function(String) get iosLinkChange => _iosLink.sink.add;

  Stream<String> get androidLink => _androidLink.stream.transform(validateTextField);
  Function(String) get androidLinkChange => _androidLink.sink.add;

  Stream<bool> get isValidUpdateFields => Rx.combineLatest2(
    iosLink,
    androidLink, 
    (iosLink, androidLink) {
      return true;
    }
  );

  update(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context);

    if (
      (_iosLink.value.isNotEmpty)
      && (_androidLink.value.isNotEmpty)
    ) {

      Common().loading(context);

      Shared shared = Shared();
      shared.link = _iosLink.value;
      shared.linkAndroid = _androidLink.value;

      await _firebaseManager.updateSharedGeneralDetails(shared);

      Common().dismiss(context);

    } else {
      Alert().warning(
        context, 
        localizations.translate(LocalizedKey.errorUpdatingGeneralDetailsAlertMessage), 
        () { Common().dismiss(context); });
    }
  }

  void dispose(){
    _iosLink.close();
    _androidLink.close();
  }
}