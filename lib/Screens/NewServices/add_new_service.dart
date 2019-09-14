import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/Models/order_model.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class Serv {
  String mainServ;
  List<SubServ> subServices;

  Serv({this.mainServ, this.subServices});
}

class SubServ {
  String subServ;
  List<String> subSubServices;

  SubServ({this.subServ, this.subSubServices});
}

class AddNewService extends StatelessWidget {
  final OrderBloc orderBloc;
  final List<OrderService> services;
  const AddNewService({Key key, this.orderBloc, this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Service"),
        elevation: 0.0,
      ),
      body: AddNewServiceContent(orderBloc: orderBloc, services: services,),
    );
  }
}

class AddNewServiceContent extends StatefulWidget {
  final OrderBloc orderBloc;
  final List<OrderService> services;
  const AddNewServiceContent({Key key, this.orderBloc, this.services}) : super(key: key);

  @override
  _AddNewServiceContentState createState() => _AddNewServiceContentState();
}

class _AddNewServiceContentState extends State<AddNewServiceContent> {
  List<Service> servicesList;
  Service service;

  List<SubService> subServicesList;
  SubService subService;

  List<SubSubService> subSubServicesList;
  SubSubService subSubService;

  List<int> _qaunityList;
  int qty;
  bool valueSelected;
  bool isLoading;
  num totalPrice;
  num priceForOne;

  OrderService addedService;

  @override
  void initState() {
    _qaunityList = List.generate(100, (i) => i);
    valueSelected = false;
    isLoading = true;
    totalPrice = 0.0;
    qty = 0;
    priceForOne = 0.0;
    addedService = OrderService();

    servicesList = List();
    _getServices();
    super.initState();
  }

  _getServices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseManager().getServices();
      if (querySnapshot.documents.length > 0) {
        setState(() {
          servicesList = Service.fromListMap(docList: querySnapshot.documents);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  _handleMainServiceChange(Service value) {
    setState(() {
      service = value;
      servicesList.forEach((serv) {
        if (value.docID == serv.docID) {
          subServicesList = serv.subServices;
        }
      });
      subService = null;
      subSubServicesList = null;
    });
  }

  _handleSubServiceChange(SubService value) {
    setState(() {
      subService = value;
      subServicesList.forEach((sub) {
        if (value.nameEn == sub.nameEn) {
          subSubServicesList = sub.subSubServices;
        }
      });
      subSubService = null;
    });
  }

  _handleSubSubServiceChange(SubSubService value) {
    setState(() {
      subSubService = value;
      _updateTotal();
    });
  }

  _handleQauntityChange(int value) {
    setState(() {
      qty = value;
      _updateTotal();
    });
  }

  _updateTotal(){
    num price = 0.0;
    if (subSubService != null){
      subSubService.servicePrice.forEach((p){
        if (p.rangeFrom <= qty && p.rangeTo >= qty){
          price = p.value;
        }
      });
    }
    priceForOne = price;
    totalPrice = price * qty;
  }

  _showConformatiomAlert(){
    if (
      service != null &&
      subService != null &&
      subSubService != null &&
      qty != 0.0
    ){
      String message = "Are are sure you want to add new service";
      Alert().conformation(
        context, "Conformation", message, 
        () => _handleAddingNewService());
    }
  }

  _handleAddingNewService(){
    Common().loading(context);
    addedService = OrderService(
      id: service.docID,
      nameAr: subSubService.nameAr,
      nameEn: subSubService.nameEn,
      priceForOnePiece: priceForOne,
      total: totalPrice,
      quantity: qty,
      hasParts: valueSelected
    );
    List<OrderService> orderServices = widget.services;
    orderServices.add(addedService);
    widget.orderBloc.servicesChange.add(orderServices);
    Navigator.of(context).pop();
    Common().dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (servicesList.isEmpty){
      return NoData();
    }
    return Container(
      padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButton(
              hint: Text("Select service"),
              value: service,
              isExpanded: true,
              onChanged: _handleMainServiceChange,
              items: servicesList
                  .map((serv) => DropdownMenuItem(
                        child: Text(serv.nameEn),
                        value: serv,
                      ))
                  .toList(),
            ),
            Container(
              height: 16,
            ),
            DropdownButton(
              hint: Text("Select sub service"),
              value: subService,
              isExpanded: true,
              onChanged: _handleSubServiceChange,
              items: subServicesList == null || subServicesList.isEmpty
                  ? null
                  : subServicesList
                      .map((subServ) => DropdownMenuItem(
                            child: Text(subServ.nameEn),
                            value: subServ,
                          ))
                      .toList(),
            ),
            Container(
              height: 16,
            ),
            DropdownButton(
              hint: Text("Select sub sub service"),
              value: subSubService,
              isExpanded: true,
              onChanged: _handleSubSubServiceChange,
              items: subSubServicesList == null ||
                      subSubServicesList.isEmpty
                  ? null
                  : subSubServicesList
                      .map((subSubServ) => DropdownMenuItem(
                            child: Text(subSubServ.nameEn),
                            value: subSubServ,
                          ))
                      .toList(),
            ),
            Container(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                    value: valueSelected,
                    onChanged: (value) {
                      setState(() {
                        valueSelected = value;
                      });
                    }),
                Expanded(child: Text("has parts")),
                DropdownButton(
                    value: qty,
                    hint: Text("0"),
                    onChanged: _handleQauntityChange,
                    items: _qaunityList
                        .map((q) => DropdownMenuItem(
                              child: Text("$q"),
                              value: q,
                            ))
                        .toList())
              ],
            ),
            Container(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Price for one"),
                ),
                Text(priceForOne.toString())
              ],
            ),
            Container(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Total price"),
                ),
                Text(totalPrice.toString())
              ],
            ),
            Container(
              height: 16,
            ),
            Container(
              height: 16,
            ),
            CommonButton(
              title: "ADD SERVICE",
              onPressed: () => _showConformatiomAlert(),
            ),
          ],
        ),
    );
  }
}
