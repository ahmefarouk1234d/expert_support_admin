import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_main_info.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_prices.dart';
import 'package:expert_support_admin/Screens/Order/Common/service_list.dart';
import 'package:expert_support_admin/Screens/Order/InProcessOrders/in_process_order_button_actions.dart';
import 'package:expert_support_admin/Screens/Order/PendingOrders/pending_order_buttons_actions.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';

 class OrderDetails extends StatelessWidget {
   static String route = "/OrderDetails";
   final int index;
   final OrderInfo order;
   final String orderStatus;
   OrderDetails({this.order, this.index, this.orderStatus});
   
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text(order.id),
         elevation: 0.0,
       ),
       body: BlocProvider<OrderBloc>(
         builder: (context, _orderBloc) => _orderBloc ?? OrderBloc(),
         onDispose: (context, _orderBloc) => _orderBloc.dispose(),
         child: Container(
           child: OrderDetailsContent(order: order, orderStatus: orderStatus,),
         ),
       ),
     );
   }
 }

 class OrderDetailsContent extends StatefulWidget {
   final OrderInfo order;
   final String orderStatus;
   OrderDetailsContent({this.order, this.orderStatus});

   @override
   _OrderDetailsContentState createState() => _OrderDetailsContentState();
 }
 
 class _OrderDetailsContentState extends State<OrderDetailsContent> {
   List<Widget> widgetList;
   OrderInfo _order;
   OrderBloc _orderBloc;
   TextEditingController cancelReasonController = TextEditingController();
   TextEditingController changeDetailsControl = TextEditingController();

   @override
  void initState() {
    _order = widget.order;
    super.initState();
  }

  List<Widget> _getList(OrderInfo order){
    List<Widget> widgets = [
      OrderMainInfo(order),
      ServicesList(order), 
      OrderPrices(order), 
    ];

    switch(widget.orderStatus){
      case OrderStatus.pending: 
        widgets.add(PendingOrderActionButtons(order, cancelReasonController));
        break;
      case OrderStatus.requestChange: 
        if (order.changeRequestDetails != null){
          widgets.add(ReasonLabel(header: "Change Details", reason: order.changeRequestDetails,),);
        }
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        widgets.add(PendingOrderActionButtons(order, cancelReasonController));
        break;
      case OrderStatus.inProcess:
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        widgets.add(InProcessActionButtons(order, changeDetailsControl));
        break;
      case OrderStatus.done: 
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        break;
      case OrderStatus.canceled: 
        if (order.cancelReason != null){
          widgets.add(ReasonLabel(header: "Cancel Reason", reason: order.cancelReason,),);
        }
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        break;
      case OrderStatus.unknown:
        if (order.cancelReason != null){
          widgets.add(ReasonLabel(header: "Cancel Reason", reason: order.cancelReason,),);
        } else if (order.changeRequestDetails != null){
          widgets.add(ReasonLabel(header: "Change Details", reason: order.changeRequestDetails,),);
        }
    }
    return widgets;
  }

   @override
   Widget build(BuildContext context) {
    _orderBloc = Provider.of<OrderBloc>(context);
    return StreamBuilder<OrderInfo>(
      stream: _orderBloc.order,
      initialData: _order,
      builder: (context, snapshot) {
        widgetList = _getList(snapshot.data);
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: widgetList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[widgetList[index]],
            );
          },
        );
      }
    );
   }
 }

 class ReasonLabel extends StatelessWidget {
   final String header;
   final String reason;
   ReasonLabel({this.header, this.reason});

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: EdgeInsets.only(top: 16),
       padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.black, width: 2),
       ),
       child: Row(
         children: <Widget>[
           Text(header + ": "),
           Expanded(
             child: Text(reason),
           ),
         ],
       ),
     );
   }
 }

 class OrderUpdatedByView extends StatelessWidget {
   final String name;
   final String role;
   OrderUpdatedByView({this.name, this.role});

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: EdgeInsets.only(top: 16),
       padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.black, width: 2),
       ),
       child: Column(
         children: <Widget>[
           Row(children: <Widget>[Expanded(child: Text("Update By:")),],),
           Row(
             children: <Widget>[
               Text("Name: "),
               Text(name)
             ],
           ),
           Row(
             children: <Widget>[
               Text("Role: "),
               Text(role)
             ],
           )
         ],
       ),
     );
   }
 }