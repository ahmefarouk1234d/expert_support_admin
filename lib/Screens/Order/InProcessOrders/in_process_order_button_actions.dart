import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_images.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_prices.dart';
import 'package:expert_support_admin/Screens/Order/InProcessOrders/in_process_order_finish_price.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/multiple_text.dart';
import 'package:flutter/material.dart';

class InProcessActionButtons extends StatefulWidget {
  final OrderInfo order;
  final TextEditingController reasonController;
  final TextEditingController totalMoneyReceivedController;
  final TextEditingController totalPartsPriceController;
  final TextEditingController partsFeesController;

  InProcessActionButtons(this.order, this.reasonController, this.totalMoneyReceivedController, this.totalPartsPriceController, this.partsFeesController);

  @override
  _InProcessActionButtonsState createState() => _InProcessActionButtonsState();
}

class _InProcessActionButtonsState extends State<InProcessActionButtons> {
  FirebaseManager _firebaseManager = FirebaseManager();
  bool _isEnabled;
  bool _isViewImageEnabled;
  OrderInfo _order;
  OrderBloc _orderBloc;
  AppBloc _appBloc;
  Color _reasonBorderColor;
  Color _moneyReceivedBorderColor;
  Color _partsTotalBorderColor;
  Color _partsFeesBorderColor;
  double _partsFees = 0.0;
  double _partsTotal = 0.0;

  @override
  void initState() {
    _setUp();
    super.initState();
  }

