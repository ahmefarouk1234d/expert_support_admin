import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_limit_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/SharedWidget/bordered_textfield.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class OrderLimitGeneralDetails extends StatelessWidget {
  OrderLimitGeneralDetails({Key key, this.orderLimit});
  
  final OrderLimit orderLimit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderLimitBloc>(
      builder: (context, orderLimitBloc) => OrderLimitBloc(
        perDay: orderLimit.perDay.toString(),
        startDate: DateConvert().getDate(timestamp: orderLimit.unavaliableStartDateTimestamp),
        endDate: DateConvert().getDate(timestamp: orderLimit.unavaliableEndDateTimestamp)
      ),
      onDispose: (context, orderLimitBloc) => orderLimitBloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GeneralDetailsModel.getDisplayType(
              GeneralDetailsType.orderLimit, context)
            ),
          elevation: 0.0,),
        body: OrderLimitGeneralDetailsContent(orderLimit: orderLimit,),
      ),
    );
  }
}

class OrderLimitGeneralDetailsContent extends StatefulWidget {
  OrderLimitGeneralDetailsContent({Key key, this.orderLimit});
  
  final OrderLimit orderLimit;

  @override
  _OrderLimitGeneralDetailsContentState createState() => _OrderLimitGeneralDetailsContentState();
}

class _OrderLimitGeneralDetailsContentState extends State<OrderLimitGeneralDetailsContent> {

  OrderLimit orderLimit;
  TextEditingController _perDayController;
  OrderLimitBloc _orderLimitBloc;
  AppLocalizations _localizations;

  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    orderLimit = widget.orderLimit;
    _perDayController = TextEditingController(text: orderLimit.perDay.toString());

    _startDate = DateConvert().getDate(timestamp: orderLimit.unavaliableStartDateTimestamp);
    _endDate = DateConvert().getDate(timestamp: orderLimit.unavaliableEndDateTimestamp);

    super.initState();
  }

  _handleStartDate(DateTime date) async {
    DateTime dateSelected = await _showDate(_startDate);
    if (dateSelected != null) {
      _orderLimitBloc.unavailableStartDateChange(dateSelected);
    }
  }

  _handleEndDate(DateTime date) async {
    DateTime dateSelected = await _showDate(_endDate);
    if (dateSelected != null) {
      _orderLimitBloc.unavailableEndDateChange(dateSelected);
    }
  }

  Future<DateTime> _showDate(DateTime date) {
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050)
    );
  }

  _showConformation() {
    FocusScope.of(context).unfocus();
    Alert().conformation(
      context, 
      _localizations.translate(LocalizedKey.conformationAlertTitle), 
      _localizations.translate(LocalizedKey.orderLimitConformationAlertMessage),
      () { _orderLimitBloc.update(context); }
    );
  }

  @override
  Widget build(BuildContext context) {
    _orderLimitBloc = Provider.of<OrderLimitBloc>(context);
    _localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _orderLimitBloc.perDay,
              initialData: orderLimit.perDay.toString(),
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.orderPerDayTitle),
                  controller: _perDayController,
                  onChange: _orderLimitBloc.perDayChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  inputFormatters: Common().getNumberOnlyInputFormatters(),
                );
              }
            ),
            StreamBuilder<DateTime>(
              stream: _orderLimitBloc.unavailableStartDate,
              initialData: _startDate,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () { _handleStartDate(snapshot.data); },
                  child: DateDisplayWithBroderContainer(
                    header: _localizations.translate(LocalizedKey.unavailableStartDateTitle),
                    date: snapshot.data,
                    isError: snapshot.hasError,
                  ),
                );
              }
            ),
            StreamBuilder<DateTime>(
              stream: _orderLimitBloc.unavailableEndDate,
              initialData: _endDate,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () { _handleEndDate(snapshot.data); },
                  child: DateDisplayWithBroderContainer(
                    header: _localizations.translate(LocalizedKey.unavailableEndDateTitle),
                    date: snapshot.data,
                    isError: snapshot.hasError,
                  ),
                );
              }
            ),
            Container(height: 16,),
            StreamBuilder<bool>(
              stream: _orderLimitBloc.isValidUpdateFields,
              builder: (context, snapshot) {
                return CommonButton(
                  title: _localizations.translate(LocalizedKey.updateButtonTitle), 
                  onPressed: snapshot.hasData ? () { _showConformation(); } : null
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

class DateDisplayWithBroderContainer extends StatelessWidget {
  DateDisplayWithBroderContainer({
    Key key, 
    this.header = "", 
    @required this.date,
    this.isError = false,}): super(key: key);

  final String header;
  final DateTime date;
  final bool isError;

  String _getStringDate(DateTime date, BuildContext context) {
    return DateConvert().toStringFromDate(
      date: date,
      locale: AppLocalizations.of(context).locale.languageCode, 
      isFull: true
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(header),
          Container(
            height: 8.0,
          ),
          Container(
            height: Screen.screenWidth * 0.12,
            alignment: FractionalOffset.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Text(_getStringDate(date, context)),
          )
        ],
      ),
    );
  }
}