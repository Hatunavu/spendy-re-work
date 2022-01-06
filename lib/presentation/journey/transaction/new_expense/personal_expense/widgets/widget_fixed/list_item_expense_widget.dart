import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/list_item_setting_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/common/utils/permission_helpers.dart';
import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/dashboard/personal_page_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/new_expense_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/for_who_bloc/for_who_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/new_expense_bloc/new_expense_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/cubit/who_paid_bloc/who_paid_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_expense_picker/for_who_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_expense_picker/note_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_expense_picker/who_paid_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/presentation/widgets/add_photos_bottom_sheet/add_photos_bottom_sheet.dart';
import 'package:spendy_re_work/presentation/widgets/create_form/item_button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/icon_svg_widget/icon_edit_widget.dart';
import 'item_expense_picker/calendar_picker.widget.dart';
import 'item_expense_picker/personal_costs_widget.dart';
import 'item_widget/item_category_widget.dart';

class ListItemExpenseWidget extends StatefulWidget {
  final TextEditingController noteController;
  final ValueNotifier<List<ParticipantInTransactionEntity>?> whoPaidValue;
  final ValueNotifier<List<ParticipantInTransactionEntity>?> forWhoValue;

  const ListItemExpenseWidget({
    Key? key,
    required this.noteController,
    required this.whoPaidValue,
    required this.forWhoValue,
  }) : super(key: key);

  @override
  State<ListItemExpenseWidget> createState() => _ListItemExpenseWidgetState();
}

class _ListItemExpenseWidgetState extends State<ListItemExpenseWidget> {
  late NewExpenseBloc _expenseCubit;
  late ForWhoBloc _forWhoBloc;
  late WhoPaidBloc _whoPaidBloc;

