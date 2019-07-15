
import 'package:flutter/material.dart';

import 'auth_bloc.dart';

class AuthProvider extends InheritedWidget{
  final AuthBloc authBloc;

  AuthProvider({
    Key key,
    AuthBloc authBloc,
    Widget child,
  }) : authBloc = authBloc ?? AuthBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(AuthProvider oldWidget) => oldWidget.authBloc != authBloc;

  static AuthBloc of(BuildContext context) => (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider).authBloc;
}

class AuthBlocProvider extends StatefulWidget{
  final void Function(BuildContext context, AuthBloc authBloc) onDispose;
  final AuthBloc Function(BuildContext context, AuthBloc authBloc) builder;
  final Widget child;

  AuthBlocProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose
  }) : super(key: key);
  
  _AuthBlocProviderState createState() => _AuthBlocProviderState();
}

class _AuthBlocProviderState extends State<AuthBlocProvider>{
  AuthBloc authBloc;

  @override
  void initState() {
    if (widget.onDispose != null){
      authBloc = widget.builder(context, authBloc);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null){
      widget.onDispose(context, authBloc);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      authBloc: authBloc,
      child: widget.child,
    );
  }

}