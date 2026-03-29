import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/day_time_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class EditTimeDate extends StatefulWidget {
  final OrderInfo? order;
  final OrderBloc? orderBloc;
  final String? orderDocID;
  const EditTimeDate({super.key, this.order, this.orderBloc, this.orderDocID});

  @override
  _EditTimeDateState createState() => _EditTimeDateState();
}

class _EditTimeDateState extends State<EditTimeDate> {
  late String _time;
  TimeOfDay? _timeOfDayDB;
  late DateTime _actualDate;
  DateTime? _completeDateAndTime;
  TimeOfDay? _timeOfDay;
  late FirebaseManager _firebaseManager;
  late OrderBloc _orderBloc;
  late OrderInfo _orderInfo;

  @override
  void initState() {
    _time = widget.order!.visitTime!;
    _actualDate = widget.order!.visitDate!;
    if (widget.order!.visitDateAndTime != null){
      _timeOfDayDB = TimeOfDay(
        hour: widget.order!.visitDateAndTime!.hour,
        minute: widget.order!.visitDateAndTime!.minute
      );
    }
    _firebaseManager = FirebaseManager();
    _orderBloc = widget.orderBloc!;
    _orderInfo = widget.order!;
    super.initState();
  }

  Future<void> _handleTime() async{
    _timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_timeOfDay != null){
      setState(() {
        _timeOfDayDB = _timeOfDay;
        _time = DayTime().getTimeOfDayDB(period: _timeOfDay!.period);
        _completeDateAndTime = DateTime(_actualDate.year, _actualDate.month, _actualDate.day, _timeOfDay!.hour, _timeOfDay!.minute);
      });
    }
  }

  Future<void> _handleDate() async{
    DateTime? dateSelected = await showDatePicker(
      context: context,
      initialDate: _actualDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050)
    );
    if (dateSelected != null){
      setState(() {
        _actualDate = dateSelected;
        _completeDateAndTime = DateTime(_actualDate.year, _actualDate.month, _actualDate.day, _timeOfDayDB!.hour, _timeOfDayDB!.minute);
      });
    }
  }

  _showConformatiomAlert(){
    Alert().conformation(
      context, 
      AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), 
      AppLocalizations.of(context).translate(LocalizedKey.editDateSaveAlertTitle), 
      () => _handleSaveChange());
  }

  _handleSaveChange() async{
    try{
      Common().loading(context);
      _orderInfo.visitDate = _actualDate;
      _orderInfo.visitTime = _time;
      _orderInfo.visitDateAndTime = _completeDateAndTime;
      await _firebaseManager.updateTimeDate(_orderInfo, widget.orderDocID!);
      _orderBloc.ordersChange.add(_orderInfo);
      Common().dismiss(context);
      Navigator.of(context).pop();
    }
    catch (error){
      print("Updateing services error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(LocalizedKey.editOrderAppBarTitle)),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DateTimeInfoRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.editDateTimeTitle), 
              value: 
                _timeOfDayDB != null
                ? _timeOfDayDB!.format(context)
                : DayTime().getDisplayStatus(dayTime: _time, context: context),),
            Container(height: 8,),
            DateTimeInfoRow(
              title: AppLocalizations.of(context).translate(LocalizedKey.editDateDateTitle), 
              value: DateConvert().toStringFromDate(
                date: _actualDate, 
                locale: AppLocalizations.of(context).locale.languageCode, 
                isFull: true)),
            Container(height: 16,),
            CommonButton(
              title: AppLocalizations.of(context).translate(LocalizedKey.editDateChangeTimeButtonTitle),
              onPressed: _handleTime,
            ),
            Container(height: 8,),
            CommonButton(
              title: AppLocalizations.of(context).translate(LocalizedKey.editDateChangeDateButtonTitle),
              onPressed: _handleDate,
            ),
            Container(height: 16,),
            CommonButton(
              title: AppLocalizations.of(context).translate(LocalizedKey.editDateSaveChangeButtonTitle),
              onPressed: _showConformatiomAlert,
            )
          ],
        )
      ),
    );
  }
}

class DateTimeInfoRow extends StatelessWidget {
  final String title;
  final String value;
  const DateTimeInfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("$title: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: Screen.fontSize(size: 18)),),
        Text(value, style: TextStyle(fontSize: Screen.fontSize(size: 18)))
      ],
    );
  }
}
