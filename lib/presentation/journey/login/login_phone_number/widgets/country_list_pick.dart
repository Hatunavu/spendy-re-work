import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/journey/login/blocs/phone_country_bloc/phone_country_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/country_list_pick/country_list_pick.dart';

import '../login_phone_num_const.dart';

class CountryPickList extends StatelessWidget {
  final String _initialSelection;

  CountryPickList(this._initialSelection);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LoginPhoneNumberConstant.widthBoxPick,
      child: CountryListPick(
        // if you need custome picker use this
        pickerBuilder: (context, CountryCode countryCode) {
          return Row(
            children: [
              Image.asset(
                countryCode.flagUri!,
                width: LoginPhoneNumberConstant.widthFlag,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: LoginPhoneNumberConstant.padding,
              ),
              Container(
                width: LayoutConstants.dimen_2,
                height: LayoutConstants.dimen_17,
                decoration: const BoxDecoration(
                    color: AppColor.primaryDarkColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(LayoutConstants.dimen_2))),
              ),
              SizedBox(
                width: LoginPhoneNumberConstant.padding,
              ),
            ],
          );
        },
        theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            alphabetTextColor: AppColor.textColor,
            alphabetSelectedBackgroundColor: AppColor.primaryColor,
            isShowCode: true,
            isDownIcon: true,
            showEnglishName: true,
            searchHintText: LoginPhoneNumberConstant.textSearchHint,
            searchText: LoginPhoneNumberConstant.textSearch,
            lastPickText: LoginPhoneNumberConstant.textLastPick),
        initialSelection: _initialSelection,
        appBar: AppbarNormalWidget(
          title: LoginPhoneNumberConstant.textTitle,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              IconConstants.backIcon,
              width: LayoutConstants.dimen_18,
              height: LayoutConstants.dimen_18,
              color: AppColor.iconColor,
            ),
          ),
        ),
        onChanged: (code) => _countryChanged(context, code),
      ),
    );
  }

  void _countryChanged(BuildContext context, CountryCode code) {
    BlocProvider.of<PhoneCountryBloc>(context)
        .add(SelectPhoneCountry(code.dialCode!));
  }
}
