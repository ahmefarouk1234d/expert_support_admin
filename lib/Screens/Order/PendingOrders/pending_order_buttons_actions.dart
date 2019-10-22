import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/EditOrder/Services/edit_services.dart';
import 'package:expert_support_admin/Screens/EditOrder/TimeAndDate/edit_time_date.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_images.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/multiple_text.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

class PendingOrderActionButtons extends StatefulWidget {
  final OrderInfo order;
  final TextEditingController controller;
  PendingOrderActionButtons(this.order, this.controller);

  @override
  _PendingOrderActionButtonsState createState() => _PendingOrderActionButtonsState();
}

class _PendingOrderActionButtonsState extends State<PendingOrderActionButtons> {
  FirebaseManager _firebaseManager = FirebaseManager();
  bool _isEnabled;
  bool _isViewImageEnabled;
  OrderInfo _order;
  OrderBloc _orderBloc;
  AppBloc _appBloc;
  Color _borderColor;

  @override
  void initState() {
    //_setUp();
    super.initState();
  }

  _setUp(){
    _order = widget.order;
    _isEnabled = _order.status == OrderStatus.pending || _order.status == OrderStatus.requestChange;
    _isViewImageEnabled = _order.imagesUrl.isNotEmpty;
    _borderColor = Colors.black;
  }

  _showConformatiomAlert(String status, String message, AdminUserInfo admin){
    Alert().conformation(context, 
      AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), 
      message, () => _handleStatusChange(status, admin));
  }

  _handleStatusChange(String status, AdminUserInfo admin) async{
    setState(() =>_borderColor = Colors.black);
    Common().loading(context);
    String cancelReason = widget.controller.text.isNotEmpty ? widget.controller.text : null;
    await _firebaseManager.updateOrderStatus(_order.documentID, status, admin, 
      cancelReason: cancelReason);
    Common().dismiss(context);
    _order.status = status;
    _orderBloc.ordersChange.add(_order);
    setState(() {
      _isEnabled = false;
    });
  }

  _navigateToViewImage(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderImages(imageUrls: _order.imagesUrl,)));
  }

  _navigateToEditOrder(AdminUserInfo admin){
    List<OrderService> services = List();
    _order.orderService.forEach((serv) => services.add(OrderService()..update(serv)));
    OrderInfo orderToEdit = OrderInfo()..update(_order);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditServices(
          orderDocID: _order.documentID, 
          services: services, 
          order: orderToEdit, 
          orderBloc: _orderBloc,
        )
      )
    );
  }

  _navigateToEditTimeDate(AdminUserInfo admin){
    OrderInfo orderToEdit = OrderInfo()..update(_order);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTimeDate(
          order: orderToEdit,
          orderBloc: _orderBloc,
          orderDocID: _order.documentID,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = Provider.of<OrderBloc>(context);
    _appBloc = Provider.of<AppBloc>(context);
    _setUp();
    return StreamBuilder<AdminUserInfo>(
      stream: _appBloc.admin,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: <Widget>[
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.viewImageButtonTitle),
                onPressed: _isViewImageEnabled ? () => _navigateToViewImage() : null,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.editServButtonTitle),
                onPressed: _isEnabled ? () {
                  if (snapshot.hasData){
                    _navigateToEditOrder(snapshot.data);
                  }
                }
                : null,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.editTimeAndDateButtonTitle),
                onPressed: _isEnabled ? () {
                  if (snapshot.hasData){
                    _navigateToEditTimeDate(snapshot.data);
                  }
                }
                : null,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.acceptButtonTitle),
                onPressed: _isEnabled ? () {
                  if (snapshot.hasData){
                    _showConformatiomAlert(
                      OrderStatus.inProcess, 
                      AppLocalizations.of(context).translate(LocalizedKey.acceptAlertMessage), 
                      snapshot.data);
                  }
                }
                : null,
              ),
              Container(height: 16,),
              MultipleLineText(
                hint: AppLocalizations.of(context).translate(LocalizedKey.cnacelReasonPlaceholderText),
                borderColor: _borderColor,
                controller: widget.controller,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.cancelButtonTitle),
                onPressed: 
                _isEnabled 
                ? () {
                  if (widget.controller.text.isEmpty){
                    setState(() {
                      _borderColor = Colors.red;
                    });
                  } else {
                    setState(() {
                      _borderColor = Colors.black;
                    });
                    if (snapshot.hasData){
                      _showConformatiomAlert(
                        OrderStatus.canceled, 
                        AppLocalizations.of(context).translate(LocalizedKey.cancelAlertMessage), 
                        snapshot.data);
                    }
                  }
                }
                : null,
              ),
            ],
          ),
        );
      }
    );
  }
}