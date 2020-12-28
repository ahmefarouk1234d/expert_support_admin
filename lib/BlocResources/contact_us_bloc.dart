import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ContactUsBloc extends Validator {
  final _aboutUsAr = BehaviorSubject<String>();
  final _aboutUsEn = BehaviorSubject<String>();
  final _headerAr = BehaviorSubject<String>();
  final _headerEn = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _twitter = BehaviorSubject<String>();
  final _instagram = BehaviorSubject<String>();
  final _facebook = BehaviorSubject<String>();

  final FirebaseManager _firebaseManager = FirebaseManager();

  ContactUsBloc({
    String aboutUsAr,
    String aboutUsEn,
    String headerAr,
    String headerEn,
    String phone,
    String twitter,
    String instagram,
    String facebook
  }) {
    this._aboutUsAr.add(aboutUsAr);
    this._aboutUsEn.add(aboutUsEn);
    this._headerAr.add(headerAr);
    this._headerEn.add(headerEn);
    this._phone.add(phone);
    this._twitter.add(twitter);
    this._instagram.add(instagram);
    this._facebook.add(facebook);
  }

  Stream<String> get aboutUsAr => _aboutUsAr.stream.transform(validateTextField);
  Function(String) get aboutUsArChange => _aboutUsAr.sink.add;

  Stream<String> get aboutUsEn => _aboutUsEn.stream.transform(validateTextField);
  Function(String) get aboutUsEnChange => _aboutUsEn.sink.add;

  Stream<String> get headerAr => _headerAr.stream.transform(validateTextField);
  Function(String) get headerArChange => _headerAr.sink.add;
  
  Stream<String> get headerEn => _headerEn.stream.transform(validateTextField);
  Function(String) get headerEnChange => _headerEn.sink.add;

  Stream<String> get phone => _phone.stream.transform(validatePhone);
  Function(String) get phoneChange => _phone.sink.add;
  
  Stream<String> get twitter => _twitter.stream.transform(validateTextField);
  Function(String) get twitterChange => _twitter.sink.add;

  Stream<String> get instagram => _instagram.stream.transform(validateTextField);
  Function(String) get instagramChange => _instagram.sink.add;
  
  Stream<String> get facebook => _facebook.stream.transform(validateNumberTextField);
  Function(String) get facebookChange => _facebook.sink.add;

  Stream<bool> get isValidUpdateFields => Rx.combineLatest8(
    aboutUsAr,
    aboutUsEn, 
    headerAr,
    headerEn, 
    phone,
    twitter, 
    instagram,
    facebook, 
    (aboutUsAr, aboutUsEn, headerAr, headerEn, phone, twitter, instagram, facebook) {
      return true;
    }
  );

  update(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context);

    if (
      (_aboutUsAr != null && _aboutUsAr.value.isNotEmpty)
      && (_aboutUsEn != null && _aboutUsEn.value.isNotEmpty)
      && (_headerAr != null && _headerAr.value.isNotEmpty)
      && (_headerEn != null && _headerEn.value.isNotEmpty)
      && (_phone != null && _phone.value.isNotEmpty)
      && (_twitter != null && _twitter.value.isNotEmpty)
      && (_instagram != null && _instagram.value.isNotEmpty)
      && (_facebook != null && _facebook.value.isNotEmpty)
    ) {

      Common().loading(context);
      
      String formattedPhone = "+966" + _phone.value;

      AboutUs aboutUs = AboutUs();
      aboutUs.aboutUsAr = _aboutUsAr.value;
      aboutUs.aboutUsEn = _aboutUsEn.value;
      aboutUs.headerAr = _headerAr.value;
      aboutUs.headerEn = _headerEn.value;
      aboutUs.phone = formattedPhone;
      aboutUs.twitter = _twitter.value;
      aboutUs.instagram = _instagram.value;
      aboutUs.facebook = _facebook.value;

      await _firebaseManager.updateAboutUsGeneralDetails(aboutUs);

      Common().dismiss(context);

    } else {
      Alert().warning(
        context, 
        localizations.translate(LocalizedKey.errorUpdatingGeneralDetailsAlertMessage), 
        () { Common().dismiss(context); });
    }
  }

  void dispose(){
    _aboutUsAr.close();
    _aboutUsEn.close();
    _headerAr.close();
    _headerEn.close();
    _phone.close();
    _twitter.close();
    _instagram.close();
    _facebook.close();
  }
}