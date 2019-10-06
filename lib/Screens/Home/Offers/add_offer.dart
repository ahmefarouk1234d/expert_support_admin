import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/offer_bloc.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/string.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddOffer extends StatelessWidget {
  static String route = "/addOffer";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferBloc>(
      builder: (context, offerBloc) => offerBloc ?? OfferBloc(),
      onDispose: (context, offerBloc) => offerBloc.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(TextContent.newOfferTitle),
            elevation: 0.0,
          ),
          body: AddOfferContent()),
    );
  }
}

class AddOfferContent extends StatefulWidget {

  @override
  _AddOfferContentState createState() => _AddOfferContentState();
}

class _AddOfferContentState extends State<AddOfferContent> {
  final TextEditingController titleArController = TextEditingController();
  final TextEditingController titleEnController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController descEnController = TextEditingController();
  final TextEditingController offerDescArController = TextEditingController();
  final TextEditingController offerDescEnController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  List<Service> servicesList;
  Service service;
  bool isLoading;
  OfferBloc _offerBloc;

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

  _showConformatiomAlert() {
    String message = TextContent.addNewOfferConformation;
    Alert().conformation(
        context, TextContent.conformationTitle, message, () => _handleAddingNewOffer());
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
      await _offerBloc.saveOfferInfo();
      Common().dismiss(context);
      _showCompletedAlert(message: TextContent.addNewOfferSuccess);
    } on PlatformException catch(e){
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    _offerBloc = Provider.of<OfferBloc>(context);
    return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<Service>(
                  stream: _offerBloc.service,
                  builder: (context, snapshot) {
                    return ServiceDropDown(
                      servicesList: servicesList,
                      service: snapshot.data,
                      onChanged: _offerBloc.serviceChange,
                    );
                  }),
              Container(
                height: 16.0,
              ),
              StreamBuilder<String>(
                  stream: _offerBloc.offerTitleAr,
                  builder: (context, snapshot) {
                    return OfferTextField(
                      header: "Title Arabic",
                      controller: titleArController,
                      onChange: _offerBloc.offerTitleArChange,
                      isError: snapshot.hasError,
                    );
                  }),
              StreamBuilder<String>(
                  stream: _offerBloc.offerTitleEn,
                  builder: (context, snapshot) {
                    return OfferTextField(
                      header: "Title English",
                      controller: titleEnController,
                      onChange: _offerBloc.offerTitleEnChange,
                      isError: snapshot.hasError,
                    );
                  }),
              StreamBuilder<String>(
                stream: _offerBloc.offerDescAr,
                builder: (context, snapshot) {
                  return OfferMultiLineTextField(
                    header: "Desc Arabic",
                    controller: offerDescArController,
                    onChange: _offerBloc.offerDescArChange,
                    isError: snapshot.hasError,
                  );
                }
              ),
              StreamBuilder<String>(
                stream: _offerBloc.offerDescEn,
                builder: (context, snapshot) {
                  return OfferMultiLineTextField(
                    header: "Desc English",
                    controller: offerDescEnController,
                    onChange: _offerBloc.offerDescEnChange,
                    isError: snapshot.hasError,
                  );
                }
              ),
              StreamBuilder<String>(
                stream: _offerBloc.price,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: "Price",
                    controller: priceController,
                    onChange: _offerBloc.priceChange,
                    keyboardType: TextInputType.number,
                    isError: snapshot.hasError,
                  );
                }
              ),
              StreamBuilder<String>(
                stream: _offerBloc.quantity,
                builder: (context, snapshot) {
                  return OfferTextField(
                    header: "Qauntity",
                    controller: quantityController,
                    onChange: _offerBloc.quantityChange,
                    keyboardType: TextInputType.number,
                    isError: snapshot.hasError,
                  );
                }
              ),
              Container(
                height: 16.0,
              ),
              StreamBuilder<bool>(
                stream: _offerBloc.isValidAddFields,
                builder: (context, snapshot) {
                  return CommonButton(
                    title: "ADD",
                    onPressed: snapshot.hasData ? () => _showConformatiomAlert() : null,
                  );
                }
              ),
            ],
          ),
        ));
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
      {this.header, this.hint = "", this.controller, this.isError = false, @required this.onChange, this.keyboardType = TextInputType.text});

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
      {this.header, this.hint = "", this.controller, this.isError = false, @required this.onChange});

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
  final List<Service> servicesList;
  final Service service;
  final Function(Service) onChanged;
  ServiceDropDown(
      {@required this.servicesList, this.service, @required this.onChanged});

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
          child: DropdownButton(
            hint: Text("Select service"),
            value: service,
            isExpanded: true,
            onChanged: onChanged,
            items: servicesList
                .map((serv) => DropdownMenuItem(
                      child: Text(serv.nameEn),
                      value: serv,
                    ))
                .toList(),
          ),
        ));
  }
}
