import 'dart:async';

import 'package:expert_support_admin/Models/service_model.dart';
import 'package:expert_support_admin/Models/status.dart';

mixin class Validator{
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
      sink.add(userRole);
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
        sink.addError("Field should be number only");
      } else {
        sink.add(text);
      }
    }
  );

  final validateServiceCategory = StreamTransformer<ServiceCategory, ServiceCategory>.fromHandlers(
    handleData: (serviceCategory, sink){
      sink.add(serviceCategory);
        }
  );

  final validateServiceType = StreamTransformer<ServiceType?, ServiceType?>.fromHandlers(
    handleData: (serviceType, sink){
      if(serviceType == null){
        sink.addError("Service type should not be empty");
      } else {
        sink.add(serviceType);
      }
    }
  );

  final validateMainService = StreamTransformer<MainService?, MainService?>.fromHandlers(
    handleData: (mainService, sink){
      if(mainService == null){
        sink.addError("Main service should not be empty");
      } else {
        sink.add(mainService);
      }
    }
  );

  final validateSubMainService = StreamTransformer<SubMainService?, SubMainService?>.fromHandlers(
    handleData: (subMainService, sink){
      if(subMainService == null){
        sink.addError("Sub main service should not be empty");
      } else {
        sink.add(subMainService);
      }
    }
  );

  final validateDiscountCode = StreamTransformer<String, String>.fromHandlers(
    handleData: (code, sink){
      if (code.isEmpty) {
        sink.addError("Code should not be empty");
      } 

      RegExp regSpace = RegExp(r"\s+\b|\b\s");
      Iterable<RegExpMatch> regSpaceMatches = regSpace.allMatches(code);
      if (code.contains(" ")) {
        sink.addError("Code should not include space");
      } else if (regSpaceMatches.isNotEmpty) {
        sink.addError("Code should not include space");
      } else {
        sink.add(code);
      } 
    }
  );

  final validateDiscountPercent = StreamTransformer<String, String>.fromHandlers(
    handleData: (percent, sink){
      RegExp regExpForNum = RegExp("^\\d+(\\.\\d{1,2})?\$");
      if (percent.isEmpty) {
        sink.addError("Percent should not be empty");
      } else if (!regExpForNum.hasMatch(percent)){
        sink.addError("Field should be positive number only");
      } else {
        sink.add(percent);
      }
    }
  );

  final validateDate = StreamTransformer<DateTime, DateTime>.fromHandlers(
    handleData: (date, sink){
      sink.add(date);
        }
  );
}
