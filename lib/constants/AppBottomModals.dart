import 'package:photogenerator/bottom_modals/delete_generation/delete_generation_modal.dart';
import 'package:photogenerator/bottom_modals/delete_generation/delete_generation_modal_bloc.dart';
import 'package:photogenerator/bottom_modals/delete_user/delete_user_modal.dart';
import 'package:photogenerator/bottom_modals/delete_user/delete_user_modal_bloc.dart';
import 'package:photogenerator/global_navigator/models/app_bottom_modal.dart';

class AppBottomModals {
  static List<AppBottomModal> get bottomModals => [
        AppBottomModal<DeleteUserModalBloc>(
          name: "/DeleteUserModal",
          dataSharingName: "DeleteUserModal",
          createBloc: (args) => DeleteUserModalBloc(args),
          createChild: (_) => DeleteUserModal(),
        ),
         AppBottomModal<DeleteGenerationModalBloc>(
          name: "/DeleteGenerationModal",
          dataSharingName: "DeleteGenerationModal",
          createBloc: (args) => DeleteGenerationModalBloc(args),
          createChild: (_) => DeleteGenerationModal(),
        ),
      ];
}
