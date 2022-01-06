import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_cubit.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/create_group_screen.dart';

class GroupMenuRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {};
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    return {
      RouteList.createGroup: (_) {
        return BlocProvider<CreateGroupCubit>(
          create: (context) => Injector.resolve<CreateGroupCubit>()..initGroupData(args?['group']),
          child: CreateGroupScreen(),
        );
      }
    };
  }
}
