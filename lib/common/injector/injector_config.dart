import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kiwi/kiwi.dart';
import 'package:spendy_re_work/common/configs/remote_config_default.dart';
import 'package:spendy_re_work/common/data_connection_checker/data_connection_checker.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/common/local_preferences/local_preferences.dart';
import 'package:spendy_re_work/common/network/network_info.dart';
import 'package:spendy_re_work/common/push_notification/push_notification_services.dart';
import 'package:spendy_re_work/common/utils/notification_helpers/local_notify_helper.dart';
import 'package:spendy_re_work/data/datasources/local/auth_local_datasource.dart';
import 'package:spendy_re_work/data/datasources/local/country_phone_code_datasource.dart';
import 'package:spendy_re_work/data/datasources/local/currency_datasource.dart';
import 'package:spendy_re_work/data/datasources/local/expense_local_data_source.dart';
import 'package:spendy_re_work/data/datasources/local/goal_local_data_source.dart';
import 'package:spendy_re_work/data/datasources/remote/auth_firebase_remote_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/category_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/expense_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/filter_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/goal_remote_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/group_remote_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/noti_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/participant_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/remote_config_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/report_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/search_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/storage_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:spendy_re_work/data/datasources/remote/user_remote_datasource.dart';
import 'package:spendy_re_work/data/repositories/app_default_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/authentication_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/category_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/country_phone_code_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/currency_repositpry_impl.dart';
import 'package:spendy_re_work/data/repositories/expense_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/filter_repository.dart';
import 'package:spendy_re_work/data/repositories/goal_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/group_repositorty_impl.dart';
import 'package:spendy_re_work/data/repositories/noti_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/participant_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/report_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/search_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/storage_repository_impl.dart';
import 'package:spendy_re_work/data/repositories/transaction_repository_imlp.dart';
import 'package:spendy_re_work/data/repositories/user_repository_impl.dart';
import 'package:spendy_re_work/domain/repositories/app_default_repository.dart';
import 'package:spendy_re_work/domain/repositories/authentication_repository.dart';
import 'package:spendy_re_work/domain/repositories/category_repository.dart';
import 'package:spendy_re_work/domain/repositories/country_phone_code_repository.dart';
import 'package:spendy_re_work/domain/repositories/currency_repository.dart';
import 'package:spendy_re_work/domain/repositories/expense_repository.dart';
import 'package:spendy_re_work/domain/repositories/filter_repository.dart';
import 'package:spendy_re_work/domain/repositories/goal_repository.dart';
import 'package:spendy_re_work/domain/repositories/group_repository.dart';
import 'package:spendy_re_work/domain/repositories/noti_repository.dart';
import 'package:spendy_re_work/domain/repositories/participant_repository.dart';
import 'package:spendy_re_work/domain/repositories/report_repository.dart';
import 'package:spendy_re_work/domain/repositories/search_repository.dart';
import 'package:spendy_re_work/domain/repositories/storage_repository.dart';
import 'package:spendy_re_work/domain/repositories/transaction_repository.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/domain/repositories/user_repository.dart';
import 'package:spendy_re_work/domain/usecases/app_default_usecase.dart';
import 'package:spendy_re_work/domain/usecases/authentication_usecase.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/country_phone_code_usecase.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/date_usecase.dart';
import 'package:spendy_re_work/domain/usecases/debt_usecase.dart';
import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
import 'package:spendy_re_work/domain/usecases/filter_usecase.dart';
import 'package:spendy_re_work/domain/usecases/goal_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/domain/usecases/home_usecase.dart';
import 'package:spendy_re_work/domain/usecases/local_notification_usecase.dart';
import 'package:spendy_re_work/domain/usecases/noti_usecase.dart';
import 'package:spendy_re_work/domain/usecases/profile_user_usecase.dart';
import 'package:spendy_re_work/domain/usecases/report_usecase.dart';
import 'package:spendy_re_work/domain/usecases/search_usecase.dart';
import 'package:spendy_re_work/domain/usecases/settle_debt_usecase.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/avatar_bloc/avatar_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/event_bus_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/language_bloc/language_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/loader_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/notification_manager_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/notification_manager_bloc/notification_manager_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/push_notification_bloc/push_notification_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/bloc/unread_notification_bloc/unread_notification_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_option/bloc/filter_bloc.dart';
import 'package:spendy_re_work/presentation/journey/filter/filter_result/bloc/filter_result_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/create_goal/create_goal_bloc/create_goal_bloc.dart';
import 'package:spendy_re_work/presentation/journey/goal/goal_list/goal_list_bloc/goal_list_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/bottom_tab_bloc/bottom_tab_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/home_bloc/home_bloc.dart';
import 'package:spendy_re_work/presentation/journey/home/notification/noti_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/login_bloc/login_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/phone_country_bloc/phone_country_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/validator_bloc/validator_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/create_pin/bloc/create_pin_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/device_pin/enter_pin/bloc/enter_pin_bloc.dart';
import 'package:spendy_re_work/presentation/journey/login/profile/bloc/profile_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/bloc/choose_currency_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_cubit.dart';
import 'package:spendy_re_work/presentation/journey/personal/notification_menu/bloc/notify_settings_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/payments/bloc/payments_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/security_menu/bloc/security_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/user_bloc/user_settings_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_data_bloc/report_data_bloc.dart';
import 'package:spendy_re_work/presentation/journey/report/blocs/report_navigator_bloc/report_navigator_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_blocs/transaction_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/blocs/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/debt/blocs/debt_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/who_paid_bloc/who_paid_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/bloc/select_group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/search/bloc/search_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_recent/widgets/home_chart/chart_data_bloc/home_chart_data_bloc.dart';

