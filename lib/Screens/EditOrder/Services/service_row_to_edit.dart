import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
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
  OrderBloc _orderBloc;
  TextEditingController priceController;

  @override
  void initState() {
    service = widget.services[widget.index];
    _qaunityList = List.generate(100, (i) => i);
    priceController = TextEditingController(text: service.priceForOnePiece.toString());
    super.initState();
  }

  _handlePriceChange(String value){
    try{
      service.priceForOnePiece = double.parse(value);
      setState(() {
        service.total = service.priceForOnePiece * service.quantity;
      });
    } catch (e){
      print(e.toString());
    }
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
    widget.services.removeAt(widget.index);
    _orderBloc.servicesChange.add(widget.services);
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = Provider.of<OrderBloc>(context);
    
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
                    Container(
                      height: Screen.screenWidth * 0.10,
                      width: Screen.screenWidth * 0.16,
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: TextField(
                        controller: priceController, 
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: _handlePriceChange,
                        decoration: InputDecoration.collapsed(
                          hintText: "0.0"
                        ),
                      ),
                    ),
                    //Text(service.total.toString())
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
                Container(height: 8,),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Total"),),
                    Text(service.total.toString())
                  ],
                )
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
