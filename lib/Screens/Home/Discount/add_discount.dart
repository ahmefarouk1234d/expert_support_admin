import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/discount_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDiscount extends StatelessWidget {
  static String route = "/addDiscount";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscountBloc>(
      builder: (context, offerBloc) => offerBloc ?? DiscountBloc(),
      onDispose: (context, offerBloc) => offerBloc.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate(LocalizedKey.addDiscountBarTitle)),
            elevation: 0.0,
          ),
          body: AddDiscountContent()),
    );
  }
}

class AddDiscountContent extends StatefulWidget {

  @override
  _AddDiscountContentState createState() => _AddDiscountContentState();
}

class _AddDiscountContentState extends State<AddDiscountContent> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController percentController = TextEditingController();
  DiscountBloc _discountBloc;

  @override
  void initState() {
    
    super.initState();
  }

  _showConformatiomAlert() {
    String message = AppLocalizations.of(context)
        .translate(LocalizedKey.addDiscountAlertMessage);
    Alert().conformation(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.conformationAlertTitle),
        message,
        () => _handleAddingNewDiscount());
  }

  _handleAddingNewDiscount() async {
    try {
      Common().loading(context);
      await _discountBloc.saveDiscountInfo();
      Common().dismiss(context);
      _showCompletedAlert(
          message: AppLocalizations.of(context)
              .translate(LocalizedKey.addDiscountSuccessAlertMessage));
    } on PlatformException catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.message, () => Common().dismiss(context));
    }
  }

  _showCompletedAlert({String message}) {
    Alert().success(context, message, () {
      Common().dismiss(context);
      _navigateToDicountList();
    });
  }

  _navigateToDicountList() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _discountBloc = Provider.of<DiscountBloc>(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
              stream: _discountBloc.code,
              builder: (context, snapshot) {
                return DiscountTextField(
                  header: AppLocalizations.of(context)
                      .translate(LocalizedKey.discountCodeTitle),
                  controller: codeController,
                  onChange: _discountBloc.codeChange,
                  isError: snapshot.hasError,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _discountBloc.percent,
              builder: (context, snapshot) {
                return DiscountTextField(
                  header: AppLocalizations.of(context)
                      .translate(LocalizedKey.discountPercentageTitle),
                  controller: percentController,
                  onChange: _discountBloc.percentChange,
                  isError: snapshot.hasError,
                  keyboardType: TextInputType.number,
                );
              }
            ),
            Container(
              height: 16.0,
            ),
            StreamBuilder<bool>(
                stream: _discountBloc.isValidAddFields,
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

class DiscountTextField extends StatelessWidget {
  final String header;
  final String hint;
  final TextEditingController controller;
  final bool isError;
  final Function(String) onChange;
  final TextInputType keyboardType;
  DiscountTextField(
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
      padding: EdgeInsets.only(bottom: 16),
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