import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateConvert{
  final String _fullDateFormula = 'EEEE dd MMM, yyyy';
  final String _dateFormula = 'dd/MM/yyyy';

  String toStringFromTimestamp({required int timestamp, String? locale, bool isFull = false}){
    String formula = isFull ? _fullDateFormula : _dateFormula;
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final dateFormat = DateFormat(formula, locale).format(date);

    return dateFormat;
  }

  String toStringFromDate({required DateTime date, String? locale, bool isFull = false}){
    String formula = isFull ? _fullDateFormula : _dateFormula;
    return DateFormat(formula, locale).format(date);
  }

  String timeToString(TimeOfDay timeOfDay, BuildContext context){
    bool isArabic = AppLocalizations.of(context).isArabic();
    String time = 
          "${timeOfDay.hourOfPeriod}:${timeOfDay.minute} ${_getCurrentPeriod(timeOfDay.period, isArabic)}";
    return time;
  }

  String _getCurrentPeriod(DayPeriod period, bool isArabic){
    if (period == DayPeriod.am){
      return isArabic ? "صباحاً" : "AM";
    }
    return isArabic ? "مساءاً" : "PM";
  }
  
  int getTimestamp({required DateTime date}) {
    return _normalizeDate(date).millisecondsSinceEpoch;
  }

  DateTime getDate({required int timestamp}) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day, 12);
  }
}