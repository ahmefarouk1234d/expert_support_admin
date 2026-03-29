import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class EditServicesButtons extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onAddNewService;
  final List<OrderService>? services;
  const EditServicesButtons({super.key, this.onSave, this.onAddNewService, this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          CommonButton(
            title: AppLocalizations.of(context).translate(LocalizedKey.editOrderAddNewServiceButtonTitle),
            onPressed: onAddNewService
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