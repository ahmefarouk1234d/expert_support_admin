import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_offer_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddOrderOffer extends StatelessWidget {
  static String route = "/addOrderOffer";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderOfferBloc>(
      builder: (context, offerBloc) => offerBloc ?? OrderOfferBloc(),
      onDispose: (context, offerBloc) => offerBloc.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate(LocalizedKey.addOfferAppBarTitle)),
            elevation: 0.0,
          ),
          body: AddOrderOfferContent()),
    );
  }
}

class AddOrderOfferContent extends StatefulWidget {
  @override
  _AddOrderOfferContentState createState() => _AddOrderOfferContentState();
}

class _AddOrderOfferContentState extends State<AddOrderOfferContent> {
  final TextEditingController titleArController = TextEditingController();
  final TextEditingController titleEnController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController descEnController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<Service> servicesList;
  Service service;

  List<SubService> subServicesList;
  SubService subService;

  List<SubSubService> subSubServicesList;
  SubSubService subSubService;

  bool isLoading;
  OrderOfferBloc _orderOfferBloc;

  @override
  void initState() {
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
      subServicesList.forEach((sub) {
        if (value.nameEn == sub.nameEn) {
          subSubServicesList = sub.subSubServices;
        }
      });
      subSubService = null;
    });
  }

  _showConformatiomAlert() {
    String message = AppLocalizations.of(context).translate(LocalizedKey.addOfferAlertMessage);
    Alert().conformation(
        context, AppLocalizations.of(context).translate(LocalizedKey.conformationAlertTitle), message, () => _handleAddingNewOffer());
  }

  _navigateToOfferList(){
    Navigator.of(context).pop();
  }

  _showCompletedAlert({String message}){
    Alert().success(context, message, () {
      Common().dismiss(context);
      _navigateToOfferList();
    });
  }

  _handleAddingNewOffer() async{
    try{
      Common().loading(context);
      await _orderOfferBloc.saveOrderOfferInfo();
      Common().dismiss(context);
      _showCompletedAlert(message: AppLocalizations.of(context).translate(LocalizedKey.addOfferSuccessAlertMessage));
    } on PlatformException catch(e){
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    _orderOfferBloc = Provider.of<OrderOfferBloc>(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<Service>(
                stream: _orderOfferBloc.service,
                builder: (context, snapshot) {
                  return ServiceDropDown(
                    child: ServiceDropDownButton(
                      serviceList: servicesList,
                      service: snapshot.data,
                      onChanged: (value){
                        _orderOfferBloc.serviceChange(value);
                        _handleMainServiceChange(value);
                      },
                    ),
                  );
                }),
            Container(
              height: 16.0,
            ),
            StreamBuilder<SubService>(
                stream: _orderOfferBloc.subService,
                builder: (context, snapshot) {
                  return ServiceDropDown(
                    child: SubServiceDropDownButton(
                      subServiceList: subServicesList,
                      subService: snapshot.data,
                      onChanged: (value){
                        _orderOfferBloc.subServiceChange(value);
                        _handleSubServiceChange(value);
                      },
                    ),
                  );
                }),
            Container(
              height: 16.0,
            ),
            StreamBuilder<SubSubService>(
                stream: _orderOfferBloc.subSubService,
                builder: (context, snapshot) {
                  return ServiceDropDown(
                    child: SubSubServiceDropDownButton(
                      subSubServiceList: subSubServicesList,
                      subSubService: snapshot.data,
                      onChanged: _orderOfferBloc.subSubServiceChange,
                    ),
                  );
                }),
            Container(
              height: 16.0,
            ),
            StreamBuilder<String>(
                stream: _orderOfferBloc.offerTitleAr,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOdderTitleArTitle),
                    controller: titleArController,
                    onChange: _orderOfferBloc.offerTitleArChange,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _orderOfferBloc.offerTitleEn,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferTitleEnTitle),
                    controller: titleEnController,
                    onChange: _orderOfferBloc.offerTitleEnChange,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _orderOfferBloc.offerDescAr,
                builder: (context, snapshot) {
                  return OfferMultiLineTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferDescArTitle),
                    controller: descArController,
                    onChange: _orderOfferBloc.offerDescArChange,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _orderOfferBloc.offerDescEn,
                builder: (context, snapshot) {
                  return OfferMultiLineTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferDescEnTitle),
                    controller: descEnController,
                    onChange: _orderOfferBloc.offerDescEnChange,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _orderOfferBloc.price,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferPriceTitle),
                    controller: priceController,
                    onChange: _orderOfferBloc.priceChange,
                    keyboardType: TextInputType.number,
                    isError: snapshot.hasError,
                  );
                }),
            StreamBuilder<String>(
                stream: _orderOfferBloc.quantity,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferQtyTitle),
                    controller: quantityController,
                    onChange: _orderOfferBloc.quantityChange,
                    keyboardType: TextInputType.number,
                    isError: snapshot.hasError,
                  );
                }),
            Container(
              height: 16.0,
            ),
            StreamBuilder<bool>(
                stream: _orderOfferBloc.isValidAddFields,
                builder: (context, snapshot) {
                  return CommonButton(
                    title: AppLocalizations.of(context).translate(LocalizedKey.addOfferAddButtonTitle),
                    onPressed: snapshot.hasData ? () => _showConformatiomAlert() : null,
                  );
                }
              ),
          ],
        ),
      ),
    );
  }
}

