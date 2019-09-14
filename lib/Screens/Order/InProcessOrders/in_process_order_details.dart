import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_main_info.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_prices.dart';
import 'package:expert_support_admin/Screens/Order/Common/service_list.dart';
import 'package:flutter/material.dart';

import 'in_process_order_button_actions.dart';

class InProcessOrderDetails extends StatelessWidget {
  static String route = "/PendingOrderDetails";
   final int index;
   final OrderInfo order;
   InProcessOrderDetails({this.order, this.index});
   
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
           child: InProcessOrderDetailsContent(order: order,),
         ),
       ),
     );
   }
}

class InProcessOrderDetailsContent extends StatefulWidget {
  final OrderInfo order;
  InProcessOrderDetailsContent({this.order});

  @override
  _InProcessOrderDetailsContentState createState() => _InProcessOrderDetailsContentState();
}

class _InProcessOrderDetailsContentState extends State<InProcessOrderDetailsContent> {
  List<Widget> widgetList;
  OrderInfo _order;
  OrderBloc _orderBloc;
  TextEditingController changeDetailsControl = TextEditingController();

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
          InProcessActionButtons(snapshot.data, changeDetailsControl)];

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