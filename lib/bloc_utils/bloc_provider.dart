library bloc_provider;

import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  //this bloc
  final T bloc;

  // child of this bloc
  final Widget child;

  //constructor
  // ignore: use_key_in_widget_constructors
  const BlocProvider({
    Key? key,
    required this.bloc,
    required this.child,
  }) : super(key: key);

  //configure the bloc
  static T of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T>? _provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return _provider!.bloc;
  }

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
