import 'package:expert_support_admin/FirebaseResources/fcm_sender.dart';
import 'package:expert_support_admin/HelperClass/alert.dart';
import 'package:expert_support_admin/HelperClass/app_localizations.dart';
import 'package:expert_support_admin/HelperClass/common.dart';
import 'package:expert_support_admin/HelperClass/localized_keys.dart';
import 'package:expert_support_admin/SharedWidget/commom_button.dart';
import 'package:flutter/material.dart';

class SendNotification extends StatelessWidget {
  const SendNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return SendNotificationContent();
  }
}

class SendNotificationContent extends StatefulWidget {
  const SendNotificationContent({super.key});

  @override
  State<SendNotificationContent> createState() =>
      _SendNotificationContentState();
}

class _SendNotificationContentState extends State<SendNotificationContent> {
  final _titleArController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _bodyArController = TextEditingController();
  final _bodyEnController = TextEditingController();

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _bodyArController.dispose();
    _bodyEnController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    return _titleArController.text.trim().isNotEmpty &&
        _bodyArController.text.trim().isNotEmpty;
  }

  void _handleSend() {
    if (!_validateFields()) {
      Alert().warning(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.notificationFieldsRequiredMessage),
        () => Common().dismiss(context),
      );
      return;
    }

    Alert().conformation(
      context,
      AppLocalizations.of(context)
          .translate(LocalizedKey.conformationAlertTitle),
      AppLocalizations.of(context)
          .translate(LocalizedKey.notificationSendAlertMessage),
      () => _sendNotification(),
    );
  }

  void _sendNotification() async {
    try {
      Common().loading(context);

      await FCMSender.sendToTopic(
        topic: 'userNotify',
        titleAr: _titleArController.text.trim(),
        titleEn: _titleEnController.text.trim().isNotEmpty
            ? _titleEnController.text.trim()
            : _titleArController.text.trim(),
        bodyAr: _bodyArController.text.trim(),
        bodyEn: _bodyEnController.text.trim().isNotEmpty
            ? _bodyEnController.text.trim()
            : _bodyArController.text.trim(),
      );

      Common().dismiss(context);

      _titleArController.clear();
      _titleEnController.clear();
      _bodyArController.clear();
      _bodyEnController.clear();

      Alert().success(
        context,
        AppLocalizations.of(context)
            .translate(LocalizedKey.notificationSendSuccessMessage),
        () => Common().dismiss(context),
      );
    } catch (e) {
      Common().dismiss(context);
      Alert().error(
        context,
        e.toString(),
        () => Common().dismiss(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _titleArController,
            label: AppLocalizations.of(context)
                .translate(LocalizedKey.notificationTitleArLabel),
            isRequired: true,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _titleEnController,
            label: AppLocalizations.of(context)
                .translate(LocalizedKey.notificationTitleEnLabel),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bodyArController,
            label: AppLocalizations.of(context)
                .translate(LocalizedKey.notificationBodyArLabel),
            maxLines: 4,
            isRequired: true,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bodyEnController,
            label: AppLocalizations.of(context)
                .translate(LocalizedKey.notificationBodyEnLabel),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          CommonButton(
            title: AppLocalizations.of(context)
                .translate(LocalizedKey.notificationSendButtonTitle),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: isRequired ? "$label *" : label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }
}
