import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_main_info.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_prices.dart';
import 'package:expert_support_admin/Screens/Order/Common/order_update_by_view.dart';
import 'package:expert_support_admin/Screens/Order/Common/reason_label.dart';
import 'package:expert_support_admin/Screens/Order/Common/service_list.dart';
import 'package:expert_support_admin/Screens/Order/InProcessOrders/in_process_order_button_actions.dart';
import 'package:expert_support_admin/Screens/Order/PendingOrders/pending_order_buttons_actions.dart';
import 'package:flutter/material.dart';

class OrderDetailsContent extends StatefulWidget {
  final OrderInfo order;
  final OrderToDisplay orderToDisplay;
  OrderDetailsContent({this.order, this.orderToDisplay});

  @override
  _OrderDetailsContentState createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  List<Widget> widgetList;
  OrderInfo _order;
  OrderBloc _orderBloc;
  TextEditingController cancelReasonController = TextEditingController();
  TextEditingController changeDetailsControl = TextEditingController();
  TextEditingController totalMoneyReceivedController = TextEditingController();
  TextEditingController totalPartsPriceController = TextEditingController();
  TextEditingController partsFeesController = TextEditingController();

  @override
  void initState() {
    _order = widget.order;
    super.initState();
  }

  List<Widget> _getList(OrderInfo order) {
    List<Widget> widgets = [
      OrderMainInfo(order),
      ServicesList(order),
      OrderPrices(order),
    ];

    switch (widget.orderToDisplay) {
      case OrderToDisplay.pending:
        if (order.changeRequestDetails != null) {
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context)
                  .translate(LocalizedKey.requestChangeDetailsTitle),
              reason: order.changeRequestDetails,
            ),
          );
        }
        if (order.adminName != null && order.adminRole != null) {
          widgets.add(
            OrderUpdatedByView(
              name: order.adminName,
              role: order.adminRole,
            ),
          );
        }
        widgets.add(PendingOrderActionButtons(order, cancelReasonController));
        break;
      case OrderToDisplay.inProcess:
        if (order.adminName != null && order.adminRole != null) {
          widgets.add(
            OrderUpdatedByView(
              name: order.adminName,
              role: order.adminRole,
            ),
          );
        }
        widgets.add(InProcessActionButtons(
            order,
            changeDetailsControl,
            totalMoneyReceivedController,
            totalPartsPriceController,
            partsFeesController));
        break;
      case OrderToDisplay.done:
        //widgets.add(ExtraPriceInfo(order: order,));
        if (order.adminName != null && order.adminRole != null) {
          widgets.add(
            OrderUpdatedByView(
              name: order.adminName,
              role: order.adminRole,
            ),
          );
        }
        break;
      case OrderToDisplay.canceled:
        if (order.cancelReason != null) {
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context)
                  .translate(LocalizedKey.cancelReseanDetailsTitle),
              reason: order.cancelReason,
            ),
          );
        }
        if (order.adminName != null && order.adminRole != null) {
          widgets.add(
            OrderUpdatedByView(
              name: order.adminName,
              role: order.adminRole,
            ),
          );
        }
        break;
      case OrderToDisplay.all:
        //widgets.add(ExtraPriceInfo(order: order,));
        if (order.cancelReason != null) {
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context)
                  .translate(LocalizedKey.cancelReseanDetailsTitle),
              reason: order.cancelReason,
            ),
          );
        } else if (order.changeRequestDetails != null) {
          widgets.add(
            ReasonLabel(
              header: AppLocalizations.of(context)
                  .translate(LocalizedKey.requestChangeDetailsTitle),
              reason: order.changeRequestDetails,
            ),
          );
        }
        if (order.adminName != null && order.adminRole != null) {
          widgets.add(
            OrderUpdatedByView(
              name: order.adminName,
              role: order.adminRole,
            ),
          );
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
        });
  }
}