import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'create_goal/create_goal_bloc/create_goal_bloc.dart';
import 'create_goal/create_goal_screen.dart';

class GoalRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {};
  }

  static Map<String, WidgetBuilder>? getRoutesWithSettings(
      RouteSettings settings) {
    return {
      RouteList.addGoal: (context) {
        final args = settings.arguments as Map<String, dynamic>?;
        final oldGoal = args![KeyConstants.editAGoalKey];
        final isEdit = args[KeyConstants.isEditAGoalKey];
        return BlocProvider<CreateGoalBloc>(
            create: (_) => Injector.resolve<CreateGoalBloc>()
              ..add(InitDataCreateGoalEvent(goalEntity: oldGoal)),
            child: CreateAGoalScreen(
              isEdit: isEdit ?? false,
              oldGoal: oldGoal,
            ));
      },
    };
  }
}
