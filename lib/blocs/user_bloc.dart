import 'dart:async';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/models/bloc_data/user_bloc_data.dart';
import 'package:photogenerator/models/credits.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class UserBloc extends BlocRx<UserBlocData> {
  UserBloc() {
    initialize(UserBlocData());
  }

  Timer? _internTimer;

  String? get userId => blocData!.userId;
  Credits? get credits => blocData!.credits;

  void resetData() {
    _internTimer?.cancel();
    blocData!.userId = "";
    blocData!.credits = null;
    updateUI();
  }

  Future<void> initializeUserId() async {
    String retrievedUserId = await Api.createUserId(
      await Common.getDeviceId(),
    );
    blocData!.userId = retrievedUserId;
    updateUI();
  }

  Future<void> refresh({
    required int maxCredits,
    required int creditGainPeriod,
  }) async {
    blocData!.credits = Credits.fromMap(
      await Api.getUser(userId!),
    );
    _setInternTimer(
      blocData!.credits!,
      maxCredits: maxCredits,
      creditGainPeriod: creditGainPeriod,
    );
    updateUI();
  }

  void _setInternTimer(
    Credits credits, {
    required int maxCredits,
    required int creditGainPeriod,
  }) {
    void update() {
      if (credits.count >= maxCredits) {
        blocData!.timeTillNextCredit = null;
        updateUI();
      } else {
        int nextGain = credits.lastGain + creditGainPeriod * 1000;
        blocData!.timeTillNextCredit =
            nextGain - DateTime.now().millisecondsSinceEpoch;
        updateUI();
        if (blocData!.timeTillNextCredit! <= 0)
          refresh(
            maxCredits: maxCredits,
            creditGainPeriod: creditGainPeriod,
          );
      }
    }

    _internTimer?.cancel();
    update();
    _internTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      update();
    });
  }
}
