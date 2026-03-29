import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:flutter/material.dart';

class ServiceRowToEdit extends StatefulWidget {
  final List<OrderService> services;
  final int index;
  const ServiceRowToEdit({super.key, required this.services, required this.index});

  @override
  _ServiceRowToEditState createState() => _ServiceRowToEditState();
}

class _ServiceRowToEditState extends State<ServiceRowToEdit> {
  late OrderService service;
  late List<int> _qaunityList;
  late TextEditingController priceController;

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
        service.total = service.priceForOnePiece! * service.quantity!;
      });
    } catch (e){
      print(e.toString());
    }
  }

  _handlePartsChange(bool? value){
    setState(() {
      service.neededParts = value ?? false;
    });
  }

  _updateQuantityAndPrice(num? value){
    int selectedQuantity = (value ?? 0).toInt();
    setState(() {
      service.quantity = selectedQuantity;
      service.total = service.priceForOnePiece! * selectedQuantity;
    });
  }

  _handleDeleteService(){
    // widget.services.removeAt(widget.index);
    // _orderBloc.servicesChange.add(widget.services);
    setState(() {
      service.isDeleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    String serviceName = isArabic ? service.nameAr ?? "" : service.nameEn ?? "";
    
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          service.isDeleted ? Container(color: Colors.red, child: Text("DELETED"),) : Container(),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            serviceName, 
                            style: TextStyle(fontSize: Screen.fontSize(size: 18))),),
                        Container(width: 8,),
                        Container(
                          height: Screen.screenWidth * 0.11,
                          width: Screen.screenWidth * 0.17,
                          //padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: TextField(
                            controller: priceController, 
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onChanged: _handlePriceChange,
                            enabled: !service.isDeleted,
                            decoration: InputDecoration.collapsed(
                              hintText: "0.0"
                            ),
                          ),
                        ),
                        //Text(service.total.toString())
                      ],
                    ),
                    service.isDeleted ? Container() 
                      : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: service.neededParts,
                                onChanged: _handlePartsChange
                              ),
                              Expanded(
                                child: Text(AppLocalizations.of(context).translate(LocalizedKey.neededPartsTitle))),
                              DropdownButton(
                                  value: service.quantity,
                                  onChanged: _updateQuantityAndPrice,
                                  items: _qaunityList
                                      .map((q) => DropdownMenuItem(
                                            value: q,
                                            child: Text("$q"),
                                          ))
                                      .toList())
                            ],
                          ),
                          Container(height: 8,),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(AppLocalizations.of(context).translate(LocalizedKey.totalPriceTitle)),),
                              Text(service.total.toString())
                            ],
                          )
                        ],
                      ),
                  ],
                ),
              ),
              Container(width: 8,),
              service.isDeleted ? Container()
                : SizedBox(
                  width: Screen.screenWidth * 0.1,
                  child: TextButton(
                    onPressed: _handleDeleteService,
                    child: Text("x"),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
