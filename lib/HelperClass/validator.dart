import 'dart:async';
import 'dart:math';

import 'package:expert_support_admin/Models/status.dart';

class Validator{
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

  final validateOrderActionButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == Status.pending || status == Status.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );

  final validateOrderEditButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == Status.pending || status == Status.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );

  final validateOrderCancelButton = StreamTransformer<String, bool>.fromHandlers(
    handleData: (status, sink){
      if (status == Status.pending || status == Status.inProcess){
        sink.add(true);
      } else {
        sink.add(false);
      }
    }
  );
}