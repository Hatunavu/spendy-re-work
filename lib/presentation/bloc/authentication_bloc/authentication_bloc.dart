import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/enums/auth_pincode_permission.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/new_expense_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationUseCase authenticationUseCase;
  final ProfileUserUseCase profileUserUseCase;
  final CurrencyUseCase currencyUseCase;
  final LocalNotificationUseCase localNotificationUseCase;
  final CategoriesUseCase categoriesUseCase;
  final ReportUseCase reportUseCase;
  final ExpenseUseCase expenseUseCase;
  final GoalUseCase goalUseCase;
  final LoaderBloc loaderBloc;
  final PushNotificationBloc pushNotificationBloc;
  final NotificationUseCase notificationUseCase;
  final TransactionUseCase transactionUseCase;

  List<CategoryEntity> goalCategory = [];
  List<CategoryEntity> categoryList = [];
  UserEntity? _userEntity;

  UserEntity get userEntity => _userEntity ?? UserEntity();

  set userEntity(UserEntity? user) => _userEntity = user;

  // use for
  AuthPinCodePermission _authPinCodePermission = AuthPinCodePermission.enable;

  set authPinCodePermission(AuthPinCodePermission authPinCodePermission) =>
      _authPinCodePermission = authPinCodePermission;

  AuthenticationBloc(
      {required this.transactionUseCase,
      required this.authenticationUseCase,
      required this.categoriesUseCase,
      required this.currencyUseCase,
      // required this.newExpenseUseCase,
      required this.localNotificationUseCase,
      required this.profileUserUseCase,
      required this.reportUseCase,
      required this.expenseUseCase,
      required this.goalUseCase,
      required this.loaderBloc,
      required this.pushNotificationBloc,
      required this.notificationUseCase})
      : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapCheckAuthToState(event);
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    }
  }

  Stream<AuthenticationState> _mapCheckAuthToState(AuthenticationStarted event) async* {
    yield AuthenticationLoading();
    final bool firstLogin = await authenticationUseCase.getFirstLogin();
    await currencyUseCase.getCurrentCurrency();
    final userId = authenticationUseCase.getUid();
    if (firstLogin && userId.isNotEmpty) {
      _userEntity = await profileUserUseCase.getUserProfile(userId);
      if (_userEntity == null) {
        yield UnAuthenticated(nextRoute: RouteList.loginPhone);
      } else {
        categoryList = await categoriesUseCase.getCategoryListCate(
            _userEntity!.uid!, FirebaseStorageConstants.transactionType);
        goalCategory = await categoriesUseCase.getCategoryListCate(
            _userEntity!.uid!, FirebaseStorageConstants.goalType);
        if (_userEntity!.fullName == null || _userEntity!.fullName!.isEmpty) {
          yield UnAuthenticated(nextRoute: RouteList.createProfile);
        } else {
          currencyUseCase.setDefaultCurrency(isoCode: _userEntity!.isoCode); // default currency
          // check has pin
          yield* _checkHasPINToState();
        }
      }
    } else {
      // authenticated
      currencyUseCase.setDefaultCurrency();
      yield UnAuthenticated(nextRoute: RouteList.loginPhone);
    }
  }

  Stream<AuthenticationState> _checkHasPINToState() async* {
    final hasPin = checkHasPin();
    if (_userEntity?.setting?.security != null &&
        _userEntity!.setting!.security!.isPin! &&
        hasPin!) {
      yield InitAuthenticatePIN(uid: _userEntity!.uid!);
    } else {
      yield Authenticated(uid: _userEntity!.uid!);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    loaderBloc.add(StartLoading());
    yield AuthenticationLoading();
    try {
      // await Injector.resolve<HomeChartDataBloc>().resetBloc();
      pushNotificationBloc.add(LogoutEvent());
      reportUseCase.clearReportData();
      transactionUseCase.clearTransactionData();
      goalUseCase.clear();
      notificationUseCase.clear();
      await authenticationUseCase.logOut();
      await localNotificationUseCase.turnOff();
      _cleanSingletonData();
      yield UnAuthenticated(nextRoute: RouteList.loginPhone);
    } catch (e) {
      yield AuthenticatedFailed();
    }
    loaderBloc.add(FinishLoading());
  }

  Stream<AuthenticationState> _mapLoggedInToState(LoggedIn event) async* {
    yield AuthenticationLoading();
    try {
      pushNotificationBloc.add(LogInEvent());
      _userEntity = event.user;
      currencyUseCase.setDefaultCurrency(isoCode: _userEntity!.isoCode);
      categoryList = await categoriesUseCase.getCategoryListCate(
          _userEntity!.uid!, FirebaseStorageConstants.transactionType);
      goalCategory = await categoriesUseCase.getCategoryListCate(
          _userEntity!.uid!, FirebaseStorageConstants.goalType);
      yield Authenticated(uid: _userEntity!.uid!);
    } catch (e) {
      yield AuthenticatedFailed();
    }
  }

  bool? checkHasPin() => userEntity.setting?.security?.isPin;

  void _cleanSingletonData() {
    _userEntity = null;
    currencyUseCase.cleanCurrency();
    categoryList.clear();
    goalCategory.clear();
  }

  // use when turn off authentication pin code for some external navigation action
  bool checkAuthPinCodeEnable() {
    return _authPinCodePermission == AuthPinCodePermission.enable;
  }

  Future<bool> checkPinAuthIsShowing() async => authenticationUseCase.pinAuthIsShowing();

  Future<void> savePinAuthState(bool isShowing) async =>
      authenticationUseCase.savePinAuthState(isShowing);
}
