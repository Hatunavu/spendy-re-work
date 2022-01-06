import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/enums/auth_pincode_permission.dart';
import 'package:spendy_re_work/common/extensions/date_time_extensions.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/entities/expense/expense_entity.dart';
import 'package:spendy_re_work/domain/entities/for_me_entity.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/domain/usecases/transaction_use_case.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/domain/usecases/currency_usecase.dart';
import 'package:spendy_re_work/domain/usecases/group_usecase.dart';
import 'package:spendy_re_work/domain/usecases/storage_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_event.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/bloc/group_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_state.dart';

class NewExpenseBloc extends Cubit<NewExpenseState> {
  NewExpenseBloc({
    required this.currencyUseCase,
    required this.authenticationBloc,
    required this.categoriesUseCase,
    required this.groupUseCase,
    required this.transactionUseCase,
    required this.storageUseCase,
    required this.groupBloc,
  }) : super(NewExpenseState.initial()) {
    _uid = authenticationBloc.userEntity.uid!;
    final groupState = groupBloc.state;
    if (groupState is GroupUpdateState) {
      _personalGroup = groupState.groups[0];
    }
  }

  final CurrencyUseCase currencyUseCase;
  final CategoriesUseCase categoriesUseCase;
  final AuthenticationBloc authenticationBloc;
  final GroupUseCase groupUseCase;
  final TransactionUseCase transactionUseCase;
  final StorageUseCase storageUseCase;
  final GroupBloc groupBloc;

  late String _uid;
  ExpenseEntity? expense;
  List<Asset>? _assetGallery = [];
  final List<XFile>? _filesCamera = [];
  final int _currentImageCount = 0;
  int _imageCount = 0;
  GroupEntity? _personalGroup;

  Future<void> initial({ExpenseEntity? expenseEntity, GroupEntity? group}) async {
    emit(state.copyWith(status: NewExpenseStatus.initiating));
    final categories = authenticationBloc.categoryList;
    final currentcy = await currencyUseCase.getCurrentCurrency();
    if (expenseEntity != null && expenseEntity.id != null) {
      final category = await categoriesUseCase.getCategoryByName(
        categoryList: categories,
        currentCategoryName: expenseEntity.category,
      );
      expense = expenseEntity;
      emit(
        state.copyWith(
          status: NewExpenseStatus.initiated,
          categories: categories,
          groupSelected: group!,
          currency: currentcy,
          categorySelected: category,
          currentDateTime: DateTime.fromMillisecondsSinceEpoch(expenseEntity.spendTime),
          isPersonal: group.id == _personalGroup?.id,
        ),
      );
      validButtonSave();
    } else {
      emit(state.copyWith(
        status: NewExpenseStatus.initiated,
        categories: categories,
        currency: currentcy,
      ));
    }
  }

  void onChangeCategory(CategoryEntity? category) {
    emit(state.copyWith(categorySelected: category));
    validButtonSave();
  }

  void changeIsPersonal(bool isPersonal) {
    emit(
      state.copyWith(
        isPersonal: isPersonal,
        groupSelected: isPersonal ? _personalGroup : null,
        forceClearGroup: true,
      ),
    );
    validButtonSave();
  }

  void updateAmount(String amount) {
    emit(state.copyWith(amount: amount));
    validButtonSave();
  }

  void validButtonSave() {
    bool _isValid = true;
    if ((state.amount?.isEmpty ?? true) || state.amount == '0') {
      _isValid = false;
    } else if (state.categorySelected == null) {
      _isValid = false;
    } else if (state.groupSelected == null) {
      _isValid = false;
    }
    emit(state.copyWith(isActiveButton: _isValid));
  }

  Future<void> onChangeDateTime(DateTime newDateTime) async {
    emit(state.copyWith(currentDateTime: newDateTime.dateTimeYmd));
  }

  Future<void> changeGroup(GroupEntity? group) async {
    emit(state.copyWith(groupSelected: group, isPersonal: group?.isDefault ?? false));
    validButtonSave();
  }

