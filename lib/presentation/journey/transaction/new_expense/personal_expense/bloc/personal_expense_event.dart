import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transacstion_args_route.dart';

abstract class PersonalExpenseEvent extends Equatable {}

class PersonalExpenseInitialEvent extends PersonalExpenseEvent {
  final String? previousRoute;
  final bool? isEdit;
  final ExpenseEntity? currentExpense;

  final bool? isCreateDebt;
  final CreateADebtArgument? createADebtArgument;

  PersonalExpenseInitialEvent({
    this.previousRoute,
    this.currentExpense,
    this.isCreateDebt,
    this.createADebtArgument,
    this.isEdit = false,
  });

  @override
  List<Object?> get props => [
        previousRoute,
        currentExpense,
        isCreateDebt,
        createADebtArgument,
        isEdit
      ];
}

class SelectCategoryEvent extends PersonalExpenseEvent {
  final CategoryEntity category;

  SelectCategoryEvent({required this.category});

  @override
  List<Object> get props => [];
}

class SwitchTodayAndYesterdayEvent extends PersonalExpenseEvent {
  SwitchTodayAndYesterdayEvent();

  @override
  List<Object> get props => [];
}

class CreatePersonalExpenseEvent extends PersonalExpenseEvent {
  final String spend;
  final String note;

  CreatePersonalExpenseEvent({required this.spend, required this.note});

  @override
  List<Object> get props => [spend, note];
}

class CheckSpendEmptyEvent extends PersonalExpenseEvent {
  final String spend;

  CheckSpendEmptyEvent({required this.spend});

  @override
  List<Object> get props => [spend];
}

class OpenCameraEvent extends PersonalExpenseEvent {
  @override
  List<Object> get props => [];
}

class OpenGalleryEvent extends PersonalExpenseEvent {
  @override
  List<Object> get props => [];
}

class ChangeDateTimeEvent extends PersonalExpenseEvent {
  final DateTime? selectDateTime;

  ChangeDateTimeEvent({this.selectDateTime});

  @override
  List<Object?> get props => [selectDateTime];
}

class ChangeNoteTextEvent extends PersonalExpenseEvent {
  final String note;

  ChangeNoteTextEvent(this.note);

  @override
  List<Object> get props => throw UnimplementedError();
}

class PushToWhoPaidEvent extends PersonalExpenseEvent {
  PushToWhoPaidEvent();

  @override
  List<Object> get props => [];
}

class UpdateStatePersonalExpenseEvent extends PersonalExpenseEvent {
  @override
  List<Object> get props => [];
}
