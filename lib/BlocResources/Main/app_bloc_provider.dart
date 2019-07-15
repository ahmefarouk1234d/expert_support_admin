import 'package:expert_support_admin/BlocResources/Main/app_bloc.dart';
import 'package:flutter/material.dart';

class AppProvider extends InheritedWidget{
  final AppBloc appBloc;

  AppProvider({
    Key key,
    AppBloc appBloc,
    Widget child,
  }) : appBloc = appBloc ?? AppBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(AppProvider oldWidget) => oldWidget.appBloc != appBloc;

  static AppBloc of(BuildContext context) => (context.inheritFromWidgetOfExactType(AppProvider) as AppProvider).appBloc;
}

class AppBlocProvider extends StatefulWidget{
  final void Function(BuildContext context, AppBloc appBloc) onDispose;
  final AppBloc Function(BuildContext context, AppBloc appBloc) builder;
  final Widget child;

  AppBlocProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose
  }) : super(key: key);
  
  _AppBlocProviderState createState() => _AppBlocProviderState();
}

class _AppBlocProviderState extends State<AppBlocProvider>{
  AppBloc appBloc;

  @override
  void initState() {
    if (widget.onDispose != null){
      appBloc = widget.builder(context, appBloc);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null){
      widget.onDispose(context, appBloc);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      appBloc: appBloc,
      child: widget.child,
    );
  }

}