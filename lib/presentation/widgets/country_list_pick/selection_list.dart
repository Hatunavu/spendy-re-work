import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './country_list_pick_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'country_list_pick.dart';

class SelectionList extends StatefulWidget {
  SelectionList(this.elements, this.initialSelection,
      {Key? key,
      this.appBar,
      this.theme,
      this.countryBuilder,
      this.useUiOverlay = true,
      this.useSafeArea = false})
      : super(key: key);

  final PreferredSizeWidget? appBar;
  final List elements;
  final CountryCode initialSelection;
  final CountryTheme? theme;
  final Widget Function(BuildContext context, CountryCode)? countryBuilder;
  final bool useUiOverlay;
  final bool useSafeArea;

  @override
  _SelectionListState createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  late List countries;
  final TextEditingController _controller = TextEditingController();
  late ScrollController _controllerScroll;
  double diff = 0.0;

  late int posSelected = 0;
  late double height = 0.0;
  late double _sizeHeightContainer;
  late double _heightScroller;
  late double _text;
  late double _oldText;
  final _itemSizeHeight = 50.0;
  double _offsetContainer = 0.0;

  bool isShow = true;

  final _titleStyle = ThemeText.getDefaultTextTheme()
      .textMenu
      .copyWith(fontSize: CountryListPickConstants.fzTitle);
  final _nameCountryStyle = ThemeText.getDefaultTextTheme().bodyText1!.copyWith(
      fontSize: CountryListPickConstants.fzTitle, color: AppColor.black);

  @override
  void initState() {
    countries = widget.elements;
    countries.sort((a, b) {
      return a.name.toString().compareTo(b.name.toString());
    });
    _controllerScroll = ScrollController();
    //_controller.addListener(_scrollListener);
    _controllerScroll.addListener(_scrollListener);
    super.initState();
  }

  void _sendDataBack(BuildContext context, CountryCode initialSelection) {
    Navigator.pop(context, initialSelection);
  }

  final List _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.useUiOverlay) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            Platform.isAndroid ? Brightness.dark : Brightness.light,
      ));
    }
    height = MediaQuery.of(context).size.height;
    final Widget scaffold = Scaffold(
      appBar: widget.appBar,
      body: Container(
        color: const Color(0xfff4f4f4),
        child: LayoutBuilder(builder: (context, contrainsts) {
          diff = height - contrainsts.biggest.height;
          _heightScroller = (contrainsts.biggest.height) / _alphabet.length;
          _sizeHeightContainer = contrainsts.biggest.height;
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CustomScrollView(
                  controller: _controllerScroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              widget.theme?.searchText ?? 'SEARCH',
                              style: _titleStyle,
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: _controller,
                              style: ThemeText.getDefaultTextTheme()
                                  .textField
                                  .copyWith(
                                      fontSize:
                                          CountryListPickConstants.fzTitle,
                                      color: AppColor.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: ThemeText.getDefaultTextTheme()
                                    .textHint
                                    .copyWith(
                                        fontSize:
                                            CountryListPickConstants.fzTitle),
                                contentPadding: const EdgeInsets.only(
                                    left: 15, bottom: 0, top: 0, right: 15),
                                hintText:
                                    widget.theme?.searchHintText ?? 'Search...',
                              ),
                              onChanged: _filterElements,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              widget.theme?.lastPickText ?? 'LAST PICK',
                              style: _titleStyle,
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Image.asset(
                                  widget.initialSelection.flagUri!,
                                  width: 32.0,
                                ),
                                title: Text(widget.initialSelection.name!,
                                    style: _nameCountryStyle),
                                trailing: const Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.check, color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return widget.countryBuilder != null
                            ? widget.countryBuilder!(
                                context, countries.elementAt(index))
                            : getListCountry(countries.elementAt(index));
                      }, childCount: countries.length),
                    )
                  ],
                ),
              ),
              if (isShow == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalDragUpdate,
                    onVerticalDragStart: _onVerticalDragStart,
                    child: Container(
                      height: 20.0 * 30,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(_alphabet.length, _getAlphabetItem)
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
    return widget.useSafeArea ? SafeArea(child: scaffold) : scaffold;
  }

  Widget getListCountry(CountryCode e) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Image.asset(
            e.flagUri!,
            width: 30.0,
          ),
          title: Text(
            e.name!,
            style: _nameCountryStyle,
          ),
          onTap: () {
            _sendDataBack(context, e);
          },
        ),
      ),
    );
  }

  Widget _getAlphabetItem(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            posSelected = index;
            _text = _alphabet[posSelected];
            if (_text != _oldText) {
              for (var i = 0; i < countries.length; i++) {
                if (_text.toString().compareTo(
                        countries[i].name.toString().toUpperCase()[0]) ==
                    0) {
                  _controllerScroll.jumpTo((i * _itemSizeHeight) + 10);
                  break;
                }
              }
              _oldText = _text;
            }
          });
        },
        child: Container(
          width: CountryListPickConstants.widthBoxAlpha,
          height: CountryListPickConstants.heightBoxAlpha,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == posSelected
                ? widget.theme?.alphabetSelectedBackgroundColor ?? Colors.blue
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            _alphabet[index],
            textAlign: TextAlign.center,
            style: (index == posSelected)
                ? TextStyle(
                    fontSize: CountryListPickConstants.fzCountryName,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.theme?.alphabetSelectedTextColor ?? Colors.white)
                : TextStyle(
                    fontSize: CountryListPickConstants.fzLabel,
                    fontWeight: FontWeight.w400,
                    color: widget.theme?.alphabetTextColor ?? Colors.black),
          ),
        ),
      ),
    );
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      countries = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeHeightContainer - _heightScroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / _heightScroller) % _alphabet.length).round();
        _text = _alphabet[posSelected];
        if (_text != _oldText) {
          for (var i = 0; i < countries.length; i++) {
            if (_text
                    .toString()
                    .compareTo(countries[i].name.toString().toUpperCase()[0]) ==
                0) {
              _controllerScroll.jumpTo((i * _itemSizeHeight) + 15);
              break;
            }
          }
          _oldText = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _offsetContainer = details.globalPosition.dy - diff;
  }

  void _scrollListener() {
    final int scrollPosition =
        (_controllerScroll.position.pixels / _itemSizeHeight).round();
    if (scrollPosition < countries.length) {
      final String countryName = countries.elementAt(scrollPosition).name;
      setState(() {
        posSelected =
            countryName[0].toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
      });
    }

    if ((_controllerScroll.offset) >=
        (_controllerScroll.position.maxScrollExtent)) {}
    if (_controllerScroll.offset <=
            _controllerScroll.position.minScrollExtent &&
        !_controllerScroll.position.outOfRange) {}
  }
}
