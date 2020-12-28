import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/order_offer_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPackages extends StatelessWidget {
  static String route = "/addPackages";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderOfferBloc>(
      builder: (context, offerBloc) => offerBloc ?? OrderOfferBloc(),
      onDispose: (context, offerBloc) => offerBloc.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations
                .of(context)
                .translate(
                  LocalizedKey.addOfferOnPackageAppBarTitle
                )
              ),
            elevation: 0.0,
          ),
          body: AddPackagesContent()),
    );
  }
}

class AddPackagesContent extends StatefulWidget {
  @override
  _AddPackagesContentState createState() => _AddPackagesContentState();
}

class _AddPackagesContentState extends State<AddPackagesContent> {
  final TextEditingController titleArController = TextEditingController();
  final TextEditingController titleEnController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController descEnController = TextEditingController();
  final TextEditingController serviceDetailsArController = TextEditingController();
  final TextEditingController serviceDetailsEnController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  OrderOfferBloc _orderOfferBloc;

  _showConformatiomAlert() {
    String message = AppLocalizations
      .of(context)
      .translate(LocalizedKey.addOfferOnPackagesAlertMessage);

    Alert().conformation(
        context,
        AppLocalizations
          .of(context)
          .translate(LocalizedKey.conformationAlertTitle),
        message,
        () => _handleAddingNewOffer()
    );
  }

  _handleAddingNewOffer() async {
    try {
      Common().loading(context);
      await _orderOfferBloc.savePackagesOfferInfo();
      Common().dismiss(context);
      _showCompletedAlert(
        message: AppLocalizations
          .of(context)
          .translate(LocalizedKey.addOfferOnPackagesSuccessAlertMessage)
      );
    } on PlatformException catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  _showCompletedAlert({String message}) {
    Alert().success(context, message, () {
      Common().dismiss(context);
      _navigateToOfferList();
    });
  }

  _navigateToOfferList() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _orderOfferBloc = Provider.of<OrderOfferBloc>(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _orderOfferBloc.offerTitleAr,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: titleArController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesNameArTitle
                    ),
                  onChange: _orderOfferBloc.offerTitleArChange,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.offerTitleEn,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: titleEnController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesNameEnTitle
                    ),
                  onChange: _orderOfferBloc.offerTitleEnChange,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.offerDescAr,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: descArController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesDescArTitle
                    ),
                  onChange: _orderOfferBloc.offerDescArChange,
                  isMultipleLine: true,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.offerDescEn,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: descEnController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesDescEnTitle
                    ),
                  onChange: _orderOfferBloc.offerDescEnChange,
                  isMultipleLine: true,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.serviceDetailsAr,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: serviceDetailsArController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesServiceDetailsArTitle
                    ),
                  onChange: _orderOfferBloc.serviceDetailsArChange,
                  isMultipleLine: true,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.serviceDetailsEn,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: serviceDetailsEnController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesServiceDetailsEnTitle
                    ),
                  onChange: _orderOfferBloc.serviceDetailsEnChange,
                  isMultipleLine: true,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _orderOfferBloc.price,
              builder: (context, snapshot) {
                return OfferTypeTextField(
                  controller: priceController,
                  header: AppLocalizations
                    .of(context)
                    .translate(
                      LocalizedKey.packagesPriceTitle
                    ),
                  onChange: _orderOfferBloc.priceChange,
                  keyboardType: TextInputType.number,
                  inputFormatters: Common().getNumberOnlyInputFormatters(),
                  isError: snapshot.hasError,
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            StreamBuilder<bool>(
              stream: _orderOfferBloc.isValidAddPackagesFields,
              builder: (context, snapshot) {
                return CommonButton(
                  title: AppLocalizations
                        .of(context)
                        .translate(
                          LocalizedKey.addOfferAddButtonTitle
                        ),
                  onPressed: snapshot.hasData
                      ? () => _showConformatiomAlert()
                      : null,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

class OfferTypeTextField extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  final TextInputType keyboardType;
  final bool isMultipleLine;
  final List<TextInputFormatter> inputFormatters;
  OfferTypeTextField(
      {this.header,
      this.hint = "",
      this.controller,
      this.isError = false,
      @required this.onChange,
      this.keyboardType = TextInputType.text,
      this.isMultipleLine = false,
      this.inputFormatters,});

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
            height: Screen.screenWidth * (isMultipleLine ? 0.25 : 0.12),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChange,
              maxLines: isMultipleLine ? 5 : null,
              decoration: InputDecoration.collapsed(hintText: hint),
              inputFormatters: inputFormatters,
            ),
          ),
        ],
      ),
    );
  }
}

class OfferTypeMultiLineTextField extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  OfferTypeMultiLineTextField(
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
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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