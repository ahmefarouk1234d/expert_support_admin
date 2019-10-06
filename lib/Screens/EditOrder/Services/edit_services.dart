import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';
import 'edit_services_content.dart';

class EditServices extends StatelessWidget {
  final AdminUserInfo admin;
  final String orderDocID;
  final List<OrderService> services;
  final OrderInfo order;
  final OrderBloc orderBloc;
  EditServices({this.orderDocID, this.services, this.order, this.orderBloc, this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(TextContent.editOrderTitle),
      ),
      body: BlocProvider<OrderBloc>(
        builder: (context, orderBloc) => orderBloc ?? OrderBloc(),
        onDispose: (context, orderBloc) => orderBloc.dispose(),
        child: Container(
          child: EditServicesContent(services, orderDocID, order, orderBloc, admin),
        ),
      )
    );
  }
}
