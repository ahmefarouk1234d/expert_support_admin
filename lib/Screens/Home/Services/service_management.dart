import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_support_admin/FirebaseResources/firebase_manager.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/SharedWidget/loading.dart';
import 'package:expert_support_admin/SharedWidget/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServiceManagement extends StatelessWidget {
  const ServiceManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceManagementContent();
  }
}

class ServiceManagementContent extends StatefulWidget {
  const ServiceManagementContent({super.key});

  @override
  State<ServiceManagementContent> createState() =>
      _ServiceManagementContentState();
}

class _ServiceManagementContentState extends State<ServiceManagementContent> {
  final FirebaseManager _firebaseManager = FirebaseManager();

  void _handleToggle(ServiceCategory service, bool newValue) {
    String message = AppLocalizations.of(context)
        .translate(LocalizedKey.serviceStatusChangeAlertMessage);
    Alert().conformation(
      context,
      AppLocalizations.of(context)
          .translate(LocalizedKey.conformationAlertTitle),
      message,
      () => _updateServiceStatus(service, newValue),
    );
  }

  void _updateServiceStatus(ServiceCategory service, bool newValue) async {
    try {
      Common().loading(context);
      await _firebaseManager.updateServiceActiveStatus(
          service.docID!, newValue);
      Common().dismiss(context);
      Alert().success(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.serviceStatusChangeSuccessMessage),
        () => Common().dismiss(context),
      );
    } on PlatformException catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.message ?? '', () => Common().dismiss(context));
    } catch (e) {
      Common().dismiss(context);
      Alert().error(context, e.toString(), () => Common().dismiss(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = AppLocalizations.of(context).isArabic();

    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseManager.getServicesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }

        List<ServiceCategory> services =
            ServiceCategory.fromListMap(docList: snapshot.data!.docs);

        if (services.isEmpty) {
          return NoData();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: services.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.black12),
          itemBuilder: (context, index) {
            ServiceCategory service = services[index];
            bool isActive = service.isActive ?? false;
            String serviceName =
                isArabic ? (service.nameAr ?? '') : (service.nameEn ?? '');
            String statusText = isActive
                ? AppLocalizations.of(context)
                    .translate(LocalizedKey.serviceActiveText)
                : AppLocalizations.of(context)
                    .translate(LocalizedKey.serviceComingSoonText);

            BoxBorder border = isArabic
                ? Border(
                    right: BorderSide(
                        width: 4,
                        color: isActive ? Colors.green : Colors.orange))
                : Border(
                    left: BorderSide(
                        width: 4,
                        color: isActive ? Colors.green : Colors.orange));

            return Container(
              decoration: BoxDecoration(border: border),
              child: ListTile(
                title: Text(
                  serviceName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  statusText,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.orange,
                    fontSize: 13,
                  ),
                ),
                trailing: Switch(
                  value: isActive,
                  activeColor: Colors.green,
                  onChanged: (value) => _handleToggle(service, value),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
