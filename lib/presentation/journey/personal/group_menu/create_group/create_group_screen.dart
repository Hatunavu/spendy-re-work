import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/bloc/create_group_cubit.dart';
import 'package:spendy_re_work/presentation/journey/personal/group_menu/create_group/widgets/list_participants_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/dialogs/loader_dialog/loader_wallet_dialog.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'bloc/create_group_state.dart';
import 'widgets/input_group_name.dart';

class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late final CreateGroupCubit _createGroupBloc;

  @override
  void initState() {
    _createGroupBloc = BlocProvider.of<CreateGroupCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBar = MediaQuery.of(context).padding.bottom;
    return BlocListener<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        final _status = state.status;
        if (_status == CreateGroupStatus.initiating ||
            _status == CreateGroupStatus.submitting) {
          LoaderWalletDialog.getInstance().show(context, enableBack: false);
        } else if (_status == CreateGroupStatus.submitted) {
          LoaderWalletDialog.getInstance().hide(context);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppbarNormalWidget(
          title: translate('group.groups'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              IconConstants.backIcon,
              height: LayoutConstants.dimen_18,
              color: AppColor.iconColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('group.name'),
                style: ThemeText.getDefaultTextTheme().hint.copyWith(
                      fontSize: 15.sp,
                      color: AppColor.lightPurple,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              BlocBuilder<CreateGroupCubit, CreateGroupState>(
                buildWhen: (_, state) =>
                    state.status == CreateGroupStatus.initiated,
                builder: (context, state) {
                  return InputGroupNameWidget(
                    initNameGroup: state.groupName,
                    onChangedValue: (name) {
                      _createGroupBloc.updateGroupName(name);
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),
              Text(
                translate('group.participants'),
                style: ThemeText.getDefaultTextTheme().hint.copyWith(
                      fontSize: 15.sp,
                      color: AppColor.lightPurple,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Expanded(child: ListParticipantsWidget()),
              BlocBuilder<CreateGroupCubit, CreateGroupState>(
                builder: (context, state) {
                  if (state.status == CreateGroupStatus.initial ||
                      state.status == CreateGroupStatus.initiating) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: bottomBar + 18.h),
                    child: ButtonWidget.primary(
                      color: AppColor.lightPurple
                          .withOpacity(state.isValidated ? 1 : 0.5),
                      width: double.infinity,
                      title: translate('label.save'),
                      onPress: state.isValidated
                          ? _createGroupBloc.saveGroup
                          : () {},
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
