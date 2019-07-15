import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class EditOrderButtons extends StatelessWidget {
  final VoidCallback onSave;
  EditOrderButtons({this.onSave});

  _handleAddService(){
    print("Add button tapped");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          CommonButton(
            title: TextContent.addServiceButtonTitle,
            onPressed: () => _handleAddService(),
          ),
          Container(height: 8,),
          CommonButton(
            title: TextContent.saveChangeButtonTitle,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}