  Future<void> openCamera() async {
    authenticationBloc.authPinCodePermission = AuthPinCodePermission.unEnable;
    final picture = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 10);
    if (picture != null) {
      _filesCamera!.add(picture);
    }
    _imageCount = _currentImageCount + _assetGallery!.length + _filesCamera!.length;
    emit(state.copyWith(imageCount: _imageCount));
  }

  Future<void> openGallery() async {
    authenticationBloc.authPinCodePermission = AuthPinCodePermission.unEnable;
    final List<Asset> resultList = await MultiImagePicker.pickImages(
      maxImages: 10,
      // enableCamera: true,
      selectedAssets: _assetGallery!,
      cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
      materialOptions: MaterialOptions(
        actionBarColor: '#676FE5',
        actionBarTitle: NewExpenseConstants.expensePhotosBottomSheetHeader,
        allViewTitle: '',
        useDetailsView: false,
        selectCircleStrokeColor: '#000000',
      ),
    );
    if (resultList.isNotEmpty) {
      _assetGallery = resultList;
      _imageCount = _currentImageCount + _assetGallery!.length + _filesCamera!.length;
    }
    emit(state.copyWith(imageCount: _imageCount));
  }

  Future<void> createExpense(int amount, List<ParticipantInTransactionEntity> whoPaid,
      List<ParticipantInTransactionEntity> forWho, String note) async {
    emit(state.copyWith(status: NewExpenseStatus.loading));
    final photos = await storageUseCase.uploadImageUrls(DefaultConfig.transactions,
        uid: _uid, imageAssets: _assetGallery, imageFiles: _filesCamera);
    int? meWhoPaid;
    int? meForWho;
    if (whoPaid.isNotEmpty && whoPaid[0].id == _uid) {
      meWhoPaid = whoPaid[0].amount;
      whoPaid.removeAt(0);
    }
    if (forWho.isNotEmpty && forWho[0].id == _uid) {
      meForWho = forWho[0].amount;
      whoPaid.removeAt(0);
    }
    if (expense != null && expense!.id != null) {
      final List<PhotoEntity> images = [...expense!.photos, ...photos];
      final newExpense = expense!.copyWith(
        amount: amount,
        category: state.categorySelected!.name!,
        whoPaid: whoPaid,
        forWho: forWho,
        note: note,
        photos: images,
        forMe: ForMeEntity(
            forWho: meForWho,
            whoPaid: meWhoPaid,
            spendTime: state.currentDateTime.millisecondsSinceEpoch),
        spendTime: state.currentDateTime.millisecondsSinceEpoch,
        updateAt: DateTime.now().millisecondsSinceEpoch,
      );
      await transactionUseCase.updateTransaction(
          uid: _uid, groupId: state.groupSelected?.id ?? '', transaction: newExpense);
    } else {
      final transaction = ExpenseEntity(
        amount: amount,
        category: state.categorySelected!.name!,
        whoPaid: whoPaid,
        forWho: forWho,
        note: note,
        photos: photos,
        forMe: ForMeEntity(
          forWho: meForWho,
          whoPaid: meWhoPaid,
          spendTime: state.currentDateTime.millisecondsSinceEpoch,
        ),
        spendTime: state.currentDateTime.millisecondsSinceEpoch,
        updateAt: DateTime.now().millisecondsSinceEpoch,
      );
      final _resultTransaction = await transactionUseCase.addTransaction(
          uid: _uid, groupId: state.groupSelected?.id ?? '', transaction: transaction);

      if (_resultTransaction != null &&
          _resultTransaction.id != null &&
          _resultTransaction.id!.isNotEmpty) {
        await transactionUseCase.addPhotos(
          uid: _uid,
          groupId: _personalGroup?.id ?? '',
          transactionId: _resultTransaction.id ?? '',
          photos: photos,
        );
      }
    }
    await groupUseCase.updateTotalAmount(_uid, state.groupSelected?.id ?? '', amount);
    groupBloc.add(GroupRefreshEvent());
    emit(state.copyWith(status: NewExpenseStatus.success));
  }
}
