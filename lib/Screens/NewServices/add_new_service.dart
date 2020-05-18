import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/order_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
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
        title: Text(AppLocalizations.of(context).translate(LocalizedKey.newServiceAppBarTitle)),
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
  List<ServiceCategory> serviceCategoryList;
  ServiceCategory serviceCategory;

  List<ServiceType> serviceTypeList;
  ServiceType serviceType;

  List<MainService> mainServiceList;
  MainService mainService;

  List<SubMainService> subMainServiceList;
  SubMainService subMainService;

  List<int> _qaunityList;
  int qty;
  bool valueSelected;
  bool isLoading;
  num totalPrice;
  num priceForOne;
  bool hasSubService;

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
    hasSubService = false;

    serviceCategoryList = List();
    _getServices();
    super.initState();
  }

  _getServices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseManager().getServices();
      if (querySnapshot.documents.length > 0) {
        setState(() {
          serviceCategoryList = ServiceCategory.fromListMap(docList: querySnapshot.documents);
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

  _resetPrice(){
    totalPrice = 0.0;
    qty = 0;
    priceForOne = 0.0;
  }

  _handleMainServiceCategoryChange(ServiceCategory value) {
    setState(() {
      serviceCategory = value;
      serviceCategoryList.forEach((servCat) {
        if (value.id == servCat.id) {
          serviceTypeList = servCat.serviceTypeList;
        }
      });
      serviceType = null;

      mainService = null;
      mainServiceList = null;

      subMainService = null;
      subMainServiceList = null;

      _resetPrice();
    });
  }

  _handleServiceTypeChange(ServiceType value) {
    setState(() {
      serviceType = value;
      serviceTypeList.forEach((servType) {
        if (value.id == servType.id) {
          mainServiceList = servType.mainServiceList;
        }
      });
      mainService = null;
      subMainService = null;
      subMainServiceList = null;

      _resetPrice();
    });
  }

  _handleMainServiceChange(MainService value) {
    setState(() {
      mainService = value;
      mainServiceList.forEach((servType) {
        if (value.id == servType.id) {
          subMainServiceList = servType.subMainServiceList;
        }
      });
      hasSubService = mainService.hasSub;
      subMainService = null;
      if (!mainService.hasSub){
        _updateTotal();
      } else {
        _resetPrice();
      }
    });
  }

  _handleSubMainServiceChange(SubMainService value){
    setState(() {
      subMainService = value;
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
    if (mainService != null){
      if (mainService.hasSub){
        if (subMainService != null){
          price = subMainService.price;
        }
      } else {
        price = mainService.price;
      }
    }
    priceForOne = price;
    totalPrice = price * qty;
  }

  _showConformatiomAlert(){
    final bool isValidSub = subMainService != null;
    final bool isValidMain = mainService != null;
    final bool isValid = hasSubService ? isValidSub : isValidMain;
    if (isValid && qty != 0.0){
      String message = AppLocalizations.of(context).translate(LocalizedKey.newServiceAddAlertMessage);
      Alert().conformation(
        context, AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, 
        () => _handleAddingNewService());
    }
  }

  _handleAddingNewService(){
    Common().loading(context);
    String nameAr;
    String nameEn;

    if (mainService.hasSub && subMainService != null) {
      nameAr = mainService.nameAr + " - " + subMainService.nameAr;
      nameEn = mainService.nameEn + " - " + subMainService.nameEn;
    } else {
      nameAr = mainService.nameAr;
      nameEn = mainService.nameEn;
    }

    addedService = OrderService(
      serviceCategoryId: serviceCategory.id,
      mainServiceId: mainService.id,
      subMainServiceId: subMainService == null ? "" : subMainService.id,
      isSubService: mainService.hasSub,
      nameAr: nameAr,
      nameEn: nameEn,
      priceForOnePiece: priceForOne,
      total: totalPrice,
      quantity: qty,
      neededParts: valueSelected
    );
    
    List<OrderService> orderServices = widget.services;
    orderServices.add(addedService);
    widget.orderBloc.servicesChange.add(orderServices);
    Navigator.of(context).pop();
    Common().dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = AppLocalizations.of(context).isArabic();
    if (isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (serviceCategoryList.isEmpty){
      return NoData();
    }
    return Container(
      padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButton(
              hint: Text(
                AppLocalizations.of(context).translate(LocalizedKey.newServiceDropDownServiceCategoryPlaceholderText)),
              value: serviceCategory,
              isExpanded: true,
              onChanged: _handleMainServiceCategoryChange,
              items: serviceCategoryList
                  .map((value) => DropdownMenuItem(
                        child: Text(isArabic ? value.nameAr : value.nameEn),
                        value: value,
                      ))
                  .toList(),
            ),
            Container(
              height: 16,
            ),
            DropdownButton(
              hint: Text(
                AppLocalizations.of(context).translate(LocalizedKey.newServiceDropDownServiceTypePlaceholderText)),
              value: serviceType,
              isExpanded: true,
              onChanged: _handleServiceTypeChange,
              items: serviceTypeList== null || serviceTypeList.isEmpty
                  ? null
                  : serviceTypeList
                      .map((value) => DropdownMenuItem(
                            child: Text(isArabic ? value.nameAr : value.nameEn),
                            value: value,
                          ))
                      .toList(),
            ),
            Container(
              height: 16,
            ),
            DropdownButton(
              hint: Text(
                AppLocalizations.of(context).translate(LocalizedKey.newServiceDropDownMainServicePlaceholderText)),
              value: mainService,
              isExpanded: true,
              onChanged: _handleMainServiceChange,
              items: mainServiceList == null ||
                      mainServiceList.isEmpty
                  ? null
                  : mainServiceList
                      .map((value) => DropdownMenuItem(
                            child: Text(isArabic ? value.nameAr : value.nameEn),
                            value: value,
                          ))
                      .toList(),
            ),
            Container(
              height: 16,
            ),
            DropdownButton(
              hint: Text(
                AppLocalizations.of(context).translate(LocalizedKey.newServiceDropDownSubMainServicePlaceholderText)),
              value: subMainService,
              isExpanded: true,
              onChanged: _handleSubMainServiceChange,
              items: subMainServiceList == null ||
                      subMainServiceList.isEmpty
                  ? null
                  : subMainServiceList
                      .map((value) => DropdownMenuItem(
                            child: Text(isArabic ? value.nameAr : value.nameEn),
                            value: value,
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
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).translate(LocalizedKey.neededPartsTitle))),
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
                  child: Text(
                    AppLocalizations.of(context).translate(LocalizedKey.newServicePriceForOne), 
                    style: TextStyle(fontWeight: FontWeight.w700),),
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
                  child: Text(
                    AppLocalizations.of(context).translate(LocalizedKey.totalPriceTitle), 
                    style: TextStyle(fontWeight: FontWeight.w700),),
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
              title: AppLocalizations.of(context).translate(LocalizedKey.newSerivceAddServiceButtonTitle),
              onPressed: () => _showConformatiomAlert(),
            ),
          ],
        ),
    );
  }
}
