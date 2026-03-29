import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/validator.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OrderLimitBloc extends Validator {
  final _perDay = BehaviorSubject<String>();
  final _unavailableEndDate = BehaviorSubject<DateTime>();
  final _unavailableStartDate = BehaviorSubject<DateTime>();

  final FirebaseManager _firebaseManager = FirebaseManager();

  OrderLimitBloc({required String perDay, required DateTime startDate, required DateTime endDate}) {
    _perDay.add(perDay);
    _unavailableEndDate.add(endDate);
    _unavailableStartDate.add(startDate);
  }

  Stream<String> get perDay => _perDay.stream.transform(validateNumberTextField);
  Function(String) get perDayChange => _perDay.sink.add;

  Stream<DateTime> get unavailableEndDate => _unavailableEndDate.stream.transform(validateDate);
  Function(DateTime) get unavailableEndDateChange => _unavailableEndDate.sink.add;

  Stream<DateTime> get unavailableStartDate => _unavailableStartDate.stream.transform(validateDate);
  Function(DateTime) get unavailableStartDateChange => _unavailableStartDate.sink.add;

  Stream<bool> get isValidUpdateFields => Rx.combineLatest3(
    perDay,
    unavailableEndDate, 
    unavailableStartDate,
    (perDay, unavailableEndDate, unavailableStartDate) {
      return true;
    }
  );

  update(BuildContext context) async {
    AppLocalizations localizations = AppLocalizations.of(context);

    if (
      (_perDay.value.isNotEmpty)
      && (_unavailableStartDate.value != null)
      && (_unavailableEndDate.value != null)
    ) {
      if (Common().canCastToInt(_perDay.value)) {

        Common().loading(context);

        int perDayNum = int.parse(_perDay.value);
        int startDate = DateConvert().getTimestamp(date: _unavailableStartDate.value);
        int endDate = DateConvert().getTimestamp(date: _unavailableEndDate.value);

        OrderLimit orderLimit = OrderLimit();
        orderLimit.perDay = perDayNum;
        orderLimit.unavaliableStartDateTimestamp = startDate;
        orderLimit.unavaliableEndDateTimestamp = endDate;

        await _firebaseManager.updateOrderLimitGeneralDetails(orderLimit);

        Common().dismiss(context);

      } else {
        Alert().warning(
        context, 
        localizations.translate(LocalizedKey.errorPerDayValueAlertMessage), 
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
    _perDay.close();
    _unavailableEndDate.close();
    _unavailableStartDate.close();
  }
}