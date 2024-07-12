import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/user_bloc_data.dart';
import 'package:photogenerator/models/credits.dart';

class UserBuilder extends StatelessWidget {
  final Widget Function(Credits, int?) builder;
  final Widget? placeHolder;

  UserBuilder(this.builder, {this.placeHolder});

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserBlocData>(
      stream: blocManager.userBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.credits == null)
          return _placeHolder;
        return builder(
          snapshot.data!.credits!,
          snapshot.data!.timeTillNextCredit,
        );
      },
    );
  }
}
