import 'package:spendy_re_work/common/mixin/base_equatable_mixin.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/button_state.dart';

abstract class PersonalExpenseState extends Equatable {
  final CurrencyEntity? currencyEntity;
  final CategoryEntity? category;
  final ButtonState? buttonState;
  final ButtonState? shareSpendButtonState;
  final int? imageCount;
  final DateTime? spendTime;
  final String? strSpend;
  final String? note;
  final List<CategoryEntity>? categories;
  final ParticipantInTransactionEntity? currentWhoPaid;
  final ParticipantInTransactionEntity? currentForWho;

  PersonalExpenseState(
      this.currencyEntity,
      this.category,
      this.buttonState,
      this.shareSpendButtonState,
      this.imageCount,
      this.spendTime,
      this.strSpend,
      this.categories,
      this.note,
      this.currentForWho,
      this.currentWhoPaid);

  @override
  List<Object?> get props => [
        currencyEntity,
        category,
        buttonState,
        shareSpendButtonState,
        imageCount,
        spendTime,
        strSpend,
        categories,
        note,
        currentForWho,
        currentWhoPaid,
      ];
}

class PersonalExpenseInitialState extends PersonalExpenseState {
  final bool isChange;

  PersonalExpenseInitialState(
      {CurrencyEntity? currencyEntity,
      CategoryEntity? category,
      ButtonState? buttonState,
      ButtonState? shareSpendButtonState,
      int? imageCount,
      DateTime? spendTime,
      List<CategoryEntity>? categories,
      String? strSpend,
      String? note,
      ParticipantInTransactionEntity? currentForWho,
      ParticipantInTransactionEntity? currentWhoPaid,
      this.isChange = true})
      : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  PersonalExpenseInitialState copyWith({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    List<CategoryEntity>? categories,
    String? strSpend,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) {
    return PersonalExpenseInitialState(
      currencyEntity: currencyEntity ?? this.currencyEntity,
      category: category ?? this.category,
      buttonState: buttonState ?? this.buttonState,
      shareSpendButtonState:
          shareSpendButtonState ?? this.shareSpendButtonState,
      imageCount: imageCount ?? this.imageCount,
      categories: categories ?? this.categories,
      spendTime: spendTime ?? this.spendTime,
      strSpend: strSpend.toString(),
      note: note ?? this.note,
      isChange: !isChange,
      currentForWho: currentForWho ?? this.currentForWho,
      currentWhoPaid: currentWhoPaid ?? this.currentWhoPaid,
    );
  }

  @override
  List<Object?> get props => [
        isChange,
        currencyEntity,
        category,
        buttonState,
        shareSpendButtonState,
        imageCount,
        spendTime,
        strSpend,
        categories,
        note,
        currentForWho,
        currentWhoPaid
      ];
}

class PersonalExpenseLoadingState extends PersonalExpenseState {
  PersonalExpenseLoadingState({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    List<CategoryEntity>? categories,
    String? strSpend,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}

class CreatePersonalExpenseWaitingState extends PersonalExpenseState {
  CreatePersonalExpenseWaitingState({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    List<CategoryEntity>? categories,
    String? strSpend,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}

class CreatePersonalExpenseSuccessState extends PersonalExpenseState {
  CreatePersonalExpenseSuccessState({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    List<CategoryEntity>? categories,
    String? strSpend,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}

class PushToWhoPaidState extends PersonalExpenseState {
  final Map<String, ParticipantInTransactionEntity> whoPaidMap;
  final Map<String, ParticipantInTransactionEntity> forWhoMap;

  PushToWhoPaidState({
    required this.whoPaidMap,
    required this.forWhoMap,
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    String? strSpend,
    List<CategoryEntity>? categories,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}

class GetParticipantState extends PersonalExpenseState {
  GetParticipantState({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    String? strSpend,
    List<CategoryEntity>? categories,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}

class PersonalExpenseActionFailure extends PersonalExpenseState {
  PersonalExpenseActionFailure({
    CurrencyEntity? currencyEntity,
    CategoryEntity? category,
    ButtonState? buttonState,
    ButtonState? shareSpendButtonState,
    int? imageCount,
    DateTime? spendTime,
    String? strSpend,
    List<CategoryEntity>? categories,
    String? note,
    ParticipantInTransactionEntity? currentForWho,
    ParticipantInTransactionEntity? currentWhoPaid,
  }) : super(
            currencyEntity,
            category,
            buttonState,
            shareSpendButtonState,
            imageCount,
            spendTime,
            strSpend,
            categories,
            note,
            currentForWho,
            currentWhoPaid);

  @override
  List<Object> get props => [];
}
