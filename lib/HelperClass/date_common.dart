import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateConvert{
  String dateFormula = 'EEEE dd MMM, yyyy';

  String toStringFromTimestamp({@required int timestamp}){
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final dateFormat = DateFormat(dateFormula).format(date);

    return dateFormat;
  }
}