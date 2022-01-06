// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:spendy_re_work/common/configs/default_env.dart';
// import 'package:spendy_re_work/common/constants/regex_constants.dart';
// import 'package:spendy_re_work/common/constants/route_constants.dart';
// import 'package:spendy_re_work/common/enums/auth_pincode_permission.dart';
// import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
// import 'package:spendy_re_work/common/extensions/string_extensions.dart';
// import 'package:spendy_re_work/common/extensions/string_validator_extensions.dart';
// import 'package:spendy_re_work/common/utils/internet_util.dart';
// import 'package:spendy_re_work/domain/entities/category_entity.dart';
// import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
// import 'package:spendy_re_work/domain/entities/photo_entity.dart';
// import 'package:spendy_re_work/domain/entities/currency_entity.dart';
// import 'package:spendy_re_work/domain/entities/expense/participant_expense_entity.dart';
// import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
// import 'package:spendy_re_work/domain/entities/user/user_entity.dart';
// import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/expense_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/new_expense_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/participant_usecase.dart';
// import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
// import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
// import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
// import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/bloc.dart';
// import 'package:spendy_re_work/presentation/bloc/snackbar_bloc/snackbar_type.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/bloc/personal_expense_event.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/bloc/personal_expense_state.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/button_state.dart';
// import 'package:spendy_re_work/presentation/journey/transaction/search/search_bloc.dart';

// class PersonalExpenseBloc
//     extends Bloc<PersonalExpenseEvent, PersonalExpenseState> {
//   final CurrencyUseCase currencyUseCase;
//   final ExpenseUseCase expenseUseCase;
//   final ParticipantUseCase participantUseCase;
//   final NewExpenseUseCase newExpenseUseCase;
//   final CategoriesUseCase categoriesUseCase;
//   final StorageUseCase storageUseCase;

//   final LoaderBloc loaderBloc;
//   final AuthenticationBloc authenticationBloc;
//   final SearchBloc searchBloc;
//   final SnackbarBloc snackBarBloc;

//   bool? isEdit = false;
//   bool? isCreateADebt = false;

//   /// resetCode is a binary code used to mark the data refesh of screens
//   /// (Personal) resetCode = 4 (100)
//   /// (WhoPaid) resetCode = 2 (010)
//   /// (ForWho) resetCode = 1 (001)
//   /// If resetCode = 4 (100) => WhoPaid Screen and ForWho Screen will reset data
//   /// If resetCode = 5 (101) => WhoPaid Screen will reset data
//   /// If resetCode = 6 (110) => ForWho Screen will reset data
//   /// If resetCode = 7 (111) => Nothing Screen need reset data
//   /// Cases never happened resetCode = {0,1,2,3} or {000, 001, 010, 011}
//   int resetCode = 4;
//   int _imageCount = 0;

//   // Use to Edit
//   int _currentImageCount = 0;

//   String? _spend = '';
//   String? _note = '';
//   String? previousRoute = RouteList.home;

//   DateTime _spendTime = DateTime.now().dateTimeYmd;

//   CurrencyEntity? _currency;
//   CategoryEntity? _category;

//   ButtonState? _buttonState = ButtonState.nonActive;
//   ButtonState? _shareSpendButtonState = ButtonState.nonActive;

//   UserEntity? _user;
//   ExpenseEntity? _currenExpense;

//   List<Asset>? _assetGallery = [];
//   List<XFile>? _filesCamera = [];
//   List<CategoryEntity>? _categories = [];

//   Map<String, ParticipantInTransactionEntity>? whoPaidMap = {};
//   Map<String, ParticipantInTransactionEntity>? forWhoMap = {};

//   ParticipantInTransactionEntity? _currentForWho;
//   ParticipantInTransactionEntity? _currentWhoPaid;

//   // Use to update
//   Map<String, ParticipantInTransactionEntity>? newForWhoMap = {};
//   Map<String, ParticipantInTransactionEntity>? newWhoPaidMap = {};
//   Map<String, ParticipantInTransactionEntity>? _oldForWhoMap = {};
//   List<PhotoEntity>? _photoList = [];