class OfferTextField extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  final TextInputType keyboardType;
  OfferTextField(
      {this.header,
      this.hint = "",
      this.controller,
      this.isError = false,
      @required this.onChange,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(header),
          Container(
            height: 8.0,
          ),
          Container(
            height: Screen.screenWidth * 0.12,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChange,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferMultiLineTextField extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  OfferMultiLineTextField(
      {this.header,
      this.hint = "",
      this.controller,
      this.isError = false,
      @required this.onChange});

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? Colors.red : Colors.black;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(header),
          Container(
            height: 8.0,
          ),
          Container(
            height: Screen.screenWidth * 0.25,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              maxLines: 5,
              onChanged: onChange,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDropDown extends StatelessWidget {
  final Widget child;
  ServiceDropDown({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Screen.screenWidth * 0.12,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: child
        ));
  }
}

class ServiceDropDownButton extends StatelessWidget {
  final List<Service> serviceList;
  final Service service;
  final Function(Service) onChanged;
  ServiceDropDownButton({@required this.serviceList, this.service, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context).translate(LocalizedKey.addOfferServiceDropDownPlaceholderTitle)),
      value: service,
      isExpanded: true,
      onChanged: onChanged,
      items: serviceList == null || serviceList.isEmpty 
        ? null 
        : serviceList.map((serv) => DropdownMenuItem(
          child: Text(isArabic ? serv.nameAr : serv.nameEn),
          value: serv,)).toList(),
    );
  }
}

class SubServiceDropDownButton extends StatelessWidget {
  final List<SubService> subServiceList;
  final SubService subService;
  final Function(SubService) onChanged;
  SubServiceDropDownButton({@required this.subServiceList, this.subService, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context).translate(LocalizedKey.addOfferSubServiceDropDownPlaceholderTitle)),
      value: subService,
      isExpanded: true,
      onChanged: onChanged,
      items: subServiceList == null || subServiceList.isEmpty 
        ? null 
        : subServiceList.map((serv) => DropdownMenuItem(
          child: Text(isArabic ? serv.nameAr : serv.nameEn),
          value: serv,)).toList(),
    );
  }
}

class SubSubServiceDropDownButton extends StatelessWidget {
  final List<SubSubService> subSubServiceList;
  final SubSubService subSubService;
  final Function(SubSubService) onChanged;
  SubSubServiceDropDownButton({@required this.subSubServiceList, this.subSubService, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context).translate(LocalizedKey.addOfferSubSubServiceDropDownPlaceholderTitle)),
      value: subSubService,
      isExpanded: true,
      onChanged: onChanged,
      items: subSubServiceList == null || subSubServiceList.isEmpty 
        ? null 
        : subSubServiceList.map((serv) => DropdownMenuItem(
          child: Text(isArabic ? serv.nameAr : serv.nameEn),
          value: serv,)).toList(),
    );
  }
}
