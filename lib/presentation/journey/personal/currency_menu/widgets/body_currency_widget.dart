import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/string_constants.dart';
import 'package:spendy_re_work/domain/entities/currency_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/bloc/choose_currency_bloc.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/util/debounce.dart';
import 'package:spendy_re_work/presentation/journey/personal/currency_menu/widgets/list_item_currency.dart';
import 'package:spendy_re_work/presentation/widgets/seach/search_field_widget.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/button_widget/button_widget.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';
import '../currency_screen_constants.dart';
import '../bloc/choose_currency_bloc.dart';
import 'package:spendy_re_work/common/extensions/screen_utils_extensions.dart';

class BodyChooseCurrencyWidget extends StatefulWidget {
  BodyChooseCurrencyWidget();

  @override
  _BodyChooseCurrencyWidgetState createState() =>
      _BodyChooseCurrencyWidgetState();
}

class _BodyChooseCurrencyWidgetState extends State<BodyChooseCurrencyWidget> {
  late ChooseCurrencyBloc _chooseCurrencyBloc;
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    _chooseCurrencyBloc = BlocProvider.of<ChooseCurrencyBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          title: CurrencyScreenConstants.titleScreen,
        ),
        body: BlocBuilder<ChooseCurrencyBloc, ChooseCurrencyState>(
          builder: (context, state) {
            if (state is ChooseCurrencyLoaded) {
              final _allCurrencies =
                  state.mapCurrencies['popular'] ?? <CurrencyEntity>[].toSet();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: SearchFieldWidget(
                      controller: _searchController,
                      onChanged: (String text) {
                        _debouncer.run(() => _onSubmittedSearch(text));
                      },
                    ),
                  ),
                  Expanded(
                    child: state.isSearching && state.listCurrencies.isEmpty
                        ? ShowEmptyDataWidget(
                            title: translate('label.no_data'),
                          )
                        : SingleChildScrollView(
                            child: state.isSearching
                                ? ListCurrencyRadio(
                                    currencies: state.listCurrencies,
                                    currencySelected: state.currencySelected,
                                    onChanged: (value) => _onChangedCurrency(
                                        value ?? CurrencyEntity()),
                                    label: CurrencyScreenConstants
                                        .textResultSearch,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListCurrencyRadio(
                                        currencies: _allCurrencies,
                                        currencySelected:
                                            state.currencySelected,
                                        onChanged: (value) =>
                                            _onChangedCurrency(value!),
                                        label:
                                            CurrencyScreenConstants.textPopular,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: CurrencyScreenConstants
                                              .titlePaddingRight,
                                        ),
                                        child: Text(
                                          translate('label.other'),
                                          style: ThemeText.getDefaultTextTheme()
                                              .textLabelItem
                                              .copyWith(
                                                  color:
                                                      const Color(0xff7077EA)),
                                        ),
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            alphabet.length,
                                            (index) {
                                              final currencies = state
                                                          .mapCurrencies[
                                                      alphabet[index]] ??
                                                  <CurrencyEntity>[].toSet();
                                              final labels = alphabet[index];
                                              return ListCurrencyRadio(
                                                currencies: currencies,
                                                currencySelected:
                                                    state.currencySelected,
                                                onChanged: (value) =>
                                                    _onChangedCurrency(value ??
                                                        CurrencyEntity()),
                                                label: labels,
                                              );
                                            },
                                          )),
                                    ],
                                  ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.h,
                        bottom: CurrencyScreenConstants.paddingBottom28),
                    child: ButtonWidget.primary(
                      title: CurrencyScreenConstants.textSave,
                      onPress: () => _onSavePressed(state.currencySelected),
                    ),
                  )
                ],
              );
            } else if (state is CurrencyLoadFailure) {
              return FailedFlareWidget(
                callback: () => Navigator.pop(context),
                actionText: 'Back',
              );
            }
            return const SizedBox();
          },
        ));
  }

  void _onChangedCurrency(CurrencyEntity currencySelected) {
    _chooseCurrencyBloc.add(SelectedCurrencyEvent(currencySelected));
  }

  void _onSavePressed(CurrencyEntity currencySelected) {
    _chooseCurrencyBloc.add(SaveCurrencyEvent(currencySelected));
  }

  void _onSubmittedSearch(String value) {
    _chooseCurrencyBloc.add(SearchingCurrencySubmitEvent(value.trim()));
  }
}
