import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spendy_re_work/common/constants/goal_contants.dart';
import 'package:spendy_re_work/common/enums/data_state.dart';
import 'package:spendy_re_work/common/enums/goal_duration_type.dart';
import 'package:spendy_re_work/common/enums/notification_enum/notification_type.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/common/utils/internet_util.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/domain/entities/goal_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/common/extensions/string_extensions.dart';
import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/snackbar_type.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_constants.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_event.dart';

part 'create_goal_event.dart';

part 'create_goal_state.dart';

class CreateGoalBloc extends Bloc<CreateGoalEvent, CreateGoalState> {
  final CategoriesUseCase categoriesUseCase;
  final GoalUseCase goalUseCase;
  final CurrencyUseCase currencyUseCase;
  final AuthenticationBloc authenticationBloc;
  final NotificationUseCase notificationUseCase;
  final LocalNotificationUseCase localNotificationUseCase;
  final NotificationBloc notificationBloc;
  final SnackbarBloc snackbarBloc;
  final LoaderBloc loaderBloc;

  CreateGoalBloc(
      {required this.categoriesUseCase,
      required this.goalUseCase,
      required this.currencyUseCase,
      required this.localNotificationUseCase,
      required this.notificationUseCase,
      required this.authenticationBloc,
      required this.notificationBloc,
      required this.snackbarBloc,
      required this.loaderBloc})
      : super(CreateGoalInitial());

  static const _defaultAmountMonths = 9.0;
  static const _defaultAchieved = false;
  static const _defaultValidate = false;
  static const _defaultMoney = 0;
  static const _defaulAerageMoney = 0;

  bool? isEdit = false;
  UserEntity? _userEntity;
  CurrencyEntity? _currency;
  List<CurrencyEntity> currencies = [];

  bool? isGoalAchieved; // achieved
  String? note; // remarks,
  String? goalId;

  int? amountPerMonth; // amountPerMonth
  int? createAt = DateTime.now().millisecondsSinceEpoch;
  bool? isValidate;

  /// REWORK
  GoalDurationType _durationType = GoalDurationType.aMonth;
  List<CategoryEntity>? _categories = [];
  CategoryEntity? cateSelected;
  String? goalName;
  int? money; // amount
  double? amountOfTime;
  DateTime date = DateTime.now(); // date
  int? expiredDate; // expiredDate

  @override
  Stream<CreateGoalState> mapEventToState(
    CreateGoalEvent event,
  ) async* {
    switch (event.runtimeType) {
      case InitDataCreateGoalEvent:
        yield* _mapInitDataToState(event as InitDataCreateGoalEvent);
        break;
      case CategoryChangeEvent:
        yield* _mapCateChangeEventToState(event as CategoryChangeEvent);
        break;
      case GoalDurationChangeEvent:
        yield* _mapGoalDurationChangeEventToState(
            event as GoalDurationChangeEvent);
        break;
      case MoneyChangeEvent:
        yield* _mapMoneyChangeEventToState(event as MoneyChangeEvent);
        break;
      case GoalAchievedChangeEvent:
        yield* _mapGoalAchievedChangeEventToState(
            event as GoalAchievedChangeEvent);
        break;
      case GoalNameChangeEvent:
        yield* _mapGoalGoalNameChangeEventToState(event as GoalNameChangeEvent);
        break;
      case NoteTextChangeEvent:
        _listenChangeNote(event as NoteTextChangeEvent);
        break;
      case OnPressedSaveEvent:
        yield* _mapCreateGoalEventToState(event as OnPressedSaveEvent);
        break;
      case OnPressedDeleteEvent:
        yield* _mapOnPressedDeleteToState(event as OnPressedDeleteEvent);
        break;
      case SelectDateEvent:
        yield* _mapSelectDateEventToState(event as SelectDateEvent);
        break;
    }
  }

