import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/presentation/journey/home/blocs/bottom_tab_bloc/bottom_tab_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';

import '../home_screen_constants.dart';

class BottomTabHome extends StatefulWidget {
  @override
  State<BottomTabHome> createState() => _BottomTabHomeState();
}

class _BottomTabHomeState extends State<BottomTabHome> {
  int _indexTab = 0;

  final _bottomShadows = const BoxShadow(
      color: AppColor.shadowsBottomTab,
      blurRadius: 10,
      offset: Offset(0.0, 3.0));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomCenter, child: _shadowsOfCreateButton()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[_bottomShadows],
              color: Colors.white,
            ),
            height: HomeScreenConstants.heightTab,
            child: _tabs(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: _createExpenseButton(context))
      ],
    );
  }

  Widget _shadowsOfCreateButton() {
    return Padding(
        padding: EdgeInsets.only(
            bottom: HomeScreenConstants.centerButtonPaddingBottom),
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[_bottomShadows],
            color: Colors.white,
          ),
        ));
  }

  Widget _createExpenseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: HomeScreenConstants.centerButtonPaddingBottom),
      child: GestureDetector(
        onTap: () => _onPressedBtnAdd(context),
        child: Container(
          height: 56,
          width: 56,
          child: Image.asset(
            IconConstants.floatingBtnIcon,
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return BlocBuilder<BottomTabBloc, BottomTabState>(
        builder: (context, state) {
      if (state is BottomTabInitial) {
        _indexTab = 0;
      } else if (state is TabChangeState) {
        _indexTab = state.index;
      }
      return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _tabItem(
                    _indexTab == 0
                        ? IconConstants.homeIconHighlight
                        : IconConstants.homeIconNoHighlight,
                    () => _tabClicked(context, 0)),
                _tabItem(
                    _indexTab == 1
                        ? IconConstants.goalIconHighlight
                        : IconConstants.goalIconNoHighlight,
                    () => _tabClicked(context, 1)),
              ],
            ),
            Row(
              children: [
                _tabItem(
                    _indexTab == 2
                        ? IconConstants.chartIconHighlight
                        : IconConstants.chartIconNoHighlight,
                    () => _tabClicked(context, 2)),
                _tabItem(
                    _indexTab == 3
                        ? IconConstants.profileIconHighlight
                        : IconConstants.profileIconNoHighlight,
                    () => _tabClicked(context, 3)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _tabItem(String iconPath, Function onClicked) {
    double bottomPadding = HomeScreenConstants.iconTabPaddingBottomAndroid;
    if (Platform.isIOS) {
      bottomPadding = HomeScreenConstants.iconTabPaddingBottomIOS;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onClicked();
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        width: HomeScreenConstants.widthChildTab,
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Image.asset(
          iconPath,
        ),
      ),
    );
  }

  void _tabClicked(BuildContext context, int index) {
    BlocProvider.of<BottomTabBloc>(context).add(TabChangedEvent(index));
  }

  void _onPressedBtnAdd(BuildContext context) {
    Navigator.pushNamed(context, RouteList.personalExpense, arguments: {
      KeyConstants.routeKey: RouteList.home,
      KeyConstants.editExpenseKey: false,
      KeyConstants.expenseDetailKey: null,
    });
  }
}
