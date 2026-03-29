import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:flutter/material.dart';

class FliterOrder extends StatelessWidget {
  const FliterOrder({
    super.key,
    this.onFromDateTap,
    this.onToDateTap,
    this.onSearchTap,
    this.onClearTap});

  final Function(DateTime)? onFromDateTap;
  final Function(DateTime)? onToDateTap;
  final Function()? onSearchTap;
  final Function()? onClearTap;

  _handleFromDate(DateTime? date, BuildContext context) async {
    DateTime? dateSelected = await _showDate(date, context);
    if (dateSelected != null) {
      onFromDateTap!(dateSelected);
    }
  }

  _handleToDate(DateTime? date, BuildContext context) async {
    DateTime? dateSelected = await _showDate(date, context);
    if (dateSelected != null) {
      onToDateTap!(dateSelected);
    }
  }

  Future<DateTime?> _showDate(DateTime? date, BuildContext context) {
    DateTime initDate = date ?? DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = Provider.of(context);
    AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<DateTime?>(
              stream: appBloc.fromDate,
              builder: (context, snapshot){
                return GestureDetector(
                  onTap: () { _handleFromDate(snapshot.data, context); },
                  child: DateDisplayVirtucallyWithBroderContainer(
                    title: localizations.translate(LocalizedKey.fromTitle), 
                    date: snapshot.data,
                  )
                );
              }
            )
          ),
          Container(width: 16),
          Expanded(
            child: StreamBuilder<DateTime?>(
              stream: appBloc.toDate,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () { _handleToDate(snapshot.data, context); },
                  child: DateDisplayVirtucallyWithBroderContainer(
                    title: localizations.translate(LocalizedKey.toTitle),
                    date: snapshot.data,
                  ),
                );
              }
            )
          ),
          Container(width: 8),
          InkWell(
            onTap: onSearchTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.search),
            )
          ),
          InkWell(
            onTap: onClearTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.clear),
            )
          )
        ],
      ),
    );
  }
}

class DateDisplayVirtucallyWithBroderContainer extends StatelessWidget {
  const DateDisplayVirtucallyWithBroderContainer({
    super.key,
    this.title = "",
    required this.date,
    this.isError = false,});

  final String title;
  final DateTime? date;
  final bool isError;

  String _getStringDate(DateTime? date, BuildContext context) {
    if (date == null) return "";

    return DateConvert().toStringFromDate(
      date: date,
      locale: AppLocalizations.of(context).locale.languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          Container(
            width: 8.0,
          ),
          Expanded(
            child: Container(
              height: Screen.screenWidth * 0.08,
              alignment: FractionalOffset.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Text(_getStringDate(date, context)),
            ),
          )
        ],
      ),
    );
  }
}