  Stream<CreateGoalState> _mapSelectDateEventToState(
      SelectDateEvent event) async* {
    final currentState = state;
    date = event.date;
    expiredDate = goalUseCase.getExpiredDate(
        date: date.millisecondsSinceEpoch, durationType: _durationType);
    isGoalAchieved = goalUseCase.checkAchieved(
        today: DateTime.now().intYmd, expiredDate: expiredDate);

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(date: date, isGoalAchieved: isGoalAchieved);
    }
  }

  void _listenChangeNote(NoteTextChangeEvent event) {
    note = event.note;
  }

  Future<void> _initCreateData() async {
    _currency = await currencyUseCase.getCurrency(
        currencies: currencies, isoCode: _userEntity?.isoCode);
    isGoalAchieved = false;
    // dateTimeGoal = DateTime.now().addMonth(value: 9);
    amountOfTime = _defaultAmountMonths;
    amountPerMonth = _defaulAerageMoney;
    isValidate = _defaultValidate;
    isGoalAchieved = _defaultAchieved;
    expiredDate = goalUseCase.getExpiredDate(
        date: date.millisecondsSinceEpoch, durationType: _durationType);
  }

  Future<void> _initEditData(GoalEntity goal) async {
    isEdit = true;
    final category = await categoriesUseCase.getCategoryByName(
        categoryList: _categories, currentCategoryName: goal.category);
    if (currencyUseCase.currencies.isEmpty) {
      await currencyUseCase.getCurrentCurrency();
    }
    _currency = await currencyUseCase.getCurrency(
        currencies: currencies, isoCode: goal.isoCode);
    note = goal.remarks ?? '';
    goalId = goal.id;
    goalName = goal.name;
    money = goal.amount;
    isGoalAchieved = goal.achieved;
    cateSelected = category;
    _durationType = goalDurationTypeMap[goal.duration]!;
    expiredDate = goalUseCase.getExpiredDate(
        date: date.millisecondsSinceEpoch, durationType: _durationType);
    date = DateTime.fromMillisecondsSinceEpoch(goal.date!);
    amountPerMonth = goalUseCase.getAmountPerMonth(
        amount: money, durationType: _durationType);
    isValidate = true;
  }

  Stream<CreateGoalState> _mapInitDataToState(
      InitDataCreateGoalEvent event) async* {
    yield CreateGoalLoading();
    try {
      currencies = await currencyUseCase.getAllCurrencies();
      _categories = authenticationBloc.goalCategory;
      _userEntity = authenticationBloc.userEntity;

      if (event.goalEntity == null) {
        // create new goal
        await _initCreateData();
      } else {
        // edit exist goal
        await _initEditData(event.goalEntity!);
      }
      yield CreateGoalInitializedData(
          durationType: _durationType,
          isValidate: isValidate,
          categories: _categories,
          currencyEntity: _currency,
          category: cateSelected,
          note: note,
          nameGoal: goalName,
          money: money?.toString(),
          amountOfTime: amountOfTime,
          isGoalAchieved: isGoalAchieved,
          amountPerMonth: amountPerMonth,
          date: date,
          expiredDate: expiredDate,
          crudState: DataState.none);
    } catch (e) {
      yield CreateGoalLoadDataFailed();
    }
  }

  Stream<CreateGoalState> _mapCateChangeEventToState(
      CategoryChangeEvent event) async* {
    final currentState = state;
    cateSelected = event.selectCategory;
    _validate();

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(
          cateSelected: event.selectCategory, isValidate: isValidate);
    }
  }

  Stream<CreateGoalState> _mapGoalDurationChangeEventToState(
      GoalDurationChangeEvent event) async* {
    final currentState = state;
    _durationType = event.durationType;
    expiredDate = goalUseCase.getExpiredDate(
        date: date.millisecondsSinceEpoch, durationType: _durationType);
    isGoalAchieved = goalUseCase.checkAchieved(
        today: DateTime.now().intYmd, expiredDate: expiredDate);
    if (money == null) {
      amountPerMonth = goalUseCase.getAmountPerMonth(
          amount: _defaultMoney, durationType: _durationType);
    } else {
      amountPerMonth = goalUseCase.getAmountPerMonth(
          amount: money, durationType: _durationType);
    }

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(
          durationType: _durationType,
          date: date,
          amountPerMonth: amountPerMonth,
          amountOfTime: amountOfTime,
          isGoalAchieved: isGoalAchieved);
    }
  }

  Stream<CreateGoalState> _mapMoneyChangeEventToState(
      MoneyChangeEvent event) async* {
    final currentState = state;
//    print(event.money);
    final tempMoneyString = event.money.formatCurrencyToString();

    if (tempMoneyString.isAllNumeric) {
      money = int.parse(tempMoneyString);
      amountPerMonth = goalUseCase.getAmountPerMonth(
          amount: money, durationType: _durationType);
    } else {
      money = null;
      amountPerMonth = goalUseCase.getAmountPerMonth(
          amount: _defaultMoney, durationType: _durationType);
    }

    _validate();

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(
          amountPerMonth: amountPerMonth, isValidate: isValidate);
    }
  }

  Stream<CreateGoalState> _mapGoalAchievedChangeEventToState(
      GoalAchievedChangeEvent event) async* {
    final currentState = state;
    isGoalAchieved = event.isGoalAchieved;
    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(isGoalAchieved: isGoalAchieved);
    }
  }

  Stream<CreateGoalState> _mapGoalGoalNameChangeEventToState(
      GoalNameChangeEvent event) async* {
    final currentState = state;
    goalName = event.name;

    _validate();

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(
          isGoalAchieved: isGoalAchieved, isValidate: isValidate);
    }
  }

  Stream<CreateGoalState> _mapCreateGoalEventToState(
      OnPressedSaveEvent event) async* {
    final currentState = state;
    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(crudState: DataState.loading);
      loaderBloc.add(StartLoading());
      final goalEntity = GoalEntity(
        id: goalId,
        name: goalName,
        isoCode: _currency?.isoCode,
        date: date.millisecondsSinceEpoch,
        expiredDate: expiredDate,
        category: cateSelected?.name,
        progressColor: cateSelected?.color?.value.toRadixString(16),
        amount: money,
        amountPerMonth: amountPerMonth,
        duration: keyGoalDurationTypeMap[_durationType],
        remarks: note ?? '',
        achieved: isGoalAchieved,
        createAt: DateTime.now().millisecondsSinceEpoch,
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      );

      if (event.isEdit) {
        yield* _updateAGoal(goalEntity);
      } else {
        yield* _createAGoal(goalEntity);
      }
    }
  }

  Stream<CreateGoalState> _updateAGoal(GoalEntity goalEntity) async* {
    final connectivityResult = await InternetUtil.checkInternetConnection();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        if (goalEntity.achieved! &&
            date.millisecondsSinceEpoch < goalEntity.expiredDate!) {
          notificationBloc.add(DeleteGoalNotiEvent(goalID: goalEntity.id));
        }
        await goalUseCase.updateGoal(uid: _userEntity!.uid, goal: goalEntity);
        final currentState = state;
        if (currentState is CreateGoalInitializedData) {
          if (currentState.expiredDate != goalEntity.expiredDate) {
            notificationBloc.add(UpdateGoalNotificationEvent(
                goalEntity.id!, goalEntity.expiredDate!));
          }
        }
        yield CreateGoalSuccess(goalEntity, cateSelected!);
      } catch (e) {
        debugPrint('CreateGoalBloc - _updateAGoal: $e');
        yield CreateGoalFailed();
      }
    } else {
      snackbarBloc.add(ShowSnackbar(
          title: CreateGoalConstants.noInternet, type: SnackBarType.error));
    }
    loaderBloc.add(FinishLoading());
  }

  Stream<CreateGoalState> _createAGoal(GoalEntity goalEntity) async* {
    final connect = await InternetUtil.checkInternetConnection();
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      try {
        final String? goalID = await goalUseCase.createGoal(
            uid: _userEntity!.uid, goal: goalEntity);
        notificationBloc.add(CreateNotificationEvent(
            createTime: DateTime.now().millisecondsSinceEpoch,
            goalId: goalID,
            categoryName: goalEntity.category,
            showTime: goalEntity.expiredDate,
            type: NotiType.goal));
        yield CreateGoalSuccess(goalEntity, cateSelected!);
      } catch (e) {
        yield CreateGoalFailed();
      }
    } else {
      snackbarBloc.add(ShowSnackbar(
          title: 'No internet connection', type: SnackBarType.error));
    }
    loaderBloc.add(FinishLoading());
  }

  Stream<CreateGoalState> _mapOnPressedDeleteToState(
      OnPressedDeleteEvent event) async* {
    final currentState = state;

    if (currentState is CreateGoalInitializedData) {
      yield currentState.copyWith(crudState: DataState.loading);
      final goalEntity = event.goalEntity;
      final user = authenticationBloc.userEntity;

      try {
        await goalUseCase.removeGoal(uid: user.uid, goalID: goalEntity.id);
        // if (removeGoal) {
        //   await notificationUseCase.removeNotificationByType(
        //       _userEntity.uid, NotificationConstants.goalType,
        //       typeID: goalEntity.id);
        //
        //   await localNotificationUseCase
        //       .cancelALocalNotification(goalEntity.id); // cancel notification
        //
        //   yield CreateGoalSuccess(event.goalEntity, cateSelected);
        // } else {
        //   yield CreateGoalFailed();
        // }
        yield CreateGoalSuccess(goalEntity, cateSelected!);
      } catch (e) {
        yield CreateGoalFailed();
      }
    }
  }

  void _validate() {
    if (cateSelected == null ||
        goalName == null ||
        goalName!.isEmpty ||
        money == null) {
      isValidate = false;
    } else {
      isValidate = true;
    }
  }
}
