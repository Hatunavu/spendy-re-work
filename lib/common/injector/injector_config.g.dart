// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector_config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureBlocs() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => SnackbarBloc())
      ..registerSingleton((c) => LoaderBloc())
      ..registerSingleton((c) => LanguageBloc())
      ..registerSingleton((c) => EventBusBloc())
      ..registerFactory((c) => WhoPaidBloc(
          groupUseCase: c<GroupUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          currencyUseCase: c<CurrencyUseCase>(),
          eventBusBloc: c<EventBusBloc>()))
      ..registerFactory((c) => ForWhoBloc(
          groupUseCase: c<GroupUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          currencyUseCase: c<CurrencyUseCase>(),
          eventBusBloc: c<EventBusBloc>()))
      ..registerSingleton((c) => AuthenticationBloc(
          transactionUseCase: c<TransactionUseCase>(),
          authenticationUseCase: c<AuthenticationUseCase>(),
          categoriesUseCase: c<CategoriesUseCase>(),
          currencyUseCase: c<CurrencyUseCase>(),
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          profileUserUseCase: c<ProfileUserUseCase>(),
          reportUseCase: c<ReportUseCase>(),
          expenseUseCase: c<ExpenseUseCase>(),
          goalUseCase: c<GoalUseCase>(),
          loaderBloc: c<LoaderBloc>(),
          pushNotificationBloc: c<PushNotificationBloc>(),
          notificationUseCase: c<NotificationUseCase>()))
      ..registerSingleton(
          (c) => LoginBloc(c<VerifyOtpBloc>(), c<AuthenticationUseCase>()))
      ..registerSingleton((c) => VerifyOtpBloc(
          c<AuthenticationBloc>(),
          c<AuthenticationUseCase>(),
          c<LocalPreferences>(),
          c<GroupUseCase>(),
          c<AppDefaultUsecase>()))
      ..registerSingleton(
          (c) => PushNotificationBloc(c<PushNotificationService>()))
      ..registerSingleton((c) => NotificationManagerBloc(
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          notificationBloc: c<NotificationBloc>()))
      ..registerFactory((c) => CreateGroupCubit(
          groupBloc: c<GroupBloc>(),
          groupUseCase: c<GroupUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          eventBusBloc: c<EventBusBloc>()))
      ..registerFactory((c) => PhoneCountryBloc(c<CountryPhoneCodeUseCase>()))
      ..registerFactory((c) => NewExpenseBloc(
          currencyUseCase: c<CurrencyUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          categoriesUseCase: c<CategoriesUseCase>(),
          groupUseCase: c<GroupUseCase>(),
          transactionUseCase: c<TransactionUseCase>(),
          storageUseCase: c<StorageUseCase>(),
          groupBloc: c<GroupBloc>()))
      ..registerFactory((c) => PaymentsBloc())
      ..registerFactory((c) => CreatePinBloc(
          authenticationUseCase: c<AuthenticationUseCase>(),
          profileUserUseCase: c<ProfileUserUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => EnterPinBloc(
          authenticationUseCase: c<AuthenticationUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          profileUserUseCase: c<ProfileUserUseCase>()))
      ..registerFactory((c) => UserSettingsBloc(
          profileUserUseCase: c<ProfileUserUseCase>(),
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => GoalListBloc(
          authenticationBloc: c<AuthenticationBloc>(),
          goalUseCase: c<GoalUseCase>(),
          currencyUseCase: c<CurrencyUseCase>(),
          searchUseCase: c<SearchUseCase>(),
          loaderBloc: c<LoaderBloc>(),
          notificationBloc: c<NotificationBloc>()))
      ..registerFactory((c) => FilterBloc(
          categoriesUseCase: c<CategoriesUseCase>(),
          dateUseCase: c<DateUseCase>(),
          filterUseCase: c<FilterUseCase>(),
          authBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => ReportNavigatorBloc())
      ..registerFactory((c) => SearchBloc(
          searchUseCase: c<SearchUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          transactionUseCase: c<TransactionUseCase>()))
      ..registerFactory((c) => ValidatorBloc())
      ..registerFactory((c) => ProfileBloc(
          profileUserUseCase: c<ProfileUserUseCase>(),
          storageUseCase: c<StorageUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          groupUseCase: c<GroupUseCase>(),
          appDefaultUsecase: c<AppDefaultUsecase>(),
          categoriesUseCase: c<CategoriesUseCase>()))
      ..registerFactory((c) => NotificationBloc(
          notificationUseCase: c<NotificationUseCase>(),
          goalUseCase: c<GoalUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          bottomTabBloc: c<BottomTabBloc>(),
          transactionBloc: c<TransactionBloc>(),
          unreadNotificationBloc: c<UnreadNotificationBloc>()))
      ..registerFactory((c) => DebtBloc(
          settleDebtUseCase: c<SettleDebtUseCase>(),
          debtUseCase: c<DebtUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => HomeBloc(
          authenticationBloc: c<AuthenticationBloc>(),
          settleDebtUseCase: c<SettleDebtUseCase>(),
          homeUseCase: c<HomeUseCase>(),
          currencyUseCase: c<CurrencyUseCase>(),
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          bottomTabBloc: c<BottomTabBloc>(),
          notificationUseCase: c<NotificationUseCase>(),
          localPreferences: c<LocalPreferences>(),
          profileUserUseCase: c<ProfileUserUseCase>()))
      ..registerSingleton((c) => BottomTabBloc(
          goalUseCase: c<GoalUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => AvatarBloc(
          authenticationBloc: c<AuthenticationBloc>(),
          storageUseCase: c<StorageUseCase>(),
          profileUserUseCase: c<ProfileUserUseCase>()))
      ..registerFactory((c) => HomeChartDataBloc(
          reportUseCase: c<ReportUseCase>(),
          authBloc: c<AuthenticationBloc>(),
          settleDebtUseCase: c<SettleDebtUseCase>()))
      ..registerFactory((c) => TransactionBloc(
          expenseUseCase: c<ExpenseUseCase>(),
          transactionUseCase: c<TransactionUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          notificationUseCase: c<NotificationUseCase>(),
          groupUseCase: c<GroupUseCase>(),
          groupBloc: c<GroupBloc>()))
      ..registerFactory((c) => ReportDataBloc(
          reportUseCase: c<ReportUseCase>(),
          authBloc: c<AuthenticationBloc>(),
          categoriesUseCase: c<CategoriesUseCase>()))
      ..registerFactory((c) => FilterResultBloc(
          filterUseCase: c<FilterUseCase>(),
          transactionUseCase: c<TransactionUseCase>(),
          authBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => SecurityBloc(
          authBloc: c<AuthenticationBloc>(),
          profileUserUseCase: c<ProfileUserUseCase>()))
      ..registerFactory((c) => NotifySettingsBloc(
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          authBloc: c<AuthenticationBloc>(),
          profileUsecase: c<ProfileUserUseCase>()))
      ..registerFactory((c) => TransactionDetailBloc(
          transactionUseCase: c<TransactionUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory(
          (c) => ShowExpenseImageBloc(expenseUseCase: c<ExpenseUseCase>()))
      ..registerSingleton((c) => GroupBloc(
          groupUseCase: c<GroupUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerSingleton((c) => UnreadNotificationBloc(
          notificationUseCase: c<NotificationUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => ChooseCurrencyBloc(
          currencyUseCase: c<CurrencyUseCase>(),
          profileUserUseCase: c<ProfileUserUseCase>(),
          authenticationBloc: c<AuthenticationBloc>()))
      ..registerFactory((c) => SelectGroupBloc(groupBloc: c<GroupBloc>()))
      ..registerFactory((c) => CreateGoalBloc(
          categoriesUseCase: c<CategoriesUseCase>(),
          goalUseCase: c<GoalUseCase>(),
          currencyUseCase: c<CurrencyUseCase>(),
          localNotificationUseCase: c<LocalNotificationUseCase>(),
          notificationUseCase: c<NotificationUseCase>(),
          authenticationBloc: c<AuthenticationBloc>(),
          notificationBloc: c<NotificationBloc>(),
          snackbarBloc: c<SnackbarBloc>(),
          loaderBloc: c<LoaderBloc>()));
  }

  @override
  void _configureUsecases() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton(
          (c) => CurrencyUseCase(currencyRepository: c<CurrencyRepository>()))
      ..registerSingleton((c) => ExpenseUseCase(
          expenseRepository: c<ExpenseRepository>(),
          categoriesUseCase: c<CategoriesUseCase>(),
          storageUseCase: c<StorageUseCase>()))
      ..registerSingleton((c) => AuthenticationUseCase(
          authRepo: c<AuthenticationRepository>(),
          userRepo: c<UserRepository>(),
          currencyRepository: c<CurrencyRepository>()))
      ..registerSingleton((c) => ProfileUserUseCase(
          userRepo: c<UserRepository>(),
          authenticationUseCase: c<AuthenticationUseCase>()))
      ..registerSingleton((c) => CountryPhoneCodeUseCase(
          codeRepository: c<CountryPhoneCodeRepository>()))
      ..registerSingleton(
          (c) => CategoriesUseCase(categoryRepository: c<CategoryRepository>()))
      ..registerSingleton((c) => DateUseCase())
      ..registerSingleton((c) => FilterUseCase(
          expenseRepository: c<ExpenseRepository>(),
          filterRepository: c<FilterRepository>(),
          categoriesUseCase: c<CategoriesUseCase>(),
          dateUseCase: c<DateUseCase>(),
          transactionRepository: c<TransactionRepository>()))
      ..registerSingleton((c) => ReportUseCase(
          expenseRepository: c<ExpenseRepository>(),
          reportRepository: c<ReportRepository>(),
          transactionRepository: c<TransactionRepository>(),
          participantRepository: c<ParticipantRepository>(),
          categoriesUseCase: c<CategoriesUseCase>()))
      ..registerSingleton((c) => SearchUseCase(
          searchRepository: c<SearchRepository>(),
          expenseUseCase: c<ExpenseUseCase>()))
      ..registerSingleton((c) => NotificationUseCase(
          notificationRepository: c<NotificationRepository>()))
      ..registerSingleton((c) => SettleDebtUseCase(
          expenseRepository: c<ExpenseRepository>(),
          transactionRepository: c<TransactionRepository>(),
          participantRepository: c<ParticipantRepository>(),
          categoryRepository: c<CategoryRepository>()))
      ..registerSingleton((c) => HomeUseCase())
      ..registerSingleton((c) => DebtUseCase())
      ..registerSingleton((c) => LocalNotificationUseCase(
          localNotifyHelper: c<LocalNotifyHelper>(),
          userRepo: c<UserRepository>(),
          notificationRepository: c<NotificationRepository>()))
      ..registerSingleton(
          (c) => StorageUseCase(storageRepository: c<StorageRepository>()))
      ..registerSingleton((c) =>
          AppDefaultUsecase(appDefaultRepository: c<AppDefaultRepository>()))
      ..registerSingleton(
          (c) => GroupUseCase(groupRepository: c<GroupRepository>()))
      ..registerSingleton((c) => GoalUseCase(
          goalRepository: c<GoalRepository>(),
          categoryRepository: c<CategoryRepository>()))
      ..registerFactory((c) =>
          TransactionUseCase(c<TransactionRepository>(), c<StorageUseCase>()));
  }

  @override
  void _configureRepositories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton<CurrencyRepository>((c) =>
          CurrencyRepositoryImpl(currencyDataSource: c<CurrencyDataSource>()))
      ..registerSingleton<ExpenseRepository>((c) => ExpenseRepositoryImpl(
          expenseDataSource: c<ExpenseDataSource>(),
          expenseLocalDataSource: c<ExpenseLocalDataSource>()))
      ..registerSingleton<AuthenticationRepository>((c) =>
          AuthenticationRepositoryImpl(
              authDataSource: c<FirebaseAuthRemoteDataSource>(),
              networkInfo: c<NetworkInfo>(),
              authLocalDataSource: c<AuthLocalDataSource>(),
              userRemoteDataSource: c<UserRemoteDataSource>()))
      ..registerSingleton<UserRepository>((c) =>
          UserRepositoryImpl(userRemoteDataSource: c<UserRemoteDataSource>()))
      ..registerSingleton<CountryPhoneCodeRepository>((c) =>
          CountryPhoneCodeRepositoryImpl(
              countryPhoneCodeDataSource: c<CountryPhoneCodeDataSource>()))
      ..registerFactory<TransactionRepository>((c) => TransactionRepositoryImpl(
          transactionRemoteDataSource: c<TransactionRemoteDataSource>()))
      ..registerSingleton<ParticipantRepository>((c) =>
          ParticipantRepositoryImpl(
              participantDataSource: c<ParticipantDataSource>()))
      ..registerSingleton<CategoryRepository>((c) =>
          CategoryRepositoryImpl(categoryDataSource: c<CategoryDataSource>()))
      ..registerSingleton<SearchRepository>(
          (c) => SearchRepositoryImpl(searchDataSource: c<SearchDataSource>()))
      ..registerSingleton<NotificationRepository>((c) =>
          NotificationRepositoryImpl(
              notificationDataSource: c<NotificationDataSource>()))
      ..registerSingleton<StorageRepository>((c) =>
          StorageRepositoryImpl(storageDataSource: c<StorageDataSource>()))
      ..registerSingleton<FilterRepository>(
          (c) => FilterRepositoryImpl(filterDataSource: c<FilterDataSource>()))
      ..registerSingleton<ReportRepository>(
          (c) => ReportRepositoryImpl(reportDataSource: c<ReportDataSource>()))
      ..registerSingleton<AppDefaultRepository>((c) => AppDefaultRepositoryImpl(
          remoteConfigDataSource: c<RemoteConfigDataSource>()))
      ..registerSingleton<GroupRepository>((c) => GroupRepositoryImpl(
          groupRemoteDataSource: c<GroupRemoteDataSource>()))
      ..registerSingleton<GoalRepository>((c) => GoalRepositoryImpl(
          goalRemoteDataSource: c<GoalRemoteDataSource>(),
          goalLocalDataSource: c<GoalLocalDataSource>()));
  }

  @override
  void _configureDataSources() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => CurrencyDataSource())
      ..registerSingleton(
          (c) => ExpenseDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) => FirebaseAuthRemoteDataSource())
      ..registerSingleton((c) =>
          UserRemoteDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton(
          (c) => AuthLocalDataSource(localPreferences: c<LocalPreferences>()))
      ..registerSingleton(
          (c) => CountryPhoneCodeDataSource(c<LocalPreferences>()))
      ..registerFactory(
          (c) => TransactionRemoteDataSource(c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) =>
          ParticipantDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton(
          (c) => CategoryDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton(
          (c) => SearchDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) => NotificationDataSource(
          setupFirebaseDatabase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) => StorageDataSource())
      ..registerSingleton(
          (c) => FilterDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton(
          (c) => ReportDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) =>
          ExpenseLocalDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton(
          (c) => GoalLocalDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) =>
          GroupRemoteDataSource(setupFirebase: c<SetupFirebaseDatabase>()))
      ..registerSingleton((c) =>
          RemoteConfigDataSource(remoteConfigDefault: c<RemoteConfigDefault>()))
      ..registerSingleton((c) =>
          GoalRemoteDataSource(setupFirebase: c<SetupFirebaseDatabase>()));
  }

  @override
  void _configureExternal() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => DataConnectionChecker())
      ..registerSingleton((c) => FlutterSecureStorage())
      ..registerSingleton((c) => FlutterLocalNotificationsPlugin());
  }

  @override
  void _configureCommon() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => LocalPreferences())
      ..registerSingleton((c) => SetupFirebaseDatabase())
      ..registerSingleton<LocalNotifyHelper>(
          (c) => LocalNotifyHelperImpl(c<FlutterLocalNotificationsPlugin>()))
      ..registerSingleton<NetworkInfo>(
          (c) => NetworkInfoImpl(c<DataConnectionChecker>()))
      ..registerSingleton((c) => RemoteConfigDefault())
      ..registerSingleton((c) => PushNotificationService());
  }
}
