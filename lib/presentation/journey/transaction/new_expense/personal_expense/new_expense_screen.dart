import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/body_new_expense_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';

import '../new_expense_constants.dart';

class NewExpenseScreen extends StatelessWidget {
  final GroupEntity? group;
  final ExpenseEntity? expense;

  const NewExpenseScreen({Key? key, this.group, this.expense})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<NewExpenseBloc, NewExpenseState>(
      listener: (context, state) {
        if (state.status == NewExpenseStatus.loading) {
          LoaderWalletDialog.getInstance().show(context);
        } else if (state.status == NewExpenseStatus.success) {
          LoaderWalletDialog.getInstance().hide(context);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarNormalWidget(
            colorBackground: const Color(0xff7077EA),
            title: NewExpenseConstants.personalExpenseTitle,
            colorTitle: AppColor.white,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                IconConstants.backIcon,
                height: LayoutConstants.dimen_18,
                color: AppColor.white,
              ),
            ),
          ),
          body: BodyNewExpenseWidget(
            group: group,
            expense: expense,
          )),
    );
  }
}
