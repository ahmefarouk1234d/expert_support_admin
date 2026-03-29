import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/submit_order_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/SharedWidget/bordered_textfield.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class SubmitOrderGeneralDetails extends StatelessWidget {
  SubmitOrderGeneralDetails({super.key, this.submitOrder});
  
  final SubmitOrder? submitOrder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubmitOrderBloc>(
      builder: (context, submitOrderBloc) => SubmitOrderBloc(
        vatPercentage: submitOrder!.vatPercentage.toString(),
        isCashEnabled: submitOrder!.isCashEnabled ?? false,
        isPOSEnabled: submitOrder!.isPOSEnabled ?? false,
        limitRate: submitOrder!.limitRate.toString(),
        canShowVatNote: submitOrder!.canShowVatNote ?? false,
        vatPriceNoteAr: submitOrder!.vatPriceNoteAr ?? '',
        vatPriceNoteEn: submitOrder!.vatPriceNoteEn ?? ''
      ),
      onDispose: (context, submitOrderBloc) => submitOrderBloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GeneralDetailsModel.getDisplayType(
              GeneralDetailsType.submitOrder, context)
            ),
          elevation: 0.0,),
        body: SubmitOrderGeneralDetailsContent(submitOrder: submitOrder,),
      ),
    );
  }
}

class SubmitOrderGeneralDetailsContent extends StatefulWidget {
  SubmitOrderGeneralDetailsContent({super.key, this.submitOrder});
  
  final SubmitOrder? submitOrder;

  @override
  _SubmitOrderGeneralDetailsContentState createState() => _SubmitOrderGeneralDetailsContentState();
}

class _SubmitOrderGeneralDetailsContentState extends State<SubmitOrderGeneralDetailsContent> {

  late SubmitOrder submitOrder;

  late TextEditingController _vatPrecentageController;
  late TextEditingController _limitRateController;
  late TextEditingController _vatNoteArController;
  late TextEditingController _vatNoteEnController;

  late SubmitOrderBloc _submitOrderBloc;
  late AppLocalizations _localizations;

  @override
  void initState() {
    submitOrder = widget.submitOrder!;
    _vatPrecentageController = TextEditingController(text: submitOrder.vatPercentage.toString());
    _limitRateController = TextEditingController(text: submitOrder.limitRate.toString());
    _vatNoteArController = TextEditingController(text: submitOrder.vatPriceNoteAr.toString());
    _vatNoteEnController = TextEditingController(text: submitOrder.vatPriceNoteEn.toString());

    super.initState();
  }

  void _showConformation() {
    FocusScope.of(context).unfocus();
    Alert().conformation(
      context, 
      _localizations.translate(LocalizedKey.conformationAlertTitle), 
      _localizations.translate(LocalizedKey.submitOrderConformationAlertMessage),
      () { _submitOrderBloc.update(context); }
    );
  }

  @override
  Widget build(BuildContext context) {
    _submitOrderBloc = Provider.of<SubmitOrderBloc>(context);
    _localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _submitOrderBloc.vatPercentage,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.vatPercentageTitle),
                  controller: _vatPrecentageController,
                  onChange: _submitOrderBloc.vatPercentageChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  inputFormatters: Common().getNumberOnlyInputFormatters(),
                );
              }
            ),
            StreamBuilder<bool>(
              stream: _submitOrderBloc.isCashEnabled,
              initialData: submitOrder.isCashEnabled,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _localizations.translate(LocalizedKey.isCashEnabledTitle)
                      )
                    ),
                    Switch(
                      value: snapshot.data ?? false,
                      onChanged: (val) => _submitOrderBloc.isCashEnabledChange(val),
                    ),
                  ],
                );
              }
            ),
            StreamBuilder<bool>(
              stream: _submitOrderBloc.isPOSEnabled,
              initialData: submitOrder.isPOSEnabled,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _localizations.translate(LocalizedKey.isPOSEnabledTitle)
                      )
                    ),
                    Switch(
                      value: snapshot.data ?? false,
                      onChanged: (val) => _submitOrderBloc.isPOSEnabledChange(val),
                    ),
                  ],
                );
              }
            ),
            StreamBuilder<String>(
              stream: _submitOrderBloc.limitRate,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.limitRateTitle),
                  controller: _limitRateController,
                  onChange: _submitOrderBloc.limitRateChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  inputFormatters: Common().getNumberOnlyInputFormatters(),
                );
              }
            ),
            StreamBuilder<bool>(
              stream: _submitOrderBloc.canShowVatNote,
              initialData: submitOrder.canShowVatNote,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _localizations.translate(LocalizedKey.canShowVatNoteTitle)
                      )
                    ),
                    Switch(
                      value: snapshot.data ?? false,
                      onChanged: (val) => _submitOrderBloc.canShowVatNoteChange(val),
                    ),
                  ],
                );
              }
            ),
            StreamBuilder<String>(
              stream: _submitOrderBloc.vatPriceNoteAr,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.vatNoteArTitle),
                  controller: _vatNoteArController,
                  onChange: _submitOrderBloc.vatPriceNoteArChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.text,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _submitOrderBloc.vatPriceNoteEn,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.vatNoteEnTitle),
                  controller: _vatNoteEnController,
                  onChange: _submitOrderBloc.vatPriceNoteEnChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.text,
                );
              }
            ),
            Container(height: 16,),
            StreamBuilder<bool>(
              stream: _submitOrderBloc.isValidUpdateFields,
              builder: (context, snapshot) {
                return CommonButton(
                  title: _localizations.translate(LocalizedKey.updateButtonTitle), 
                  onPressed: snapshot.hasData ? () { _showConformation(); } : null
                );
              }
            )
          ],
        ),
      ),
    );
  }
}