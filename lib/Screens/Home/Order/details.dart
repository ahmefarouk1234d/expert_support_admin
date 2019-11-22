import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
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
   final String workflowStatus;
   OrderDetails({this.order, this.index, this.workflowStatus});
   
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
           child: OrderDetailsContent(order: order, workflowStatus: workflowStatus,),
         ),
       ),
     );
   }
 }

 class OrderDetailsContent extends StatefulWidget {
   final OrderInfo order;
   final String workflowStatus;
   OrderDetailsContent({this.order, this.workflowStatus});

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

    switch(widget.workflowStatus){
      case WorkflowStatus.pending: 
        widgets.add(PendingOrderActionButtons(order, cancelReasonController));
        break;
      case WorkflowStatus.requestChange: 
        if (order.changeRequestDetails != null){
          widgets.add(
            ReasonLabel(header: AppLocalizations.of(context).translate(LocalizedKey.requestChangeDetailsTitle), 
            reason: order.changeRequestDetails,),);
        }
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        widgets.add(PendingOrderActionButtons(order, cancelReasonController));
        break;
      case WorkflowStatus.inProcess:
      case WorkflowStatus.requestChangeReply:
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        widgets.add(InProcessActionButtons(order, changeDetailsControl));
        break;
      case WorkflowStatus.done: 
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        break;
      case WorkflowStatus.canceled: 
        if (order.cancelReason != null){
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context).translate(LocalizedKey.cancelReseanDetailsTitle), 
              reason: order.cancelReason,),);
        }
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
        }
        break;
      case WorkflowStatus.unknown:
        if (order.cancelReason != null){
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context).translate(LocalizedKey.cancelReseanDetailsTitle), 
              reason: order.cancelReason,),);
        } else if (order.changeRequestDetails != null){
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context).translate(LocalizedKey.requestChangeDetailsTitle), 
              reason: order.changeRequestDetails,),);
        }
        if (order.adminName != null && order.adminRole != null){
          widgets.add(OrderUpdatedByView(name: order.adminName, role: order.adminRole,),);
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
           Text(header + ": ", style: TextStyle(fontWeight: FontWeight.w700),),
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
     String adminRole = AdminRole().getDisplayRole(role: role, context: context);

     return Container(
       margin: EdgeInsets.only(top: 16),
       padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
         border: Border.all(color: Colors.black, width: 2),
       ),
       child: Column(
         children: <Widget>[
           Row(children: <Widget>[
             Expanded(child: 
             Text(
               AppLocalizations.of(context).translate(LocalizedKey.updateByTitle), 
               style: TextStyle(fontWeight: FontWeight.w700),)),],),
           Container(height: 8,),
           Row(
             children: <Widget>[
               Text(
                 AppLocalizations.of(context).translate(LocalizedKey.name)
                  + ": ", 
                style: TextStyle(fontWeight: FontWeight.w700),),
               Text(name)
             ],
           ),
           Container(height: 4,),
           Row(
             children: <Widget>[
               Text(
                 AppLocalizations.of(context).translate(LocalizedKey.role)
                  + ": ", 
                 style: TextStyle(fontWeight: FontWeight.w700),),
               Text(adminRole)
             ],
           )
         ],
       ),
     );
   }
 }