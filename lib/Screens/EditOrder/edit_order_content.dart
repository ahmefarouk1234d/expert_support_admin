import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Screens/EditOrder/editty_order_action_buttons.dart';
import 'package:expert_support_admin/Screens/EditOrder/service_list_to_edit.dart';
import 'package:flutter/material.dart';

class EditOrderContent extends StatefulWidget {
  final String orderDocID;
  final List<OrderService> services;
  EditOrderContent(this.services, this.orderDocID);

  @override
  _EditOrderContentState createState() => _EditOrderContentState();
}

class _EditOrderContentState extends State<EditOrderContent> {
  List<Widget> widgetList;
  FirebaseManager _firebaseManager;
  OrderBloc _editBloc;

  @override
  void initState() {
    _firebaseManager = FirebaseManager();
    super.initState();
  }

  _handleSaveChanges() async{
    try{
      Common.loading(context);
      await _firebaseManager.updateServices(widget.services, widget.orderDocID);
      //Navigator.of(context).pop();
      Common.dismiss(context);
    }
    catch (error){
      print("Updateing services error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    _editBloc = OrderProvider.of(context);
    return StreamBuilder<List<OrderService>>(
      stream: _editBloc.services,
      initialData: widget.services,
      builder: (context, snapshot) {
        widgetList = [
          ServiceListToEdit(services: snapshot.data), 
          EditOrderButtons(onSave: () => _handleSaveChanges(),)
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
      }
    );
  }
}