import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/admin_role.dart';
import 'package:flutter/material.dart';

class OrderUpdatedByView extends StatelessWidget {
  final String name;
  final String role;
  const OrderUpdatedByView({super.key, required this.name, required this.role});

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
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                AppLocalizations.of(context)
                    .translate(LocalizedKey.updateByTitle),
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
            ],
          ),
          Container(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Text(
                "${AppLocalizations.of(context).translate(LocalizedKey.name)}: ",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(name)
            ],
          ),
          Container(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Text(
                "${AppLocalizations.of(context).translate(LocalizedKey.role)}: ",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(adminRole)
            ],
          )
        ],
      ),
    );
  }
}