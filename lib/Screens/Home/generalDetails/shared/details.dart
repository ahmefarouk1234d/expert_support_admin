import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/BlocResources/shared_bloc.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/HelperClass/ui.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/SharedWidget/bordered_textfield.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class SharedGeneralDetails extends StatelessWidget {
  SharedGeneralDetails({super.key, this.shared});
  
  final Shared? shared;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SharedBloc>(
      builder: (context, sharedBloc) => SharedBloc(
        ios: shared!.link ?? '',
        android: shared!.linkAndroid ?? ''
      ),
      onDispose: (context, sharedBloc) => sharedBloc?.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GeneralDetailsModel.getDisplayType(
              GeneralDetailsType.shared, context)
            ),
          elevation: 0.0,),
        body: SharedGeneralDetailsContent(shared: shared,),
      ),
    );
  }
}

class SharedGeneralDetailsContent extends StatefulWidget {
  SharedGeneralDetailsContent({super.key, this.shared});
  
  final Shared? shared;

  @override
  _SharedGeneralDetailsContentState createState() => _SharedGeneralDetailsContentState();
}

class _SharedGeneralDetailsContentState extends State<SharedGeneralDetailsContent> {

  late Shared shared;

  late TextEditingController _iosLinkController;
  late TextEditingController _androidLinkController;

  late SharedBloc _sharedBloc;
  late AppLocalizations _localizations;

  @override
  void initState() {
    shared = widget.shared!;
    _iosLinkController = TextEditingController(text: shared.link);
    _androidLinkController = TextEditingController(text: shared.linkAndroid);

    super.initState();
  }

  void _showConformation() {
    FocusScope.of(context).unfocus();
    Alert().conformation(
      context, 
      _localizations.translate(LocalizedKey.conformationAlertTitle), 
      _localizations.translate(LocalizedKey.sharedConformationAlertMessage),
      () { _sharedBloc.update(context); }
    );
  }

  @override
  Widget build(BuildContext context) {
    _sharedBloc = Provider.of<SharedBloc>(context);
    _localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: _sharedBloc.iosLink,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.iosAppLinkTitle),
                  controller: _iosLinkController,
                  onChange: _sharedBloc.iosLinkChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  height: Screen.screenWidth * 0.20,
                  keyboardType: TextInputType.url,
                );
              }
            ),
            StreamBuilder<String>(
              stream: _sharedBloc.androidLink,
              builder: (context, snapshot) {
                return BorderedTextField(
                  header: _localizations.translate(LocalizedKey.androidAppLinkTitle),
                  controller: _androidLinkController,
                  onChange: _sharedBloc.androidLinkChange,
                  isError: snapshot.hasError,
                  textDirection: TextDirection.ltr,
                  height: Screen.screenWidth * 0.20,
                  keyboardType: TextInputType.url,
                );
              }
            ),
            Container(height: 16,),
            StreamBuilder<bool>(
              stream: _sharedBloc.isValidUpdateFields,
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