//   final _amountRegex = RegExp(RegexConstants.hasSpaceOrCommaCharacter);

//   PersonalExpenseBloc(
//       {required this.currencyUseCase,
//       required this.participantUseCase,
//       required this.expenseUseCase,
//       required this.storageUseCase,
//       required this.newExpenseUseCase,
//       required this.categoriesUseCase,
//       required this.loaderBloc,
//       required this.authenticationBloc,
//       required this.searchBloc,
//       required this.snackBarBloc})
//       : super(GetParticipantState());

//   @override
//   Stream<PersonalExpenseState> mapEventToState(
//       PersonalExpenseEvent event) async* {
//     switch (event.runtimeType) {
//       case PersonalExpenseInitialEvent:
//         yield* _mapPersonalExpenseInitialEventToState(
//             event as PersonalExpenseInitialEvent);
//         break;
//       case SelectCategoryEvent:
//         yield* _mapSelectCategoryEventToMap(event as SelectCategoryEvent);
//         break;
//       case SwitchTodayAndYesterdayEvent:
//         yield* _mapSwitchTodayAndYesterdayEventToMap();
//         break;
//       case CheckSpendEmptyEvent:
//         yield* _mapCheckSpendEmptyEventToMap(event as CheckSpendEmptyEvent);
//         break;
//       case ChangeDateTimeEvent:
//         yield* _mapChangeDateTimeEventToMap(event as ChangeDateTimeEvent);
//         break;
//       case OpenCameraEvent:
//         yield* _mapOpenCameraEventToState();
//         break;
//       case OpenGalleryEvent:
//         yield* _mapOpenGalleryEventToState();
//         break;
//       case CreatePersonalExpenseEvent:
//         yield* _mapCreatePersonalExpenseEventToMap(
//             event as CreatePersonalExpenseEvent);
//         break;
//       case ChangeNoteTextEvent:
//         yield* _mapChangeNoteTextEventToState(event as ChangeNoteTextEvent);
//         break;
//       case PushToWhoPaidEvent:
//         yield* _mapPushToWhoPaidEventToState(event);
//         break;
//       case UpdateStatePersonalExpenseEvent:
//         yield* _mapUpdateStatePersonalExpenseEventToState(event);
//     }
//   }

//   Stream<PersonalExpenseState> _mapPersonalExpenseInitialEventToState(
//       PersonalExpenseInitialEvent event) async* {
//     await resetBloc();
//     _categories = await categoriesUseCase.getCategoryListCate(
//         authenticationBloc.userEntity.uid!, 'EXPENSE');
//     isEdit = event.isEdit;
//     previousRoute = event.previousRoute;
//     _user = authenticationBloc.userEntity;
//     isCreateADebt = event.isCreateDebt!;

//     if (isEdit!) {
//       isEdit = event.isEdit;
//       await _setExpense(event.currentExpense!);
//     }

//     // when create a debt transaction
//     if (isCreateADebt!) {
//       _category = event.createADebtArgument!.categoryEntity!;
//       _spend = event.createADebtArgument!.settleDebtModel!.debtAmount
//           .toInt()
//           .toString();
//       await _addParticipantToList(
//           payerName: event.createADebtArgument!.settleDebtModel!.payerName,
//           payeeName: event.createADebtArgument!.settleDebtModel!.payeeName);

//       _shareSpendButtonState = _checkShareSpendButtonState();
//       _buttonState = _checkSaveButtonState();
//     }
//     _assignCurrentForWhoAndWhoPaid();
//     yield PersonalExpenseInitialState(
//       currencyEntity: _currency,
//       category: _category,
//       buttonState: _buttonState,
//       shareSpendButtonState: _shareSpendButtonState,
//       imageCount: _imageCount,
//       categories: _categories,
//       spendTime: _spendTime,
//       strSpend: _spend,
//       currentForWho: _currentForWho,
//       currentWhoPaid: _currentWhoPaid,
//       note: _note,
//     );
//   }

