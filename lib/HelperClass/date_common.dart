import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateConvert{
  String dateFormula = 'EEEE dd MMM, yyyy';

  String toStringFromTimestamp({@required int timestamp}){
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final dateFormat = DateFormat(dateFormula).format(date);

    return dateFormat;
  }

  String toStringFromDate({@required DateTime date}){
    return DateFormat(dateFormula).format(date);
  }

  String timeToString(TimeOfDay timeOfDay){
    String time = 
          timeOfDay.hourOfPeriod.toString() 
          + ":" + timeOfDay.minute.toString() 
          + " " + _getCurrentPeriod(timeOfDay.period);
    return time;
  }

  String _getCurrentPeriod(DayPeriod period){
    if (period == DayPeriod.am){
      return "AM";
    }
    return "PM";
  }
}