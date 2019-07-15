import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

import 'edit_order_content.dart';

class EditOrder extends StatelessWidget {
  final String orderDocID;
  final List<OrderService> services;
  EditOrder({this.orderDocID, this.services});

  final OrderBloc _editOrderBloc = OrderBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(TextContent.editOrderTitle),
      ),
      body: OrderBlocProvider(
        builder: (context, editOrderBloc) => _editOrderBloc,
        onDispose: (context, editOrderBloc) => _editOrderBloc.dispose(),
        child: Container(
          child: EditOrderContent(services, orderDocID),
        ),
      )
    );
  }
}
