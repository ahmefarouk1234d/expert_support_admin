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
  final _vatPriceNoteAr = BehaviorSubject<String>();
  final _vatPriceNoteEn = BehaviorSubject<String>();
  final _canShowVatNote = BehaviorSubject<bool>();

  final FirebaseManager _firebaseManager = FirebaseManager();

  SubmitOrderBloc({
    required String vatPercentage,
    required bool isCashEnabled,
    required bool isPOSEnabled,
    required String limitRate,
    required String vatPriceNoteAr,
    required String vatPriceNoteEn,
    required bool canShowVatNote,
  }) {
    _vatPercentage.add(vatPercentage);
    _isCashEnabled.add(isCashEnabled);
    _isPOSEnabled.add(isPOSEnabled);
    _limitRate.add(limitRate);
    _vatPriceNoteAr.add(vatPriceNoteAr);
    _vatPriceNoteEn.add(vatPriceNoteEn);
    _canShowVatNote.add(canShowVatNote);
  }

  Stream<String> get vatPercentage => _vatPercentage.stream.transform(validateNumberTextField);
  Function(String) get vatPercentageChange => _vatPercentage.sink.add;

  Stream<bool> get isCashEnabled => _isCashEnabled.stream;
  Function(bool) get isCashEnabledChange => _isCashEnabled.sink.add;

  Stream<bool> get isPOSEnabled => _isPOSEnabled.stream;
  Function(bool) get isPOSEnabledChange => _isPOSEnabled.sink.add;

  Stream<String> get limitRate => _limitRate.stream.transform(validateNumberTextField);
  Function(String) get limitRateChange => _limitRate.sink.add;

  Stream<String> get vatPriceNoteAr => _vatPriceNoteAr.stream.transform(validateTextField);
  Function(String) get vatPriceNoteArChange => _vatPriceNoteAr.sink.add;

  Stream<String> get vatPriceNoteEn => _vatPriceNoteEn.stream.transform(validateTextField);
  Function(String) get vatPriceNoteEnChange => _vatPriceNoteEn.sink.add;

  Stream<bool> get canShowVatNote => _canShowVatNote.stream;
  Function(bool) get canShowVatNoteChange => _canShowVatNote.sink.add;


  Stream<bool> get isValidUpdateFields => Rx.combineLatest7(
    vatPercentage,
    isCashEnabled, 
    isPOSEnabled,
    limitRate,
    vatPriceNoteAr,
    vatPriceNoteEn,
    canShowVatNote,
    (vatPercentage, isCashEnabled, isPOSEnabled, limitRate, vatPriceNoteAr, vatPriceNoteEn, canShowVatNote) {
      return true;
    }
  );

  update(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context);
    
    if (
      (_vatPercentage.value.isNotEmpty)
      && (_isCashEnabled.value != null)
      && (_isPOSEnabled.value != null)
      && (_limitRate.value.isNotEmpty)
      && (_vatPriceNoteAr.value.isNotEmpty)
      && (_vatPriceNoteEn.value.isNotEmpty)
      && (_canShowVatNote.value != null)
    ) {
      if (
        Common().canCastToNum(_vatPercentage.value) 
        && Common().canCastToNum(_limitRate.value)) {

          Common().loading(context);

          num vatPercentageNum = num.parse(_vatPercentage.value);
          bool isCash = _isCashEnabled.value;
          bool isPOS = _isPOSEnabled.value;
          num limitRateNum = num.parse(_limitRate.value);
          bool canShowVatNote = _canShowVatNote.value;

          SubmitOrder submitOrder = SubmitOrder();
          submitOrder.vatPercentage = vatPercentageNum;
          submitOrder.isCashEnabled = isCash;
          submitOrder.isPOSEnabled = isPOS;
          submitOrder.limitRate = limitRateNum;
          submitOrder.vatPriceNoteAr = _vatPriceNoteAr.value;
          submitOrder.vatPriceNoteEn = _vatPriceNoteEn.value;
          submitOrder.canShowVatNote = canShowVatNote;

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
    _vatPriceNoteAr.close();
    _vatPriceNoteEn.close();
    _canShowVatNote.close();
  }
}