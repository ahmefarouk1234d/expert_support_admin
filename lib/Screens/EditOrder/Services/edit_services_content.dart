import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_model.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/EditOrder/Services/editty_services_action_buttons.dart';
import 'package:expert_support_admin/Screens/EditOrder/Services/service_list_to_edit.dart';
import 'package:expert_support_admin/Screens/NewServices/add_new_service.dart';
import 'package:flutter/material.dart';

class EditServicesContent extends StatefulWidget {
  final AdminUserInfo admin;
  final String orderDocID;
  final List<OrderService> services;
  final OrderInfo order;
  final OrderBloc orderBloc;
  EditServicesContent(
      this.services, this.orderDocID, this.order, this.orderBloc, this.admin);

  @override
  _EditServicesContentState createState() => _EditServicesContentState();
}

class _EditServicesContentState extends State<EditServicesContent> {
  List<Widget> widgetList;
  FirebaseManager _firebaseManager;
  OrderBloc _orderBloc;
  OrderBloc _currentOrderBloc;
  List<OrderService> _services;
  OrderInfo _orderInfo;

  @override
  void initState() {
    _firebaseManager = FirebaseManager();
    _orderInfo = widget.order;
    _services = _orderInfo.orderService;
    _orderBloc = widget.orderBloc;
    super.initState();
  }

  _handleAddService() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddNewService(
              orderBloc: _currentOrderBloc,
              services: _services,
            )));
  }

  _showConformatiomAlert() {
    if (_services != null && _services.length > 0) {
      List<OrderService> noDeletedServices =
          _services.where((element) => element.isDeleted == false).toList();
      if (noDeletedServices.length == 0) {
        Alert().warning(
            context,
            AppLocalizations.of(context)
                .translate(LocalizedKey.allServicesDeletedAlertMessage), () {
          Common().dismiss(context);
        });
      } else {
        Alert().conformation(
            context,
            AppLocalizations.of(context)
                .translate(LocalizedKey.conformationAlertTitle),
            AppLocalizations.of(context)
                .translate(LocalizedKey.editOrderSaveAlertMessage), () {
          _handleSaveChanges();
        });
      }
    } else {
      Alert().warning(
          context,
          AppLocalizations.of(context)
              .translate(LocalizedKey.noServiceFoundAlertMessage), () {
        Common().dismiss(context);
      });
    }
  }

  _handleSaveChanges() async {
    try {
      Common().loading(context);
      await _handleServicePriceChanges();
      await _firebaseManager.updateServices(_orderInfo, widget.orderDocID);
      _orderBloc.ordersChange.add(_orderInfo);
      Common().dismiss(context);
      Navigator.of(context).pop();
    } catch (error) {
      print("Updateing services error: $error");
    }
  }

  _handleServicePriceChanges() async {
    double _total = 0.0;
    double _vatTotal = 0.0;
    double _totalPriceAfterVAT = 0.0;
    double _discountPrecent = 0.0;
    double _totalDiscount = 0.0;
    double _totalPriceAfterDiscount = 0.0;
    List<OrderService> _updatedServices = List();

    //SubmitOrder submitOrder = await _firebaseManager.getSubmittedOrderGeneralDetails();
    //submitOrder.vatPercentage / 100;
    double vatPercentage = _orderInfo.vatPercentage != null
        ? (_orderInfo.vatPercentage / 100)
        : 0.05;

    _services.forEach((serv) {
      if (!serv.isDeleted) {
        _total += serv.total;
        _updatedServices.add(serv);
      }
    });

    _orderInfo.orderService = _updatedServices;

    _discountPrecent = (_orderInfo.discountPercent / 100);
    _totalDiscount = (_total * _discountPrecent);
    _totalPriceAfterDiscount = (_total - _totalDiscount);
    _vatTotal = (_totalPriceAfterDiscount * vatPercentage);
    _totalPriceAfterVAT = (_totalPriceAfterDiscount + _vatTotal);

    _orderInfo.discountPercent = _discountPrecent;
    _orderInfo.totalDiscountAmount = _totalDiscount;
    _orderInfo.totalPriceBeforeDiscount = _total;
    _orderInfo.totalPriceAfterDiscount = _totalPriceAfterDiscount;
    _orderInfo.vatTotal = _vatTotal;
    _orderInfo.totalPriceWithVAT = _totalPriceAfterVAT;
  }

  @override
  Widget build(BuildContext context) {
    _currentOrderBloc = Provider.of<OrderBloc>(context);
    return StreamBuilder<List<OrderService>>(
        stream: _currentOrderBloc.services,
        initialData: _services,
        builder: (context, snapshot) {
          widgetList = [
            ServiceListToEdit(
              services: snapshot.data,
            ),
            EditServicesButtons(
              onSave: () => _showConformatiomAlert(),
              onAddNewService: () => _handleAddService(),
              services: snapshot.data,
            )
          ];
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
