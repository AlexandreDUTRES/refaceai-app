import 'dart:async';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/models/bloc_data/user_bloc_data.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class UserBloc extends BlocRx<UserBlocData> {
  UserBloc() {
    initialize(UserBlocData());
  }

  String? get userId => blocData!.userId;

  void resetData() {
    blocData!.userId = "";
    updateUI();
  }

  Future<void> initializeUserId() async {
    String retrievedUserId = await Api.createUserId(
      await Common.getDeviceId(),
    );
    blocData!.userId = retrievedUserId;
    updateUI();
  }
}
