library main_app_widget;

import 'package:flutter/material.dart';
import 'package:photogenerator/global_navigator/blocs/main_app_widget_bloc.dart';

// ignore: must_be_immutable
class MainAppWidget extends StatefulWidget {
  const MainAppWidget({
    Key? key,
    required this.child,
    required this.binding,
    required this.restartComputeFunction,
  }) : super(key: key);

  final Widget child;
  final WidgetsBinding binding;
  final Future<void> Function(bool) restartComputeFunction;

  @override
  _MainAppWidgetState createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MainAppWidgetBloc()
        .setRestartComputeFunction(widget.restartComputeFunction);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    MainAppWidgetBloc().setAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainAppWidgetBlocData>(
      stream: MainAppWidgetBloc().stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        MediaQueryData mediaQueryData =
            MediaQueryData.fromView(View.of(context)).copyWith(
          textScaler: const TextScaler.linear(1.0),
        );

        return MediaQuery(
          data: mediaQueryData,
          child: KeyedSubtree(
            key: snapshot.data!.layoutKey,
            child: widget.child,
          ),
        );
      },
    );
  }
}