part 'injector_config.g.dart';

abstract class InjectorConfig {
  static KiwiContainer? container;

  static void setup({bool forTest = false}) {
    //KiwiContainer container = KiwiContainer();
    final injector = _$InjectorConfig();
    if (forTest) {
      injector._configureMock();
      return;
    }
    injector._configure();
  }

  void _configure() {
    _configureAppModule();
  }

  void _configureMock() {}

  void _configureAppModule() {
    _configureBlocs();
    _configureUsecases();
    _configureRepositories();
    _configureDataSources();
    _configureExternal();
    _configureCommon();
  }

// ============ BLOCS ============
  @Register.singleton(SnackbarBloc)
  @Register.singleton(LoaderBloc)
  @Register.singleton(LanguageBloc)
  @Register.singleton(EventBusBloc)
  @Register.factory(WhoPaidBloc)
  @Register.factory(ForWhoBloc)
  @Register.singleton(AuthenticationBloc)
  @Register.singleton(LoginBloc)
  @Register.singleton(VerifyOtpBloc)
  @Register.singleton(PushNotificationBloc)
  @Register.singleton(NotificationManagerBloc)
  @Register.factory(CreateGroupCubit)
  @Register.factory(PhoneCountryBloc)
  @Register.factory(NewExpenseBloc)
  @Register.factory(PaymentsBloc)
  @Register.factory(CreatePinBloc)
  @Register.factory(EnterPinBloc)
  @Register.factory(UserSettingsBloc)
  @Register.factory(GoalListBloc)
  @Register.factory(FilterBloc)
  @Register.factory(ReportNavigatorBloc)
  @Register.factory(SearchBloc)
  @Register.factory(ValidatorBloc)
  @Register.factory(ProfileBloc)
  @Register.factory(NotificationBloc)
  @Register.factory(DebtBloc)
  @Register.factory(HomeBloc)
  @Register.singleton(BottomTabBloc)
  @Register.factory(AvatarBloc)
  @Register.factory(HomeChartDataBloc)
  @Register.factory(TransactionBloc)
  @Register.factory(ReportDataBloc)
  @Register.factory(FilterResultBloc)
  @Register.factory(SecurityBloc)
  @Register.factory(NotifySettingsBloc)
  @Register.factory(TransactionDetailBloc)
  @Register.factory(ShowExpenseImageBloc)
  @Register.singleton(GroupBloc)
  @Register.singleton(UnreadNotificationBloc)
  @Register.factory(ChooseCurrencyBloc)
  @Register.factory(SelectGroupBloc)
  @Register.factory(CreateGoalBloc)
  void _configureBlocs();

// ============ USECASES ============
//   @Register.factory(UserUseCase)
  @Register.singleton(CurrencyUseCase)
  @Register.singleton(ExpenseUseCase)
  // @Register.singleton(NewExpenseUseCase)
  @Register.singleton(AuthenticationUseCase)
  @Register.singleton(ProfileUserUseCase)
  @Register.singleton(CountryPhoneCodeUseCase)
  @Register.singleton(CategoriesUseCase)
  // @Register.singleton(ParticipantUseCase)
  @Register.singleton(DateUseCase)
  @Register.singleton(FilterUseCase)
  @Register.singleton(ReportUseCase)
  @Register.singleton(SearchUseCase)
  @Register.singleton(NotificationUseCase)
  @Register.singleton(SettleDebtUseCase)
  @Register.singleton(HomeUseCase)
  @Register.singleton(DebtUseCase)
  @Register.singleton(LocalNotificationUseCase)
  @Register.singleton(StorageUseCase)
  @Register.singleton(AppDefaultUsecase)
  @Register.singleton(GroupUseCase)
  @Register.singleton(GoalUseCase)
  @Register.factory(TransactionUseCase)
  void _configureUsecases();

// ============ REPOSITORIES ============
  @Register.singleton(CurrencyRepository, from: CurrencyRepositoryImpl)
  @Register.singleton(ExpenseRepository, from: ExpenseRepositoryImpl)
  @Register.singleton(AuthenticationRepository, from: AuthenticationRepositoryImpl)
  @Register.singleton(UserRepository, from: UserRepositoryImpl)
  @Register.singleton(CountryPhoneCodeRepository, from: CountryPhoneCodeRepositoryImpl)
  @Register.factory(TransactionRepository, from: TransactionRepositoryImpl)
  @Register.singleton(ParticipantRepository, from: ParticipantRepositoryImpl)
  @Register.singleton(CategoryRepository, from: CategoryRepositoryImpl)
  @Register.singleton(SearchRepository, from: SearchRepositoryImpl)
  @Register.singleton(NotificationRepository, from: NotificationRepositoryImpl)
  @Register.singleton(StorageRepository, from: StorageRepositoryImpl)
  @Register.singleton(FilterRepository, from: FilterRepositoryImpl)
  @Register.singleton(ReportRepository, from: ReportRepositoryImpl)
  @Register.singleton(AppDefaultRepository, from: AppDefaultRepositoryImpl)
  @Register.singleton(GroupRepository, from: GroupRepositoryImpl)
  @Register.singleton(GoalRepository, from: GoalRepositoryImpl)
  void _configureRepositories();

// ============ DATASOURCES ============
//   @Register.factory(UserRemoteDataSource)
  @Register.singleton(CurrencyDataSource)
  @Register.singleton(ExpenseDataSource)
  @Register.singleton(FirebaseAuthRemoteDataSource)
  @Register.singleton(UserRemoteDataSource)
  @Register.singleton(AuthLocalDataSource)
  @Register.singleton(CountryPhoneCodeDataSource)
  @Register.factory(TransactionRemoteDataSource)
  @Register.singleton(ParticipantDataSource)
  @Register.singleton(CategoryDataSource)
  @Register.singleton(SearchDataSource)
  @Register.singleton(NotificationDataSource)
  @Register.singleton(StorageDataSource)
  @Register.singleton(FilterDataSource)
  @Register.singleton(ReportDataSource)
  @Register.singleton(ExpenseLocalDataSource)
  @Register.singleton(GoalLocalDataSource)
  @Register.singleton(GroupRemoteDataSource)
  @Register.singleton(RemoteConfigDataSource)
  @Register.singleton(GoalRemoteDataSource)
  void _configureDataSources();

// ============ EXTERNAL ============
  @Register.singleton(DataConnectionChecker)
  @Register.singleton(FlutterSecureStorage)
  @Register.singleton(FlutterLocalNotificationsPlugin)
  void _configureExternal();

// ============ COMMON ============
  @Register.singleton(LocalPreferences)
  @Register.singleton(SetupFirebaseDatabase)
  @Register.singleton(LocalNotifyHelper, from: LocalNotifyHelperImpl)
  @Register.singleton(NetworkInfo, from: NetworkInfoImpl)
  @Register.singleton(RemoteConfigDefault)
  @Register.singleton(PushNotificationService)
  void _configureCommon();
}
