import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/EditOrder/edit_order.dart';
import 'package:expert_support_admin/Screens/OrderImages/order_images.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class OrderActionButtons extends StatefulWidget {
  final OrderInfo order;
  OrderActionButtons(this.order);

  @override
  _OrderActionButtonsState createState() => _OrderActionButtonsState();
}

class _OrderActionButtonsState extends State<OrderActionButtons> {
  FirebaseManager _firebaseManager = FirebaseManager();
  String _mainButtonActionTitle;
  bool _isEnabled;
  bool _isViewImageEnabled;
  OrderInfo _order;
  OrderBloc _orderBloc;

  @override
  void initState() {
    _order = widget.order;
    _mainButtonActionTitle = 
      _order.status == Status.inProcess 
      ? TextContent.doneButtonTitle 
      : TextContent.acceptButtonTitle;
    _isEnabled = _order.status == Status.pending || _order.status == Status.inProcess;
    _isViewImageEnabled = _order.imagesUrl.isNotEmpty;
    super.initState();
  }

  _handleMainAction() async{
    String status = "";
    Common.loading(context);
    if (_order.status == Status.pending){
      status = Status.inProcess;
    } else if (_order.status == Status.inProcess){
      status = Status.done;
    } else {
      print("invalid status for this stage, status: ${_order.status}");
      return;
    }

    await _firebaseManager.updateOrderStatus(_order.documentID, status);
    Common.dismiss(context);
    _order.status = status;
    _orderBloc.ordersChange.add(_order);
    setState(() {
      _mainButtonActionTitle = TextContent.doneButtonTitle;
      _isEnabled = status != Status.done;
    });
    print("main action button tapped");
  }

  _handleCancel() async{
    String status = Status.canceled;
    await _firebaseManager.updateOrderStatus(_order.documentID, status);
    _order.status = status;
    _orderBloc.ordersChange.add(_order);
    setState(() {
      _mainButtonActionTitle = TextContent.doneButtonTitle;
      _isEnabled = false;
    });
  }

  _handleViewImages() async{
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderImages(imageUrls: _order.imagesUrl,)));
  }

  _handleEdit(){
    _navigateToEditOrder();
  }

  _navigateToEditOrder(){
    List<OrderService> services = List();
    _order.orderService.forEach((serv) => services.add(OrderService()..update(serv)));

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
    EditOrder(orderDocID: _order.documentID, services: services,)));
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = OrderProvider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          CommonButton(
            title: TextContent.viewImageButtonTitle,
            onPressed: _isViewImageEnabled ? () => _handleViewImages() : null,
          ),
          Container(height: 8,),
          CommonButton(
            title: _mainButtonActionTitle,
            onPressed: _isEnabled ? () => _handleMainAction() : null,
          ),
          Container(height: 8,),
          CommonButton(
            title: TextContent.editButtonTitle,
            onPressed: _isEnabled ? () => _handleEdit() : null,
          ),
          Container(height: 8,),
          CommonButton(
            title: TextContent.cancelButtonTitle,
            onPressed: _isEnabled ? () => _handleCancel() : null,
          ),
        ],
      ),
    );
  }
}