  _setUp(){
    _order = widget.order;
    _isEnabled = 
      (_order.workflowStatus == WorkflowStatus.inProcess) 
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply)
      || (_order.workflowStatus == WorkflowStatus.onTheWay)
      || (_order.workflowStatus == WorkflowStatus.arrived);
    _isViewImageEnabled = _order.imagesUrl.isNotEmpty;
    _reasonBorderColor = Colors.black;
    _moneyReceivedBorderColor = Colors.black;
    _partsTotalBorderColor = Colors.black;
    _partsFeesBorderColor = Colors.black;
  }

  bool get _isInProcess {
    return _order.workflowStatus == WorkflowStatus.inProcess
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.inProcess);
  }

  bool get _isOnTheWay {
    return _order.workflowStatus == WorkflowStatus.onTheWay
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.onTheWay);
  }

  bool get _isArrived {
    return _order.workflowStatus == WorkflowStatus.arrived
      || (_order.workflowStatus == WorkflowStatus.requestChangeReply
        && _order.orderStatus == WorkflowStatus.arrived);
  }

  String get _mainActionButtonTitle {
    AppLocalizations localizations = AppLocalizations.of(context);
    
    if (_isInProcess) {
      return localizations.translate(LocalizedKey.inTheWayButtonTite);
    } else if (_isOnTheWay) {
      return localizations.translate(LocalizedKey.startWorkingButtonTitle);
    } else if (_isArrived) {
      return localizations.translate(LocalizedKey.doneButtonTitle);
    } else {
      return localizations.translate(LocalizedKey.doneButtonTitle);
    }
  }

  String get _newWorkflowStatus {
    if (_isInProcess) {
      return WorkflowStatus.onTheWay;
    } else if (_isOnTheWay) {
      return WorkflowStatus.arrived;
    } else if (_isArrived) {
      return WorkflowStatus.done;
    } else {
      return "";
    }
  }

  String get _newOrderStatus {
    switch (_order.orderStatus) {
      case OrderStatus.inProcess:
        return OrderStatus.onTheWay;
      case OrderStatus.onTheWay:
        return OrderStatus.arrived;
      case OrderStatus.arrived:
        return OrderStatus.done;
      default:
        return "";
    }
  }


  _onPartsFeesChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _partsFees = 0.0;
      });
    } else if (isValidText(value)) {
      final double valueDouble = double.parse(value);
      setState(() {
        _partsFees = valueDouble;
      });
    }
  }

  _onPartsTotalChange(String value) {
    if (value.isEmpty) {
      setState(() {
        _partsTotal = 0.0;
      });
    } else if (isValidText(value)) {
      final double valueDouble = double.parse(value);
      setState(() {
        _partsTotal = valueDouble;
      });
    }
  }

  bool _isValidReason() {
    if (widget.reasonController.text.isEmpty){
      setState(() {
        _reasonBorderColor = Colors.red;
      });
      return false;
    }

    return true;
  }

  bool isValidText(String text) {
    RegExp regExpForNum = RegExp("^\\d+(\\.\\d{1,2})?\$");
    return regExpForNum.hasMatch(text) && text.isNotEmpty;
  }

  bool _isValidFinishOrderPrice() {
    List<OrderService> serviceWithNeededParts = _order.orderService.where((s) => s.neededParts == true).toList();
    
    bool isInvalidMoneyReceived = !isValidText(widget.totalMoneyReceivedController.text);
    bool isInvalidPartsPrice = 
      serviceWithNeededParts.length > 0 && 
      !isValidText(widget.totalPartsPriceController.text);
    bool isInvalidPartsFees = 
      serviceWithNeededParts.length > 0 && 
      !isValidText(widget.partsFeesController.text);

    setState(() {
      _moneyReceivedBorderColor = isInvalidMoneyReceived ? Colors.red : Colors.black;
      _partsTotalBorderColor = isInvalidPartsPrice ? Colors.red : Colors.black;
      _partsFeesBorderColor = isInvalidPartsFees ? Colors.red : Colors.black;
    });
    
    return !isInvalidMoneyReceived && !isInvalidPartsPrice && !isInvalidPartsFees;
  }

  bool isValidMainAction() {
    if (_order.workflowStatus == WorkflowStatus.arrived) {
      if (!_isValidFinishOrderPrice()) {
        return false;
      }
      setState(() {
        _moneyReceivedBorderColor = Colors.black;
        _partsTotalBorderColor = Colors.black;
        _partsFeesBorderColor = Colors.black;
      });
    }
    return true;
  }
  
  _onMainActionButtonTapped(AsyncSnapshot<AdminUserInfo> snapshot) {
    FocusScope.of(context).unfocus();
    if (isValidMainAction()) {
      if (snapshot.hasData){
          _showConformatiomAlert(
            orderStatus: _newOrderStatus, 
            workflowStatus: _newWorkflowStatus,
            message: AppLocalizations.of(context).translate(LocalizedKey.doneAlertMessage), 
            admin: snapshot.data);
        }
    }
  }

  _onRequestChangeButtonTapped(AsyncSnapshot<AdminUserInfo> snapshot) {
    if (_isValidReason()) {
      setState(() {
        _reasonBorderColor = Colors.black;
      });
      if (snapshot.hasData){
        _showConformatiomAlert(
          orderStatus: _order.orderStatus,
          workflowStatus: WorkflowStatus.requestChange, 
          message: AppLocalizations.of(context).translate(LocalizedKey.requestChangeAlertMessage), 
          admin: snapshot.data);
      }
    }
  }

  _showConformatiomAlert({
    @required String orderStatus, 
    @required String workflowStatus, 
    @required String message, 
    @required AdminUserInfo admin}){
    Alert().conformation(
      context, 
      AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), 
      message, 
      () => _handleAction(orderStatus: orderStatus, workflowStatus: workflowStatus, admin: admin));
  }

  _handleViewImages() async{
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderImages(imageUrls: _order.imagesUrl,)));
  }

  _handleAction({
    @required String orderStatus, 
    @required String workflowStatus, 
    @required AdminUserInfo admin}) async{
      String partTotals = widget.totalPartsPriceController.text;
      String partFees = widget.partsFeesController.text;
      String moneyReceived = widget.totalMoneyReceivedController.text;

    Common().loading(context);

    _order.orderStatus = orderStatus;
    _order.lastWorkflowStatus = _order.workflowStatus;
    _order.lastTechWorkflowStatus = _order.workflowStatus;
    _order.workflowStatus = workflowStatus;

    _order.adminFees = partTotals.isEmpty ? 0.0 : double.parse(partTotals);
    _order.partsFees = partFees.isEmpty ? 0.0 : double.parse(partFees);
    _order.totalMoneyReceived = moneyReceived.isEmpty ? 0.0 : double.parse(moneyReceived);

    _orderBloc.ordersChange.add(_order);

    String changeRequestDeatils = 
      widget.reasonController.text.isNotEmpty || workflowStatus == WorkflowStatus.requestChange
      ? widget.reasonController.text 
      : null;
    await _firebaseManager.updateOrderStatus(_order, admin, changeRequestDetails: changeRequestDeatils);
    
    Common().dismiss(context);

    if (!((_order.workflowStatus == WorkflowStatus.onTheWay)
      || (_order.workflowStatus == WorkflowStatus.arrived))
      ) {
        setState(() {
          _isEnabled = false;
        });
      }
  }
  
  @override
  Widget build(BuildContext context) {
    _orderBloc = Provider.of<OrderBloc>(context);
    _appBloc = Provider.of<AppBloc>(context);

    return StreamBuilder<AdminUserInfo>(
      stream: _appBloc.admin,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: <Widget>[
              _isArrived
                ? Column(
                    children: <Widget>[
                      InProcessFinishOrderPriceTextField(
                        title: AppLocalizations.of(context).translate(LocalizedKey.adminFeesTitle), 
                        controller: widget.partsFeesController, 
                        borderColor: _partsFeesBorderColor,
                        onChange: _onPartsFeesChange,),
                      InProcessFinishOrderPriceTextField(
                        title: AppLocalizations.of(context).translate(LocalizedKey.partsTotalPriceTitle), 
                        controller: widget.totalPartsPriceController, 
                        borderColor: _partsTotalBorderColor,
                        onChange: _onPartsTotalChange,),
                      Container(height: 16),
                      PriceRow(
                        title: AppLocalizations.of(context).translate(LocalizedKey.customerShouldPay), 
                        price: (widget.order.totalPriceWithVAT + _partsTotal + _partsFees),),
                      Container(height: 8),
                      InProcessFinishOrderPriceTextField(
                        title: AppLocalizations.of(context).translate(LocalizedKey.moneyReceivedTitle), 
                        controller: widget.totalMoneyReceivedController, 
                        borderColor: _moneyReceivedBorderColor,),
                    ]
                  )
                : Container(),
              Container(height: _isArrived ? 16 : 0,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.viewImageButtonTitle),
                onPressed: _isViewImageEnabled ? () => _handleViewImages() : null,
              ),
              Container(height: 8,),
              CommonButton(
                title: _mainActionButtonTitle,
                onPressed: _isEnabled ? () => _onMainActionButtonTapped(snapshot) : null,
              ),
              Container(height: 16,),
              MultipleLineText(
                controller: widget.reasonController,
                hint: AppLocalizations.of(context).translate(LocalizedKey.requestChangePlaceholderText),
                borderColor: _reasonBorderColor,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.requestChangeButtonTitle),
                onPressed: _isEnabled ? () => _onRequestChangeButtonTapped(snapshot) : null,
              ),
            ],
          ),
        );
      }
    );
  }
}

