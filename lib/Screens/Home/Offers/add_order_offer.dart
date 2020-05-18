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

  List<ServiceCategory> serviceCategoryList;
  List<ServiceType> serviceTypeList;
  List<MainService> mainServiceList;
  List<SubMainService> subMainServiceList;

  bool isLoading;
  OrderOfferBloc _orderOfferBloc;
  bool hasSubService;
  num originalPrice;

  @override
  void initState() {
    serviceCategoryList = List();
    hasSubService = false;
    originalPrice = 0.0;
    _getServices();
    super.initState();
  }

  _getServices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseManager().getServices();
      if (querySnapshot.documents.length > 0) {
        setState(() {
          serviceCategoryList =
              ServiceCategory.fromListMap(docList: querySnapshot.documents);
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

  _handleServiceCategoryChange(ServiceCategory value) {
    setState(() {
      serviceCategoryList.forEach((servCat) {
        if (value.id == servCat.id) {
          serviceTypeList = servCat.serviceTypeList;
        }
      });
      _orderOfferBloc.serviceTypeChange(null);

      _orderOfferBloc.mainServiceChange(null);
      mainServiceList = null;

      _orderOfferBloc.subMainServiceChange(null);
      subMainServiceList = null;

      originalPrice = 0.0;
    });
  }

  _handleServiceTypeChange(ServiceType value) {
    setState(() {
      serviceTypeList.forEach((servType) {
        if (value.id == servType.id) {
          mainServiceList = servType.mainServiceList;
          originalPrice = 0.0;
        }
      });
      _orderOfferBloc.mainServiceChange(null);
      _orderOfferBloc.subMainServiceChange(null);
      subMainServiceList = null;
    });
  }

  _handleMainServiceChange(MainService value) {
    setState(() {
      mainServiceList.forEach((servType) {
        if (value.id == servType.id) {
          subMainServiceList = servType.subMainServiceList;
          if (!value.hasSub) {
            originalPrice = value.price;
          }
        }
      });
      hasSubService = value.hasSub;
      _orderOfferBloc.subMainServiceChange(null);
    });
  }

  _handleSubMainServiceChange(SubMainService value) {
    setState(() {
      originalPrice = value.price;
    });
  }

  _showConformatiomAlert() {
    String message = AppLocalizations.of(context)
        .translate(LocalizedKey.addOfferAlertMessage);
    Alert().conformation(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.conformationAlertTitle),
        message,
        () => _handleAddingNewOffer());
  }

  _navigateToOfferList() {
    Navigator.of(context).pop();
  }

  _showCompletedAlert({String message}) {
    Alert().success(context, message, () {
      Common().dismiss(context);
      _navigateToOfferList();
    });
  }

  _handleAddingNewOffer() async {
    try {
      Common().loading(context);
      await _orderOfferBloc.saveOrderOfferInfo();
      Common().dismiss(context);
      _showCompletedAlert(
          message: AppLocalizations.of(context)
              .translate(LocalizedKey.addOfferSuccessAlertMessage));
    } on PlatformException catch (e) {
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
            StreamBuilder<ServiceCategory>(
              stream: _orderOfferBloc.serviceCategory,
              builder: (context, snapshot) {
                return ServiceDropDown(
                  child: ServiceCategoryDropDownButton(
                    serviceCategoryList: serviceCategoryList,
                    serviceCategory: snapshot.data,
                    onChanged: (value){
                      _handleServiceCategoryChange(value);
                      _orderOfferBloc.serviceCategoryChange(value);
                    },
                  ),
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            StreamBuilder<ServiceType>(
              stream: _orderOfferBloc.serviceType,
              builder: (context, snapshot) {
                return ServiceDropDown(
                  child: ServiceTypeDropDownButton(
                    serviceTypeList: serviceTypeList,
                    serviceType: snapshot.data,
                    onChanged: (value){
                      _handleServiceTypeChange(value);
                      _orderOfferBloc.serviceTypeChange(value);
                    },
                  ),
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            StreamBuilder<MainService>(
              stream: _orderOfferBloc.mainService,
              builder: (context, snapshot) {
                return ServiceDropDown(
                  child: MainServiceDropDownButton(
                    mainServiceList: mainServiceList,
                    mainService: snapshot.data,
                    onChanged: (value){
                      _handleMainServiceChange(value);
                      _orderOfferBloc.mainServiceChange(value);
                    },
                  ),
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            StreamBuilder<SubMainService>(
              stream: _orderOfferBloc.subMainService,
              builder: (context, snapshot) {
                return ServiceDropDown(
                  child: SubMainServiceDropDownButton(
                    subMainServiceList: subMainServiceList,
                    subMainService: snapshot.data,
                    onChanged: (value) { 
                      _handleSubMainServiceChange(value);
                      _orderOfferBloc.subMainServiceChange(value); 
                    },
                  ),
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            ServiceOrigianlPrice(price: originalPrice,),
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
                stream: hasSubService ? _orderOfferBloc.isValidAddFieldsWithSub : _orderOfferBloc.isValidAddFields,
                builder: (context, snapshot) {
                  return CommonButton(
                    title: AppLocalizations.of(context)
                        .translate(LocalizedKey.addOfferAddButtonTitle),
                    onPressed: snapshot.hasData
                        ? () => _showConformatiomAlert()
                        : null,
                  );
                }),
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
        child: DropdownButtonHideUnderline(child: child));
  }
}

class ServiceCategoryDropDownButton extends StatelessWidget {
  final List<ServiceCategory> serviceCategoryList;
  final ServiceCategory serviceCategory;
  final Function(ServiceCategory) onChanged;
  ServiceCategoryDropDownButton(
      {@required this.serviceCategoryList,
      this.serviceCategory,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context).translate(
          LocalizedKey.addOfferServiceCategoryDropDownPlaceholderTitle)),
      value: serviceCategory,
      isExpanded: true,
      onChanged: onChanged,
      items: serviceCategoryList == null || serviceCategoryList.isEmpty
          ? null
          : serviceCategoryList
              .map((serv) => DropdownMenuItem(
                    child: Text(isArabic ? serv.nameAr : serv.nameEn),
                    value: serv,
                  ))
              .toList(),
    );
  }
}

class ServiceTypeDropDownButton extends StatelessWidget {
  final List<ServiceType> serviceTypeList;
  final ServiceType serviceType;
  final Function(ServiceType) onChanged;
  ServiceTypeDropDownButton(
      {@required this.serviceTypeList,
      this.serviceType,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)
          .translate(LocalizedKey.addOfferServiceTypeDropDownPlaceholderTitle)),
      value: serviceType,
      isExpanded: true,
      onChanged: onChanged,
      items: serviceTypeList == null || serviceTypeList.isEmpty
          ? null
          : serviceTypeList
              .map((serv) => DropdownMenuItem(
                    child: Text(isArabic ? serv.nameAr : serv.nameEn),
                    value: serv,
                  ))
              .toList(),
    );
  }
}

class MainServiceDropDownButton extends StatelessWidget {
  final List<MainService> mainServiceList;
  final MainService mainService;
  final Function(MainService) onChanged;
  MainServiceDropDownButton(
      {@required this.mainServiceList,
      this.mainService,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)
          .translate(LocalizedKey.addOfferMainServiceDropDownPlaceholderTitle)),
      value: mainService,
      isExpanded: true,
      onChanged: onChanged,
      items: mainServiceList == null || mainServiceList.isEmpty
          ? null
          : mainServiceList
              .map((serv) => DropdownMenuItem(
                    child: Text(isArabic ? serv.nameAr : serv.nameEn),
                    value: serv,
                  ))
              .toList(),
    );
  }
}

class SubMainServiceDropDownButton extends StatelessWidget {
  final List<SubMainService> subMainServiceList;
  final SubMainService subMainService;
  final Function(SubMainService) onChanged;
  SubMainServiceDropDownButton(
      {@required this.subMainServiceList,
      this.subMainService,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = AppLocalizations.of(context).isArabic();
    return DropdownButton(
      hint: Text(AppLocalizations.of(context).translate(
          LocalizedKey.addOfferSubMainServiceDropDownPlaceholderTitle)),
      value: subMainService,
      isExpanded: true,
      onChanged: onChanged,
      items: subMainServiceList == null || subMainServiceList.isEmpty
          ? null
          : subMainServiceList
              .map((serv) => DropdownMenuItem(
                    child: Text(isArabic ? serv.nameAr : serv.nameEn),
                    value: serv,
                  ))
              .toList(),
    );
  }
}

class ServiceOrigianlPrice extends StatelessWidget {
  ServiceOrigianlPrice({Key key, @required this.price}): super(key: key);

  final num price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppLocalizations.of(context).translate(LocalizedKey.offerOriginalServicePrice)
            )
          ),
          Container(width: 8,),
          Text("$price")
        ],
      ),
    );
  }
}