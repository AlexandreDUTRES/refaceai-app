library app_bottom_modal;

import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/global_navigator/utils.dart';

class AppBottomModal<B extends Bloc> {
  final String name;
  final String? dataSharingName;
  final bool unskipable;
  final B Function(Map<String, dynamic>) createBloc;
  final Widget Function(Map<String, dynamic>) createChild;

  AppBottomModal({
    required this.name,
    required this.dataSharingName,
    this.unskipable = false,
    required this.createBloc,
    required this.createChild,
  });

  void pushPage(
    Function? callback,
    Map<String, dynamic> args,
  ) {
    openModalBottomSheet(this, callback, args);
  }

  Widget getBlocProvider(Map<String, dynamic> args) {
    return BlocProvider<B>(
      bloc: createBloc(args),
      child: createChild(args),
    );
  }

  @override
  String toString() {
    return {
      "name": name,
      "dataSharingName": dataSharingName,
      "unskipable": unskipable,
    }.toString();
  }
}
