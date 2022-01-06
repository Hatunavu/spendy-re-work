import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/who_paid_bloc/who_paid_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/input_money_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/keyboard_avoider/keyboard_avoider.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'list_item_expense_widget.dart';

class BodyNewExpenseWidget extends StatefulWidget {
  final GroupEntity? group;
  final ExpenseEntity? expense;
  const BodyNewExpenseWidget({Key? key, this.group, this.expense}) : super(key: key);

  @override
  _BodyNewExpenseWidgetState createState() => _BodyNewExpenseWidgetState();
}

class _BodyNewExpenseWidgetState extends State<BodyNewExpenseWidget> {
  late NewExpenseBloc _expenseCubit;
  late ForWhoBloc _forWhoBloc;
  late WhoPaidBloc _whoPaidBloc;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final ValueNotifier<List<ParticipantInTransactionEntity>?> _forWhoValue = ValueNotifier([]);
  final ValueNotifier<List<ParticipantInTransactionEntity>?> _whoPaidValue = ValueNotifier([]);
  Timer? _debounce;
  @override
  void initState() {
    _expenseCubit = BlocProvider.of<NewExpenseBloc>(context);
    _expenseCubit.initial(group: widget.group, expenseEntity: widget.expense);
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note ?? '';
      _forWhoValue.value = widget.expense!.forWho;
      _whoPaidValue.value = widget.expense!.whoPaid;
    }
    _forWhoBloc = BlocProvider.of<ForWhoBloc>(context);
    _whoPaidBloc = BlocProvider.of<WhoPaidBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _amountController.dispose();
    _noteController.dispose();
    _whoPaidValue.dispose();
    _forWhoValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return Column(
      children: [
        BlocBuilder<NewExpenseBloc, NewExpenseState>(
          builder: (context, state) {
            return InputMoneyWidget(
              onChanged: _onChangeMoney,
              controller: _amountController,
              currency: state.currency ?? CurrencyEntity(),
            );
          },
        ),
        Expanded(
          child: KeyboardAvoider(
            autoScroll: true,
            child: ListItemExpenseWidget(
              noteController: _noteController,
              forWhoValue: _forWhoValue,
              whoPaidValue: _whoPaidValue,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w).copyWith(bottom: paddingBottom + 18.h),
          child: BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return ButtonWidget.primary(
                color: AppColor.lightPurple.withOpacity(1),
                width: double.infinity,
                title: translate('label.save'),
                onPress: state.isActiveButton ? _onSave : null,
              );
            },
          ),
        )
      ],
    );
  }

  void _onChangeMoney(String value) {
    final money = value.isEmpty ? 0 : int.parse(value.formatCurrencyToString());
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _expenseCubit.updateAmount(money.toString());
      _whoPaidBloc.changedMoney(money);
      _forWhoBloc.changeExpenseMoney(money);
    });
  }

  void _onSave() {
    _expenseCubit.createExpense(int.parse(_amountController.text.formatCurrencyToString()),
        _whoPaidValue.value ?? [], _forWhoValue.value ?? [], _noteController.text);
  }
}
