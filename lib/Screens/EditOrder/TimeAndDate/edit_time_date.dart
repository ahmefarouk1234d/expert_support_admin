import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/date_common.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class EditTimeDate extends StatefulWidget {
  final OrderInfo order;
  final OrderBloc orderBloc;
  final String orderDocID;
  EditTimeDate({this.order, this.orderBloc, this.orderDocID});

  @override
  _EditTimeDateState createState() => _EditTimeDateState();
}

class _EditTimeDateState extends State<EditTimeDate> {
  String _time;
  String _dateformated;
  DateTime _actualDate;
  TimeOfDay _timeOfDay;
  FirebaseManager _firebaseManager;
  OrderBloc _orderBloc;
  OrderInfo _orderInfo;

  @override
  void initState() {
    _time = widget.order.visitTime;
    _dateformated = widget.order.visitDateFormatted;
    _actualDate = widget.order.visitDate;
    _firebaseManager = FirebaseManager();
    _orderBloc = widget.orderBloc;
    _orderInfo = widget.order;
    super.initState();
  }

  Future<void> _handleTime() async{
    _timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    );
    if (_timeOfDay != null){
      setState(() {
        _time = _timeOfDay.format(context);
      });
    } 
  }

  Future<void> _handleDate() async{
    DateTime dateSelected = await showDatePicker(
      context: context,
      initialDate: _actualDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2020)
    );
    if (dateSelected != null){
      setState(() {
        _actualDate = dateSelected;
        _dateformated = DateConvert().toStringFromDate(date: dateSelected);
      });
    }
  }

  _showConformatiomAlert(){
    Alert().conformation(
      context, 
      "Conformation", 
      "Are are sure you want to save the changes", 
      () => _handleSaveChange());
  }

  _handleSaveChange() async{
    try{
      Common().loading(context);
      _orderInfo.visitDate = _actualDate;
      _orderInfo.visitDateFormatted = _dateformated;
      _orderInfo.visitTime = _time;
      await _firebaseManager.updateTimeDate(_orderInfo, widget.orderDocID);
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
        title: Text("Edit Time and Date"),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DateTimeInfoRow(title: "Time", value: _time,),
            Container(height: 8,),
            DateTimeInfoRow(title: "Date", value: _dateformated,),
            Container(height: 16,),
            CommonButton(
              title: "CHANGE TIME",
              onPressed: _handleTime,
            ),
            Container(height: 8,),
            CommonButton(
              title: "CHANGE DATE",
              onPressed: _handleDate,
            ),
            Container(height: 16,),
            CommonButton(
              title: "SAVE CHANGE",
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
  DateTimeInfoRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title + ": ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: Screen.fontSize(size: 18)),),
        Text(value, style: TextStyle(fontSize: Screen.fontSize(size: 18)))
      ],
    );
  }
}