//   Stream<PersonalExpenseState> _mapChangeNoteTextEventToState(
//       ChangeNoteTextEvent event) async* {
// //    yield PersonalExpenseLoadingState();
//     _note = event.note;
//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         note: _note,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapSelectCategoryEventToMap(
//       SelectCategoryEvent event) async* {
// //    yield PersonalExpenseLoadingState();
//     _category = event.category;
//     _shareSpendButtonState = _checkShareSpendButtonState();
//     _buttonState = _checkSaveButtonState();

//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         currencyEntity: _currency,
//         category: _category,
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapSwitchTodayAndYesterdayEventToMap() async* {
// //    yield PersonalExpenseLoadingState();
//     if (_spendTime == DateTime.now().dateTimeYmd) {
//       _spendTime = DateTime.now().yesterday;
//     } else if (_spendTime == DateTime.now().yesterday) {
//       _spendTime = DateTime.now().dateTimeYmd;
//     }
//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         spendTime: _spendTime,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapCheckSpendEmptyEventToMap(
//       CheckSpendEmptyEvent event) async* {
// //    yield PersonalExpenseLoadingState();
//     // replace `\$` | `"space"` | `,` character
//     // -> check all numeric

//     if (event.spend.isNotNullOrEmpty) {
//       if (event.spend.contains(_amountRegex)) {
//         _spend = event.spend
//             .replaceAll(_amountRegex, '')
//             .replaceAll(_currency!.code!, '');
//       }
//       if (_spend!.isAllNumeric) {
//         if (!isEdit!) {
//           if (previousRoute == RouteList.debt) {
//             await _updateParticipantToList();
//           } else {
//             await _addParticipantToList(
//                 payerName: _user!.fullName!, payeeName: _user!.fullName!);
//           }
//         } else {
//           await _updateWhoPaidAndForWhoMap();
//         }
//       }
//     } else {
//       _spend = null;
//     }

// //    print(_spend.toString());
//     _assignCurrentForWhoAndWhoPaid();

//     _shareSpendButtonState = _checkShareSpendButtonState();
//     _buttonState = _checkSaveButtonState();
//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         currencyEntity: _currency,
//         category: _category,
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//         categories: _categories,
//         spendTime: _spendTime,
//         strSpend: _spend.toString(),
//         currentForWho: _currentForWho,
//         currentWhoPaid: _currentWhoPaid,
//         note: _note,
//       );
//     }
//   }

//   Future<void> _updateWhoPaidAndForWhoMap() async {
//     whoPaidMap = await newExpenseUseCase.updateAmountParticipantsList(
//         participantsMap: whoPaidMap, spend: int.parse(spend!));
//     forWhoMap = await newExpenseUseCase.updateAmountParticipantsList(
//         participantsMap: forWhoMap, spend: int.parse(spend!));
//   }

//   Future<void> _updateParticipantToList() async {
//     whoPaidMap![_currentWhoPaid!.name]!.amount =
//         int.parse(_spend!.formatCurrencyToString());
//     forWhoMap![_currentForWho!.name]!.amount =
//         int.parse(_spend!.formatCurrencyToString());
//   }

//   ButtonState _checkSaveButtonState() {
//     // if (_shareSpendButtonState == ButtonState.active &&
//     //     whoPaidMap.isNotEmpty &&
//     //     forWhoMap.isNotEmpty) return ButtonState.active;
//     if ((_category != null &&
//             _category!.name != null &&
//             _category!.name!.isNotEmpty) &&
//         (spend != null &&
//             spend != '0' &&
//             spend!.formatCurrencyToString().isNotEmpty)) {
//       return ButtonState.active;
//     }
//     return ButtonState.nonActive;
//   }

//   ButtonState _checkShareSpendButtonState() {
//     if (_category != null && _spend!.isNotNullOrEmpty) {
//       return ButtonState.active;
//     }
//     return ButtonState.nonActive;
//   }

//   Stream<PersonalExpenseState> _mapOpenCameraEventToState() async* {
// //    yield PersonalExpenseLoadingState();
//     // turn off pin code authentication
//     authenticationBloc.authPinCodePermission = AuthPinCodePermission.unEnable;
//     final picture = await ImagePicker()
//         .pickImage(source: ImageSource.camera, imageQuality: 10);
//     if (picture != null) {
//       _filesCamera!.add(picture);
//     }
//     _imageCount =
//         _currentImageCount + _assetGallery!.length + _filesCamera!.length;
//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapOpenGalleryEventToState() async* {
// //    yield PersonalExpenseLoadingState();
//     // turn off pin code authentication
//     authenticationBloc.authPinCodePermission = AuthPinCodePermission.unEnable;
//     try {
//       final List<Asset> resultList = await MultiImagePicker.pickImages(
//         maxImages: 10,
//         // enableCamera: true,
//         selectedAssets: _assetGallery!,
//         cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
//         materialOptions: MaterialOptions(
//           actionBarColor: '#676FE5',
//           actionBarTitle: NewExpenseConstants.expensePhotosBottomSheetHeader,
//           allViewTitle: '',
//           useDetailsView: false,
//           selectCircleStrokeColor: '#000000',
//         ),
//       );
//       if (resultList.isNotEmpty) {
//         _assetGallery = resultList;
//         _imageCount =
//             _currentImageCount + _assetGallery!.length + _filesCamera!.length;
//       }
//     } catch (e) {
//       debugPrint(
//           'PersonalExpenseBloc - mapOpenGalleryEventToState - error: {${e.toString()}');
//     }
//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapChangeDateTimeEventToMap(
//       ChangeDateTimeEvent event) async* {
// //    yield PersonalExpenseLoadingState();
//     _spendTime = event.selectDateTime!;

//     final currentState = state;
//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         spendTime: _spendTime,
//       );
//     }
//   }

//   Stream<PersonalExpenseState> _mapCreatePersonalExpenseEventToMap(
//       CreatePersonalExpenseEvent event) async* {
//     if (!isCreateADebt!) {
//       _assignCurrentForWhoAndWhoPaid();
//     }
//     yield CreatePersonalExpenseWaitingState(
//         currencyEntity: _currency,
//         category: _category,
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//         categories: _categories,
//         currentForWho: _currentForWho,
//         currentWhoPaid: _currentWhoPaid,
//         spendTime: _spendTime);

//     try {
//       await saveNewExpense();
//       yield CreatePersonalExpenseSuccessState(
//           currencyEntity: _currency,
//           category: _category,
//           buttonState: _buttonState,
//           shareSpendButtonState: _shareSpendButtonState,
//           imageCount: _imageCount,
//           categories: _categories,
//           currentForWho: _currentForWho,
//           currentWhoPaid: _currentWhoPaid,
//           spendTime: _spendTime);
//     } catch (e) {
//       yield PersonalExpenseActionFailure(
//           currencyEntity: _currency,
//           category: _category,
//           buttonState: _buttonState,
//           shareSpendButtonState: _shareSpendButtonState,
//           imageCount: _imageCount,
//           categories: _categories,
//           currentForWho: _currentForWho,
//           currentWhoPaid: _currentWhoPaid,
//           spendTime: _spendTime);
//     }
//   }

//   String? get spend {
//     return _spend;
//   }

//   int get spendTime {
//     return _spendTime.millisecondsSinceEpoch;
//   }

//   Future saveNewExpense() async {
//     final String uid = authenticationBloc.userEntity.uid!;
//     final bool isPersonal = await expenseUseCase.checkPersonalExpense(
//         whoPaidMap: whoPaidMap, forWhoMap: forWhoMap, user: _user);
//     if (isEdit!) {
//       await updateExpense(uid: uid, isPersonal: isPersonal);
//     } else {
//       await createExpense(
//           user: authenticationBloc.userEntity, isPersonal: isPersonal);
//     }
//   }

//   Future<void> createExpense({UserEntity? user, bool? isPersonal}) async {
//     final connectivityResult = await InternetUtil.checkInternetConnection();
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       try {
//         final int createAt = DateTime.now().millisecondsSinceEpoch;
//         final List<PhotoEntity> photoList =
//             await storageUseCase.uploadImageUrls(DefaultConfig.expenseStorage,
//                 uid: user!.uid,
//                 imageAssets: _assetGallery,
//                 imageFiles: _filesCamera!);
//         await expenseUseCase.createExpense(
//           uid: user.uid,
//           strAmount: spend!.formatCurrencyToString(),
//           group: isPersonal! ? 'PERSONAL' : '',
//           isoCode: user.isoCode,
//           category: _category!.name,
//           remarks: _note,
//           paid: [
//             ParticipantExpenseEntity(
//                 id: user.uid, name: user.fullName, amount: int.parse(spend!))
//           ],
//           debts: [
//             ParticipantExpenseEntity(
//                 id: user.uid, name: user.fullName, amount: int.parse(spend!))
//           ],
//           photos: photoList,
//           selectTime: spendTime,
//           searchTime: createAt,
//           createAt: createAt,
//         );

//         // if success -> add new name participant suggest
//         // final List<String> nameParticipants = await participantUseCase
//         //     .mapListNameParticipant(forWhoMap.values.toList());
//         //
//         // newExpenseUseCase.addSetNameParticipants(nameParticipants);
//       } catch (e) {
//         rethrow;
//       }
//     } else {
//       snackBarBloc.add(ShowSnackbar(
//           title: NewExpenseConstants.noInternet, type: SnackBarType.error));
//     }
//     // TransactionEntity transactionEntity =
//     //     transactionUseCase.refreshTransaction(
//     //         spend: spend.formatCurrencyToString(),
//     //         note: _note,
//     //         currencyIsoCode: _currency.isoCode,
//     //         imageUrlList: [],
//     //         spendTime: _spendTime.millisecondsSinceEpoch,
//     //         lastUpdate: now.millisecondsSinceEpoch,
//     //         createAt: now.millisecondsSinceEpoch,
//     //         isPersonal: isPersonal);

//     // final String transactionId = await transactionUseCase.addTransaction(
//     //   transactionEntity: transactionEntity,
//     //   imageAssets: _assetGallery,
//     //   imageFiles: _filesCamera,
//     //   uid: uid,
//     // );

//     // final List<String> whoPaidIds =
//     //     await participantUseCase.addParticipantList(whoPaidMap.values.toList());
//     // final List<String> forWhoIds =
//     //     await participantUseCase.addParticipantList(forWhoMap.values.toList());
//     // final int forWhoGroup =
//     //     await participantUseCase.getForWhoGroup(forWhoMap.values.toList());
//   }

//   Future<void> updateExpense({String? uid, bool? isPersonal}) async {
//     final connectivityResult = await InternetUtil.checkInternetConnection();
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       // transaction.transactionId = _editTransaction.transactionId;
//       // await transactionUseCase.updateTransaction(
//       //   transactionEntity: transaction,
//       //   imageAssets: _assetGallery,
//       //   imageFiles: _filesCamera,
//       //   uid: uid,
//       // );
//       final UserEntity user = authenticationBloc.userEntity;
//       // final List<String> whoPaidIds =
//       //     await participantUseCase.updateParticipantList(
//       //         partIdMap: _whoPaidIdMap,
//       //         oldPartEntityMap: _oldWhoPaidMap,
//       //         currentPartEntities: whoPaidMap.values.toList());
//       // final List<String> forWhoIds =
//       //     await participantUseCase.updateParticipantList(
//       //         partIdMap: _forWhoIdMap,
//       //         oldPartEntityMap: _oldForWhoMap,
//       //         currentPartEntities: forWhoMap.values.toList());
//       // final int forWhoGroup =
//       //     await participantUseCase.getForWhoGroup(forWhoMap.values.toList());

//       try {
//         // TransactionEntity transactionEntity =
//         //     transactionUseCase.refreshTransaction(
//         //   transactionId: _editTransaction.transactionId,
//         //   spendTime: _spendTime.millisecondsSinceEpoch,
//         //   note: _note,
//         //   imageUrlList: _imageUrlEdits,
//         //   lastUpdate: now.millisecondsSinceEpoch,
//         //   spend: spend.formatCurrencyToString(),
//         //   isPersonal: _editTransaction.isPersonal,
//         //   createAt: _editTransaction.createAt,
//         //   currencyIsoCode: _editTransaction.currencyIsoCode,
//         // );

//         final List<PhotoEntity> photoList =
//             await storageUseCase.uploadImageUrls(DefaultConfig.expenseStorage,
//                 uid: user.uid,
//                 imageAssets: _assetGallery,
//                 imageFiles: _filesCamera);
//         // for (final PhotoEntity photo in photoList) {
//         //   _photoList?.add(photo);
//         // }
//         photoList.forEach(addPhoto);
//         final now = DateTime.now();
//         await expenseUseCase.updateExpense(
//             id: _currenExpense!.id,
//             uid: user.uid,
//             strAmount: spend!.formatCurrencyToString(),
//             // group: isPersonal ? 'PERSONAL' : '',
//             group: 'PERSONAL',
//             isoCode: user.isoCode,
//             category: _category!.name,
//             remarks: _note,
//             paid: [
//               ParticipantExpenseEntity(
//                   id: user.uid,
//                   name: user.fullName,
//                   amount: int.parse(spend!.formatCurrencyToString()))
//             ],
//             debts: [
//               ParticipantExpenseEntity(
//                   id: user.uid,
//                   name: user.fullName,
//                   amount: int.parse(spend!.formatCurrencyToString()))
//             ],
//             photos: _photoList,
//             selectTime: _spendTime
//                 .copyWith(hour: now.hour, minute: now.minute)
//                 .millisecondsSinceEpoch,
//             currentSpendTime:
//                 DateTime.fromMillisecondsSinceEpoch(_currenExpense!.timeSpend!)
//                     .intYmd,
//             createAt: _currenExpense!.createAt,
//             searchTime: _currenExpense!.searchTime);
//       } catch (e) {
//         rethrow;
//       }
//     } else {
//       snackBarBloc.add(ShowSnackbar(
//           title: NewExpenseConstants.noInternet, type: SnackBarType.error));
//     }
//   }

//   ///Add photo list
//   void addPhoto(PhotoEntity photo) => _photoList?.add(photo);
//   Future resetBloc() async {
//     isEdit = false;
//     resetCode = 4;
//     _imageCount = 0;
//     _currentImageCount = 0;
//     _spend = '0';
//     _note = '';
//     _spendTime = DateTime.now().dateTimeYmd;

//     _currency = await currencyUseCase.getCurrentCurrency();
//     _category = null;

//     _buttonState = ButtonState.nonActive;
//     _shareSpendButtonState = ButtonState.nonActive;

//     _currentForWho = ParticipantInTransactionEntity();
//     _currentWhoPaid = ParticipantInTransactionEntity();

//     whoPaidMap = {};
//     forWhoMap = {};
//     _filesCamera = [];
//     _assetGallery = [];
//     newForWhoMap = {};
//     newWhoPaidMap = {};
//     _oldForWhoMap = {};
//   }

//   Future syncPersonalAndWhoPaidBloc(
//       Map<String, ParticipantInTransactionEntity> whoPaidMap) async {
//     this.whoPaidMap = whoPaidMap;
//     add(UpdateStatePersonalExpenseEvent());
//   }

//   Future syncPersonalAndForWhoBloc(
//       Map<String, ParticipantInTransactionEntity> forWhoMap) async {
//     this.forWhoMap = forWhoMap;
//     add(UpdateStatePersonalExpenseEvent());
//   }

//   Future _addParticipantToList({String? payerName, String? payeeName}) async {
//     final String uid = authenticationBloc.userEntity.uid!;

//     whoPaidMap = await newExpenseUseCase.createParticipant(
//         uid: uid,
//         isForWhom: false,
//         participantsMap: whoPaidMap,
//         spend:
//             _spend!.isEmpty ? 0 : int.parse(_spend!.formatCurrencyToString()),
//         participantName: payeeName);
//     forWhoMap = await newExpenseUseCase.createParticipant(
//         uid: uid,
//         isForWhom: true,
//         participantsMap: forWhoMap,
//         spend:
//             _spend!.isEmpty ? 0 : int.parse(_spend!.formatCurrencyToString()),
//         participantName: payerName);
//   }

//   Future<void> _setExpense(ExpenseEntity currentExpense) async {
//     // Transaction
//     // _editTransaction = expenseDetail.transactionEntity;
//     _currenExpense = currentExpense;
//     _imageCount = _currentImageCount = _currenExpense!.photos!.length;
//     _spend = _currenExpense!.amount.toString().formatStringToCurrency();
//     _note = _currenExpense!.remarks ?? '';
//     _spendTime =
//         DateTime.fromMillisecondsSinceEpoch(_currenExpense!.timeSpend!);

//     // Category
//     _category = await categoriesUseCase.getCategoryByName(
//         categoryList: _categories,
//         currentCategoryName: _currenExpense!.category);

//     _oldForWhoMap?.addAll(forWhoMap!);
//     _shareSpendButtonState = _checkShareSpendButtonState();
//     _buttonState = _checkSaveButtonState();
//     _photoList = _currenExpense!.photos!;
//   }

//   Stream<PersonalExpenseState> _mapPushToWhoPaidEventToState(
//       PersonalExpenseEvent event) async* {
//     final currentState = state;

//     _assignCurrentForWhoAndWhoPaid();

//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         currencyEntity: _currency,
//         category: _category,
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//         categories: _categories,
//         spendTime: _spendTime,
//         strSpend: _spend.toString(),
//         note: _note,
//         currentForWho: _currentForWho,
//         currentWhoPaid: _currentWhoPaid,
//       );
//     }
//     yield PushToWhoPaidState(
//       whoPaidMap: whoPaidMap!,
//       forWhoMap: forWhoMap!,
//     );
//   }

//   Stream<PersonalExpenseState> _mapUpdateStatePersonalExpenseEventToState(
//       PersonalExpenseEvent event) async* {
//     final currentState = state;
// //    print('PersonalExpenseBloc - _mapUpdateStatePersonalExpenseEventToState -'
// //        ' whoPaidMap: ${whoPaidMap.length}');
//     _assignCurrentForWhoAndWhoPaid();

//     if (currentState is PersonalExpenseInitialState) {
//       yield currentState.copyWith(
//         currencyEntity: _currency,
//         category: _category,
//         buttonState: _buttonState,
//         shareSpendButtonState: _shareSpendButtonState,
//         imageCount: _imageCount,
//         categories: _categories,
//         spendTime: _spendTime,
//         strSpend: _spend.toString(),
//         note: _note,
//         currentForWho: _currentForWho,
//         currentWhoPaid: _currentWhoPaid,
//       );
//     }
//   }

//   void _assignCurrentForWhoAndWhoPaid() {
//     _currentForWho = forWhoMap!.values.firstWhere(
//         (element) => element.isPaid ?? false,
//         orElse: () => ParticipantInTransactionEntity.normal());
//     _currentWhoPaid = whoPaidMap!.values.firstWhere(
//         (element) => element.isPaid ?? false,
//         orElse: () => ParticipantInTransactionEntity.normal());
// //    print('currentForWho: ${_currentForWho.name}');
// //    print('_currentWhoPaid: ${_currentWhoPaid.name}');
//   }
// }
