import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';
import 'package:spendy_re_work/domain/entities/user/group_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/personal_expense/widgets/widget_fixed/item_widget/item_radio_group_widget.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/bloc/select_group_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/bloc/select_group_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/new_expense/select_group/select_group_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_field_widget.dart';

class SelectGroupScreen extends StatefulWidget {
  final GroupEntity? group;

  const SelectGroupScreen({Key? key, this.group}) : super(key: key);
  @override
  State<SelectGroupScreen> createState() => _SelectGroupScreenState();
}

class _SelectGroupScreenState extends State<SelectGroupScreen> {
  late SelectGroupBloc _selectGroupBloc;
  int _groupsLength = 0;
  final _searchController = TextEditingController();
  Timer? _debouce;

  @override
  void initState() {
    _selectGroupBloc = BlocProvider.of<SelectGroupBloc>(context)
      ..getGroups()
      ..setSelectedGroup(widget.group);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNormalWidget(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            IconConstants.backIcon,
            height: LayoutConstants.dimen_18,
            width: LayoutConstants.dimen_18,
            color: AppColor.iconColor,
          ),
        ),
        title: SelectGroupConstants.group,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingHorizontal),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: SearchFieldWidget(
                  controller: _searchController,
                  onChanged: _onChange,
                  onSaved: _onSaved,
                  onSubmitted: _onSubmitted,
                ),
              ),
              Expanded(
                child: BlocBuilder<SelectGroupBloc, SelectGroupState>(
                  bloc: _selectGroupBloc,
                  builder: (context, state) {
                    _groupsLength = state.groups.length;
                    return ListView.separated(
                      separatorBuilder: (_, __) => const Divider(
                        color: AppColor.lightGrey,
                        height: 0,
                      ),
                      itemCount: _groupsLength,
                      itemBuilder: (context, index) {
                        final group = state.groups[index];
                        return ItemRadioGroup(
                          group: group,
                          onChangeGroup: (groupEntity) =>
                              _selectGroupBloc.setSelectedGroup(groupEntity),
                          selectedGroup: state.selectedGroup,
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<SelectGroupBloc, SelectGroupState>(
                builder: (_, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: ButtonWidget.primary(
                      width: double.infinity,
                      title: SelectGroupConstants.save,
                      onPress: state.selectedGroup != null ? _onSave : null,
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

  void _onSave() {
    Navigator.pop(context, _selectGroupBloc.state.selectedGroup);
  }

  void _onChange(String value) {
    if (_debouce?.isActive ?? false) {
      _debouce?.cancel();
    }
    _debouce = Timer(const Duration(milliseconds: 300), () {
      _selectGroupBloc.searchGroup(value);
    });
  }

  void _onSaved(String? value) {}
  void _onSubmitted(String value) {}
}
