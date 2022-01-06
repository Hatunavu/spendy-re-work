import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/injector/injector.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/blocs/debt_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/debt_screen.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/who_paid_bloc/who_paid_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/new_expense_screen.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/bloc/select_group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/select_group_screen.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/search_screen.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_event.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_image_screen.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_item_image.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_list/transaction_list_screen.dart';

import 'debt/blocs/debt_bloc.dart';

class TransactionRoutes {
  static Map<String, WidgetBuilder> getAll() {
    return {};
  }

  static Map<String, WidgetBuilder> getRoutesWithSettings(RouteSettings settings) {
    return {
      RouteList.personalExpense: (context) {
        final args = settings.arguments as Map<String, dynamic>?;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => Injector.container<NewExpenseBloc>()),
            BlocProvider(
              create: (_) => Injector.container<WhoPaidBloc>()
                ..getParticipants(
                  group: args?[KeyConstants.groupKey],
                  expense: args?[KeyConstants.expenseKey],
                ),
            ),
            BlocProvider(
              create: (_) => Injector.container<ForWhoBloc>()
                ..getParticipants(
                  group: args?[KeyConstants.groupKey],
                  expense: args?[KeyConstants.expenseKey],
                ),
            )
          ],
          child: NewExpenseScreen(
            group: args?[KeyConstants.groupKey],
            expense: args?[KeyConstants.expenseKey],
          ),
        );
      },
      RouteList.showImage: (context) {
        final args = settings.arguments as Map<String, dynamic>;
        final expense = args[KeyConstants.expenseKey];
        return BlocProvider(
            create: (_) => Injector.resolve<ShowExpenseImageBloc>()
              ..add(ShowExpenseImageInitialEvent(expense: expense)),
            child: const ShowImageScreen());
      },
      RouteList.showItemImage: (context) {
        final args = settings.arguments as Map<String, dynamic>;
        final imageUrl = args[KeyConstants.imageUrlKey];
        return ShowItemImage(url: imageUrl);
      },
      RouteList.debt: (context) {
        return BlocProvider<DebtBloc>(
            create: (_) => Injector.resolve<DebtBloc>()..add(DebtInitialEvent()),
            child: DebtScreen());
      },
      RouteList.selectGroup: (context) {
        GroupEntity? group;
        if (settings.arguments != null) {
          final arg = settings.arguments as Map<String, dynamic>;
          group = arg[KeyConstants.groupKey];
        }
        return BlocProvider(
          create: (_) => Injector.resolve<SelectGroupBloc>(),
          child: SelectGroupScreen(
            group: group,
          ),
        );
      },
      RouteList.transactionList: (context) {
        final args = settings.arguments as Map<String, dynamic>?;
        return BlocProvider<TransactionBloc>(
            create: (_) => Injector.resolve<TransactionBloc>()
              ..add(TransactionInitialEvent(args?[KeyConstants.groupKey])),
            child: TransactionListScreen(
              group: args?[KeyConstants.groupKey],
            ));
      },
      RouteList.search: (context) {
        final args = settings.arguments as Map<String, dynamic>?;
        return BlocProvider<SearchBloc>(
            create: (_) => Injector.resolve<SearchBloc>()
              ..add(SearchInitialEvent(group: args?[KeyConstants.groupKey])),
            child: SearchScreen(
              group: args?[KeyConstants.groupKey],
            ));
      }
    };
  }
}
