import 'dart:async';

import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/Models/status.dart';
import 'package:expert_support_admin/Screens/NewServices/add_new_service.dart';

class Validator{
  final validateUsername = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink){
      if (username.isEmpty) {
        sink.addError("Usernanme should not be empty");
      } else {
        sink.add(username);
      }
    }
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      String emailRegexValidation =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(emailRegexValidation);
      if (email.isEmpty){
        sink.addError("Email should not be empty");
      } else if (!regExp.hasMatch(email)) {
        sink.addError("Please enter valid email");
      } else if(email.isNotEmpty){
        sink.add(email);
      }
    }
  );

  final validatePhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink){
      if (phone.isEmpty) {
        sink.addError("Phone should not be empty");
      } else if (phone.length != 9) {
        sink.addError("Phone length should be 9 digit");
      } else {
        sink.add(phone);
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if (password.isEmpty) {
        sink.addError("Password should not be empty");
      } else if (password.length < 6) {
        sink.addError("Password length should be more than 5 character");
      } else {
        sink.add(password);
      }
    }
  );

  final validateUserRole = StreamTransformer<String, String>.fromHandlers(
    handleData: (userRole, sink){
      if(userRole == null){
        sink.addError("User Role should not be empty");
      } else {
        sink.add(userRole);
      }
    }
  );

  final validateOrderActionButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == WorkflowStatus.pending || status == WorkflowStatus.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );

  final validateOrderEditButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == WorkflowStatus.pending || status == WorkflowStatus.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );

  final validateOrderCancelButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == WorkflowStatus.pending || status == WorkflowStatus.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );

  final validateTextField = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink){
      if (text.isEmpty) {
        sink.addError("Field should not be empty");
      } else {
        sink.add(text);
      }
    }
  );

  final validateNumberTextField = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink){
      RegExp regExpForNum = RegExp("^\\d+\$");
      if (text.isEmpty) {
        sink.addError("Field should not be empty");
      } else if (!regExpForNum.hasMatch(text)){
        sink.addError("Field should not be number only");
      } else {
        sink.add(text);
      }
    }
  );

  final validateService = StreamTransformer<Service, Service>.fromHandlers(
    handleData: (service, sink){
      if(service == null){
        sink.addError("Service should not be empty");
      } else {
        sink.add(service);
      }
    }
  );

  final validateSubService = StreamTransformer<SubService, SubService>.fromHandlers(
    handleData: (subService, sink){
      if(subService == null){
        sink.addError("Service should not be empty");
      } else {
        sink.add(subService);
      }
    }
  );

  final validateSubSubService = StreamTransformer<SubSubService, SubSubService>.fromHandlers(
    handleData: (subSubService, sink){
      if(subSubService == null){
        sink.addError("Service should not be empty");
      } else {
        sink.add(subSubService);
      }
    }
  );
}