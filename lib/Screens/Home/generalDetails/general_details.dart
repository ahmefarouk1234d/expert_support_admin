import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/enums.dart';
import 'package:expert_support_admin/Models/general_details_model.dart';
import 'package:expert_support_admin/Screens/Home/generalDetails/contactUs/details.dart';
import 'package:expert_support_admin/Screens/Home/generalDetails/orderLimit/details.dart';
import 'package:expert_support_admin/Screens/Home/generalDetails/shared/details.dart';
import 'package:expert_support_admin/Screens/Home/generalDetails/submitOrder/details.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';

class GeneralDetails extends StatelessWidget {
  static String route = "/GeneralDetails";

  const GeneralDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GeneralDetailsContent(),
    );
  }
}

class GeneralDetailsContent extends StatefulWidget {
  const GeneralDetailsContent({super.key});

  @override
  _GeneralDetailsContentState createState() => _GeneralDetailsContentState();
}

class _GeneralDetailsContentState extends State<GeneralDetailsContent> {
  List<GeneralDetailsModel> generalDetailsList = [];
  late AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToSelectedGeneralDetails(GeneralDetailsModel generalDetails) {
    Widget? selectedWidget;

    switch (generalDetails.type) {
      case GeneralDetailsType.contactUs:
        selectedWidget = ContactUsGeneralDetails(
          aboutUs: generalDetails.aboutUs,
        );
        break;
      case GeneralDetailsType.shared:
        selectedWidget = SharedGeneralDetails(
          shared: generalDetails.shared,
        );
        break;
      case GeneralDetailsType.submitOrder:
        selectedWidget = SubmitOrderGeneralDetails(
          submitOrder: generalDetails.submitOrder,
        );
        break;
      case GeneralDetailsType.orderLimit:
        selectedWidget = OrderLimitGeneralDetails(
          orderLimit: generalDetails.orderLimit,
        );
        break;
      default:
        break;
    }

    if (selectedWidget != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => selectedWidget!));
    } else {
      print("No widget available");
    }
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: _appBloc.generalDetailsListDocument,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }

        generalDetailsList = GeneralDetailsModel.fromDocumentSnapshotList(
            docList: snapshot.data!.docs);

        return generalDetailsList.isEmpty
            ? NoData()
            : GeneralGetailsList(
                generalDetailsList: generalDetailsList,
                onTap: (generalDetails) {
                  _navigateToSelectedGeneralDetails(generalDetails);
                },
              );
      },
    );
  }
}

class GeneralGetailsList extends StatelessWidget {
  const GeneralGetailsList({super.key, this.generalDetailsList = const [], this.onTap});
  final List<GeneralDetailsModel> generalDetailsList;
  final Function(GeneralDetailsModel generalDetails)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemCount: generalDetailsList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black12,
        ),
        itemBuilder: (_, index) {
          final generalDetails = generalDetailsList[index];
          final String title =
              GeneralDetailsModel.getDisplayType(generalDetails.type!, context);
          IconData icon = AppLocalizations.of(context).isArabic()
              ? Icons.keyboard_arrow_left
              : Icons.keyboard_arrow_right;

          return Container(
            child: ListTile(
              onTap: () => onTap?.call(generalDetails),
              title: Text(title),
              trailing: Icon(
                icon,
                color: Colors.black12,
              ),
            ),
          );
        },
      ),
    );
  }
}
