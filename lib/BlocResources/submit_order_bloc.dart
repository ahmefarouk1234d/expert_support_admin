import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SubmitOrderBloc extends Validator {
  final _vatPercentage = BehaviorSubject<String>();
  final _isCashEnabled = BehaviorSubject<bool>();
  final _isPOSEnabled = BehaviorSubject<bool>();
  final _limitRate = BehaviorSubject<String>();

  final FirebaseManager _firebaseManager = FirebaseManager();

  SubmitOrderBloc({String vatPercentage, bool isCashEnabled, bool isPOSEnabled, String limitRate}) {
    this._vatPercentage.add(vatPercentage);
    this._isCashEnabled.add(isCashEnabled);
    this._isPOSEnabled.add(isPOSEnabled);
    this._limitRate.add(limitRate);
  }

  Stream<String> get vatPercentage => _vatPercentage.stream.transform(validateNumberTextField);
  Function(String) get vatPercentageChange => _vatPercentage.sink.add;

  Stream<bool> get isCashEnabled => _isCashEnabled.stream;
  Function(bool) get isCashEnabledChange => _isCashEnabled.sink.add;

  Stream<bool> get isPOSEnabled => _isPOSEnabled.stream;
  Function(bool) get isPOSEnabledChange => _isPOSEnabled.sink.add;

  Stream<String> get limitRate => _limitRate.stream.transform(validateNumberTextField);
  Function(String) get limitRateChange => _limitRate.sink.add;

  Stream<bool> get isValidUpdateFields => Rx.combineLatest4(
    _vatPercentage,
    _isCashEnabled, 
    _isPOSEnabled,
    _limitRate, 
    (_vatPercentage, _isCashEnabled, _isPOSEnabled, _limitRate) {
      return true;
    }
  );

  update(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context);
    
    if (
      (_vatPercentage != null && _vatPercentage.value.isNotEmpty)
      && (_isCashEnabled != null && _isCashEnabled.value != null)
      && (_isPOSEnabled != null && _isPOSEnabled.value != null)
      && (_limitRate != null && _limitRate.value.isNotEmpty)
    ) {
      if (
        Common().canCastToNum(_vatPercentage.value) 
        && Common().canCastToNum(_limitRate.value)) {

          Common().loading(context);

          num vatPercentageNum = num.parse(_vatPercentage.value);
          bool isCash = _isCashEnabled.value;
          bool isPOS = _isPOSEnabled.value;
          num limitRateNum = num.parse(_limitRate.value);

          SubmitOrder submitOrder = SubmitOrder();
          submitOrder.vatPercentage = vatPercentageNum;
          submitOrder.isCashEnabled = isCash;
          submitOrder.isPOSEnabled = isPOS;
          submitOrder.limitRate = limitRateNum;

          await _firebaseManager.updateSubmitOrderGeneralDetails(submitOrder);

          Common().dismiss(context);

      } else {
        Alert().warning(
        context, 
        localizations.translate(LocalizedKey.errorVATandLimitRateValuesAlertMessage), 
        () { Common().dismiss(context); });
      }
    } else {
      Alert().warning(
        context, 
        localizations.translate(LocalizedKey.errorUpdatingGeneralDetailsAlertMessage), 
        () { Common().dismiss(context); });
    }
  }

  void dispose(){
    _vatPercentage.close();
    _isCashEnabled.close();
    _isPOSEnabled.close();
    _limitRate.close();
  }
}