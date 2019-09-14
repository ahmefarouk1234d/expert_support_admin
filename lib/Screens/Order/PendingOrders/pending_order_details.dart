import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_main_info.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_prices.dart';
import 'package:expert_support_admin/Screens/Order/Common/service_list.dart';
import 'package:flutter/material.dart';

import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'pending_order_buttons_actions.dart';

 class PendingOrderDetails extends StatelessWidget {
   static String route = "/PendingOrderDetails";
   final int index;
   final OrderInfo order;
   PendingOrderDetails({this.order, this.index});
   
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
           child: PendingOrderDetailsContent(order: order,),
         ),
       ),
     );
   }
 }

 class PendingOrderDetailsContent extends StatefulWidget {
   final OrderInfo order;
   PendingOrderDetailsContent({this.order});

   @override
   _PendingOrderDetailsContentState createState() => _PendingOrderDetailsContentState();
 }
 
 class _PendingOrderDetailsContentState extends State<PendingOrderDetailsContent> {
   List<Widget> widgetList;
   OrderInfo _order;
   OrderBloc _orderBloc;
   TextEditingController cancelReasonController = TextEditingController();

   @override
  void initState() {
    _order = widget.order;
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     _orderBloc = Provider.of<OrderBloc>(context);

    return StreamBuilder<OrderInfo>(
      stream: _orderBloc.order,
      initialData: _order,
      builder: (context, snapshot) {
        widgetList = [
          OrderMainInfo(snapshot.data),
          ServicesList(snapshot.data), 
          OrderPrices(snapshot.data), 
          CancelReason(reason: "csdgvfdg sgdfg dfgdf fgdlkfjglksghljkrsg jkewhgjrw sgkuwfhew veukwbg",),
          PendingOrderActionButtons(snapshot.data, cancelReasonController)];

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

 class CancelReason extends StatelessWidget {
   final String reason;
   CancelReason({this.reason});

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
           Text("Change Details:"),
           Expanded(
             child: Text(reason),
           ),
         ],
       ),
     );
   }
 }