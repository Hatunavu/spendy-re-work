import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';

enum NewExpenseStatus { initial, initiating, initiated, loading, success, failed }

class NewExpenseState extends Equatable {
  final NewExpenseStatus status;
  final GroupEntity? groupSelected;
  final CurrencyEntity? currency;
  final List<CategoryEntity> categories;
  final CategoryEntity? categorySelected;
  final bool isPersonal;
  final bool isActiveButton;
  final DateTime currentDateTime;
  final int? imageCount;
  final String? amount;

  NewExpenseState({
    required this.status,
    this.groupSelected,
    this.currency,
    required this.categories,
    this.categorySelected,
    required this.isPersonal,
    required this.isActiveButton,
    required this.currentDateTime,
    this.imageCount,
    this.amount,
  });

  factory NewExpenseState.initial() => NewExpenseState(
        status: NewExpenseStatus.initial,
        categories: const [],
        isPersonal: false,
        isActiveButton: false,
        currentDateTime: DateTime.now().dateTimeYmd,
      );

  NewExpenseState copyWith({
    NewExpenseStatus? status,
    GroupEntity? groupSelected,
    bool? isPersonal,
    CurrencyEntity? currency,
    List<CategoryEntity>? categories,
    CategoryEntity? categorySelected,
    bool? isActiveButton,
    DateTime? currentDateTime,
    int? imageCount,
    bool forceClearGroup = false,
    String? amount,
  }) =>
      NewExpenseState(
        status: status ?? this.status,
        groupSelected: groupSelected ?? (forceClearGroup ? null : this.groupSelected),
        currency: currency ?? this.currency,
        categories: categories ?? this.categories,
        categorySelected: categorySelected ?? this.categorySelected,
        isPersonal: isPersonal ?? this.isPersonal,
        isActiveButton: isActiveButton ?? this.isActiveButton,
        currentDateTime: currentDateTime ?? this.currentDateTime,
        imageCount: imageCount ?? this.imageCount,
        amount: amount ?? this.amount,
      );

  @override
  List<Object?> get props => [
        status,
        groupSelected,
        currency,
        categories,
        categorySelected,
        isPersonal,
        currentDateTime,
        imageCount,
        isActiveButton,
        amount,
      ];
}
