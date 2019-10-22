
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
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/multiple_text.dart';
import 'package:flutter/material.dart';

class InProcessActionButtons extends StatefulWidget {
  final OrderInfo order;
  final TextEditingController controller;
  InProcessActionButtons(this.order, this.controller);

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
  Color _borderColor;

  @override
  void initState() {
    _setUp();
    super.initState();
  }

  _setUp(){
    _order = widget.order;
    _isEnabled = _order.status == OrderStatus.inProcess;
    _isViewImageEnabled = _order.imagesUrl.isNotEmpty;
    _borderColor = Colors.black;
  }

  _showConformatiomAlert({@required String status, @required String message, @required AdminUserInfo admin}){
    Alert().conformation(
      context, AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, 
      () => _handleAction(status: status, admin: admin));
  }

  _handleViewImages() async{
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderImages(imageUrls: _order.imagesUrl,)));
  }

  _handleAction({@required String status, @required AdminUserInfo admin}) async{
    setState(() =>_borderColor = Colors.black);
    Common().loading(context);
    String changeRequestDeatils = widget.controller.text.isNotEmpty ? widget.controller.text : null;
    await _firebaseManager.updateOrderStatus(_order.documentID, status, admin, changeRequestDetails: changeRequestDeatils);
    Common().dismiss(context);
    _order.status = status;
    _orderBloc.ordersChange.add(_order);
    setState(() {
      _isEnabled = false;
    });
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
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.viewImageButtonTitle),
                onPressed: _isViewImageEnabled ? () => _handleViewImages() : null,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.doneButtonTitle),
                onPressed: _isEnabled ? () {
                  if (snapshot.hasData){
                    _showConformatiomAlert(
                      status: OrderStatus.done, 
                      message: AppLocalizations.of(context).translate(LocalizedKey.doneAlertMessage), 
                      admin: snapshot.data);
                  }
                }
                : null,
              ),
              Container(height: 16,),
              MultipleLineText(
                controller: widget.controller,
                hint: AppLocalizations.of(context).translate(LocalizedKey.requestChangePlaceholderText),
                borderColor: _borderColor,
              ),
              Container(height: 8,),
              CommonButton(
                title: AppLocalizations.of(context).translate(LocalizedKey.requestChangeButtonTitle),
                onPressed: 
                _isEnabled 
                ? () {
                  if (widget.controller.text.isEmpty){
                    setState(() {
                      _borderColor = Colors.red;
                    });
                  } else {
                    if (snapshot.hasData){
                      _showConformatiomAlert(
                        status: OrderStatus.requestChange, 
                        message: AppLocalizations.of(context).translate(LocalizedKey.requestChangeAlertMessage), 
                        admin: snapshot.data);
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