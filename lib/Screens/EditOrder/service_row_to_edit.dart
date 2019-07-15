import 'package:expert_support_admin/BlocResources/Order/order_bloc.dart';
import 'package:expert_support_admin/BlocResources/Order/order_provider.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

class ServiceRowToEdit extends StatefulWidget {
  final List<OrderService> services;
  final int index;
  ServiceRowToEdit({this.services, this.index});

  @override
  _ServiceRowToEditState createState() => _ServiceRowToEditState();
}

class _ServiceRowToEditState extends State<ServiceRowToEdit> {
  OrderService service;
  List<int> _qaunityList;
  OrderBloc _editBloc;

  @override
  void initState() {
    _qaunityList = List.generate(100, (i) => i);
    super.initState();
  }

  _handlePartsChange(bool value){
    setState(() {
      service.hasParts = value;
    });
  }

  _updateQuantityAndPrice(dynamic value){
    int selectedQuantity = value;
    setState(() {
      service.quantity = selectedQuantity;
      service.total = service.priceForOnePiece * selectedQuantity;
    });
  }

  _handleDeleteService(){
    print("deleted services is \"${widget.services[widget.index].nameEn}\"");
    widget.services.removeAt(widget.index);
    _editBloc.servicesChange.add(widget.services);
  }

  @override
  Widget build(BuildContext context) {
    _editBloc = OrderProvider.of(context);
    service = widget.services[widget.index];
    
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text(service.nameEn ?? ""),),
                    Text(service.total.toString())
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: service.hasParts,
                      onChanged: _handlePartsChange
                    ),
                    Expanded(child: Text("has parts")),
                    DropdownButton(
                        value: service.quantity,
                        onChanged: _updateQuantityAndPrice,
                        items: _qaunityList
                            .map((q) => DropdownMenuItem(
                                  child: Text("$q"),
                                  value: q,
                                ))
                            .toList())
                  ],
                ),
              ],
            ),
          ),
          Container(width: 8,),
          SizedBox(
            width: Screen.screenWidth * 0.1,
            child: FlatButton(
              child: Text("x"),
              onPressed: _handleDeleteService,
            ),
          )
        ],
      ),
    );
  }
}
