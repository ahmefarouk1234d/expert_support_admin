import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/contact_us_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/SharedWidget/bordered_textfield.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:expert_support_admin/SharedWidget/phone_bordered_textfield.dart';
import 'package:flutter/material.dart';

class ContactUsGeneralDetails extends StatelessWidget {
  ContactUsGeneralDetails({super.key, this.aboutUs});
  
  final AboutUs? aboutUs;

  String _getPhoneWithoutAreaCode(){
    String phone = aboutUs!.phone ?? '';

    return phone.replaceAll('+966', '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactUsBloc>(
      builder: (context, contactUsBloc) => ContactUsBloc(
        aboutUsAr: aboutUs!.aboutUsAr ?? '',
        aboutUsEn: aboutUs!.aboutUsEn ?? '',
        headerAr: aboutUs!.headerAr ?? '',
        headerEn: aboutUs!.headerEn ?? '',
        phone: _getPhoneWithoutAreaCode(),
        twitter: aboutUs!.twitter ?? '',
        instagram: aboutUs!.instagram ?? '',
        facebook: aboutUs!.facebook ?? ''
      ),
      onDispose: (context, contactUsBloc) => contactUsBloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GeneralDetailsModel.getDisplayType(
              GeneralDetailsType.contactUs, context)
            ),
          elevation: 0.0,),
        body: ContactUsGeneralDetailsContent(aboutUs: aboutUs,),
      ),
    );
  }
}

class ContactUsGeneralDetailsContent extends StatefulWidget {
  ContactUsGeneralDetailsContent({super.key, this.aboutUs});
  
  final AboutUs? aboutUs;

  @override
  _ContactUsGeneralDetailsContentState createState() => _ContactUsGeneralDetailsContentState();
}

class _ContactUsGeneralDetailsContentState extends State<ContactUsGeneralDetailsContent> {

  late AboutUs aboutUs;

  late TextEditingController _aboutUsArController;
  late TextEditingController _aboutUsEnController;
  late TextEditingController _headerArController;
  late TextEditingController _headerEnController;
  late TextEditingController _phoneController;
  late TextEditingController _twitterController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;

  late ContactUsBloc _contactUsBloc;
  late AppLocalizations _localizations;

  @override
  void initState() {
    aboutUs = widget.aboutUs!;
    _aboutUsArController = TextEditingController(text: aboutUs.aboutUsAr);
    _aboutUsEnController = TextEditingController(text: aboutUs.aboutUsEn);
    _headerArController = TextEditingController(text: aboutUs.headerAr);
    _headerEnController = TextEditingController(text: aboutUs.headerEn);
    _phoneController = TextEditingController(text: _getPhoneWithoutAreaCode());
    _twitterController = TextEditingController(text: aboutUs.twitter);
    _instagramController = TextEditingController(text: aboutUs.instagram);
    _facebookController = TextEditingController(text: aboutUs.facebook);

    super.initState();
  }

  String _getPhoneWithoutAreaCode(){
    String phone = aboutUs.phone ?? '';

    return phone.replaceAll('+966', '');
  }

  void _showConformation() {
    FocusScope.of(context).unfocus();
    Alert().conformation(
      context, 
      _localizations.translate(LocalizedKey.conformationAlertTitle), 
      _localizations.translate(LocalizedKey.aboutUsConformationAlertMessage),
      () { _contactUsBloc.update(context); }
    );
  }

  @override
  Widget build(BuildContext context) {
    _contactUsBloc = Provider.of<ContactUsBloc>(context);
    _localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _contactUsBloc.headerAr,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.headerArTitle),
                  controller: _headerArController,
                  onChange: _contactUsBloc.headerArChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.rtl,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.headerEn,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.headerEnTitle),
                  controller: _headerEnController,
                  onChange: _contactUsBloc.headerEnChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.aboutUsAr,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.aboutUsArTitle),
                  controller: _aboutUsArController,
                  onChange: _contactUsBloc.aboutUsArChange,
                  isError: snapshot.hasError,
                  height: Screen.screenWidth * 0.30,
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.aboutUsEn,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.aboutUsEnTitle),
                  controller: _aboutUsEnController,
                  onChange:_contactUsBloc.aboutUsEnChange,
                  isError: snapshot.hasError,
                  height: Screen.screenWidth * 0.30,
                  maxLines: 5,
                  textDirection: TextDirection.ltr,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.phone,
              builder: (context, snapshot) {
                return PhoneBorderedTextfield(
                  header: _localizations.translate(LocalizedKey.phoneTitle),
                  controller: _phoneController,
                  onChange: _contactUsBloc.phoneChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.twitter,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.twitterTitle),
                  controller: _twitterController,
                  onChange: _contactUsBloc.twitterChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.instagram,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.instagramTitle),
                  controller: _instagramController,
                  onChange: _contactUsBloc.instagramChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _contactUsBloc.facebook,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.facebookTitle),
                  controller: _facebookController,
                  onChange: _contactUsBloc.facebookChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  inputFormatters: Common().getNumberOnlyInputFormatters(),
                );
              }
            ),
            Container(height: 16,),
            StreamBuilder<bool>(
              stream: _contactUsBloc.isValidUpdateFields,
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