import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/newServices/add_new_service.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class EditServicesButtons extends StatelessWidget {
  final VoidCallback onSave;
  final List<OrderService> services;
  EditServicesButtons({this.onSave, this.services});

  _handleAddService(BuildContext context, OrderBloc bloc){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNewService(orderBloc: bloc, services: services,)));
  }

  @override
  Widget build(BuildContext context) {
    OrderBloc _orderBloc = Provider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          CommonButton(
            title: AppLocalizations.of(context).translate(LocalizedKey.editOrderAddNewServiceButtonTitle),
            onPressed: () => _handleAddService(context, _orderBloc),
          ),
          Container(height: 8,),
          CommonButton(
            title: AppLocalizations.of(context).translate(LocalizedKey.editOrderSaveButtonTitle),
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}