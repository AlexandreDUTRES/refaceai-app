import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/blocs/main_app_widget_bloc.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class DeleteUserModalData {}

class DeleteUserModalBloc extends Bloc<DeleteUserModalData> {
  DeleteUserModalBloc(Map<String, dynamic> args) : super(DeleteUserModalData());

  Future<void> confirm() async {
    await GlobalLoader.showOverlayLoader();
    try {
      await Api.deleteUser(
        blocManager.userBloc.userId!,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      GlobalLoader.hideOverlayLoader();
      return Common.showSnackbar();
    }
    GlobalLoader.hideOverlayLoader();
    await MainAppWidgetBloc().restartApp();
  }
}
