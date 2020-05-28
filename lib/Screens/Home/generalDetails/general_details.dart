import 'package:expert_support_admin/BlocResources/app_bloc.dart';
import 'package:expert_support_admin/BlocResources/base_provider.dart';
import 'package:flutter/material.dart';

class GeneralDetails extends StatelessWidget {
  static String route = "/GeneralDetails";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GeneralDetailsContent(),
    );
  }
}

class GeneralDetailsContent extends StatefulWidget {
  @override
  _GeneralDetailsContentState createState() => _GeneralDetailsContentState();
}

class _GeneralDetailsContentState extends State<GeneralDetailsContent> {
  AppBloc _appBloc;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBloc = Provider.of<AppBloc>(context);
    
    return Container(
      
    );
  }
}