  @override
  void initState() {
    _expenseCubit = BlocProvider.of<NewExpenseBloc>(context);
    _forWhoBloc = BlocProvider.of<ForWhoBloc>(context);
    _whoPaidBloc = BlocProvider.of<WhoPaidBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(IconConstants.categoryIcon, height: 16.w, width: 16.w),
              SizedBox(
                width: 16.w,
              ),
              Text(
                NewExpenseConstants.categoriesTitle,
                style: ThemeText.getDefaultTextTheme().textMenu,
              )
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            buildWhen: (previous, current) =>
                previous.categorySelected != current.categorySelected ||
                previous.categories != current.categories,
            builder: (_, state) {
              final length = state.categories.length;
              return Wrap(
                spacing: 6.5.w,
                children: List.generate(
                  length,
                  (index) {
                    final category = state.categories[index];
                    return ItemCategoryWidget(
                      isCategory: state.categorySelected == category,
                      categoryEntity: category,
                      onPressed: () {
                        _expenseCubit.onChangeCategory(category);
                      },
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 12.h,
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return state.isPersonal
                  ? const SizedBox()
                  : ItemButtonWidget(
                      onItemClick: () => _onSelectGroup(state.groupSelected),
                      itemPersonalEntity: ItemPersonalEntity(
                        icon: IconConstants.icGroup,
                        name: PersonalPageConstants.group,
                      ),
                      widgetSuffix: Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                state.groupSelected?.name ?? '',
                                style: ThemeText.getDefaultTextTheme().labelStyle,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.navigate_next,
                              color: AppColor.iconColorGrey,
                            )
                          ],
                        ),
                      ),
                    );
            },
          ),
          NoteWidget(
            controller: widget.noteController,
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return CalendarPickerWidget(
                onChangedDateTime: (dateTime) {
                  _expenseCubit.onChangeDateTime(dateTime);
                },
                initialDateTime: state.currentDateTime,
              );
            },
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return ItemButtonWidget(
                itemPersonalEntity: ItemPersonalEntity(
                    icon: IconConstants.cameraMenuIcon, name: NewExpenseConstants.takePhotoTitle),
                onItemClick: () => _showAddPhotoBottomSheet(context),
                widgetSuffix: Visibility(
                  visible: state.imageCount != null,
                  child: Text(
                    '${state.imageCount} ${translate('label.picture')}',
                    style: ThemeText.getDefaultTextTheme().labelStyle,
                  ),
                ),
              );
            },
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return ItemButtonWidget(
                onItemClick: () => state.isPersonal ? null : _onSeletWhoPaid(context),
                itemPersonalEntity: ItemPersonalEntity(
                    icon: IconConstants.whoPaidIcon, name: NewExpenseConstants.whoPaidTitle),
                widgetSuffix: Row(
                  children: [
                    ValueListenableBuilder<List<ParticipantInTransactionEntity>?>(
                      valueListenable: widget.whoPaidValue,
                      builder: (context, whoPaid, _) {
                        return Text(getLalbe(whoPaid ?? []),
                            style: TextStyle(
                                color: const Color(0xff3A385A),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400));
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    state.isPersonal
                        ? const SizedBox()
                        : const IconSvgWidget(iconSvg: IconConstants.icEditParticipants)
                  ],
                ),
              );
            },
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return ItemButtonWidget(
                onItemClick: () => state.isPersonal ? null : _onSelectForWho(context),
                itemPersonalEntity: ItemPersonalEntity(
                    icon: IconConstants.forWhoIcon, name: NewExpenseConstants.forWhoTitle),
                widgetSuffix: Row(
                  children: [
                    ValueListenableBuilder<List<ParticipantInTransactionEntity>?>(
                        valueListenable: widget.forWhoValue,
                        builder: (context, forWho, _) {
                          return Text(getLalbe(forWho ?? []),
                              style: TextStyle(
                                  color: const Color(0xff3A385A),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400));
                        }),
                    SizedBox(
                      width: 10.w,
                    ),
                    state.isPersonal
                        ? const SizedBox()
                        : const IconSvgWidget(iconSvg: IconConstants.icEditParticipants)
                  ],
                ),
              );
            },
          ),
          BlocBuilder<NewExpenseBloc, NewExpenseState>(
            builder: (context, state) {
              return PersonalCostsWidget(
                onSwitch: (value) {
                  _expenseCubit.changeIsPersonal(value);
                  if (value) {
                    widget.forWhoValue.value?.clear();
                    widget.whoPaidValue.value?.clear();
                  }
                },
                isSwitch: state.isPersonal,
              );
            },
          )
        ],
      ),
    );
  }

  void _showAddPhotoBottomSheet(BuildContext personalContext) {
    FocusScope.of(personalContext).requestFocus(FocusNode());
    showModalBottomSheet(
      context: personalContext,
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LayoutConstants.roundedRadius),
      ),
      builder: (context) => AddPhotosBottomSheet(
        title: NewExpenseConstants.expensePhotosBottomSheetHeader,
        photosOnTap: () => _photosOnTap(personalContext),
        cameraOnTap: () => _cameraOnTap(personalContext),
      ),
    );
  }

  Future<void> _photosOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestPhotoPermission(context);
    if (_isGranted) {
      await _expenseCubit.openGallery();
    }
  }

  Future<void> _cameraOnTap(BuildContext context) async {
    final _isGranted = await PermissionHelpers.requestCameraPermission(context);
    if (_isGranted) {
      await _expenseCubit.openCamera();
    }
  }

  Future<void> _onSelectGroup(GroupEntity? group) async {
    final result = await Navigator.pushNamed(context, RouteList.selectGroup, arguments: {
      KeyConstants.groupKey: group,
    });
    if (result != null && result is GroupEntity) {
      await _expenseCubit.changeGroup(result);
      await _forWhoBloc.getParticipants(group: result);
      await _whoPaidBloc.getParticipants(group: result);
      widget.forWhoValue.value?.clear();
      widget.whoPaidValue.value?.clear();
    }
  }

  Future<void> _onSeletWhoPaid(BuildContext context) async {
    final result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(30.sp), topRight: Radius.circular(30.sp)),
        ),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider.value(value: _whoPaidBloc, child: const WhoPaidWidget());
        });
    if (result != null && result is List<ParticipantInTransactionEntity>) {
      widget.whoPaidValue.value = result;
    }
  }

  Future<void> _onSelectForWho(BuildContext context) async {
    final result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(30.sp), topRight: Radius.circular(30.sp)),
        ),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider.value(value: _forWhoBloc, child: const ForWhoWidget());
        });
    if (result != null && result is List<ParticipantInTransactionEntity>) {
      widget.forWhoValue.value = result;
    }
  }

  String getLalbe(List<ParticipantInTransactionEntity> participants) {
    if (participants.isEmpty) {
      return translate('label.me');
    }
    final firstTransaction = participants.first;
    String label = '${firstTransaction.name}';
    if (participants.length >= 2) {
      label = '$label (+${participants.length - 1})';
    }
    return label;
  }
}
