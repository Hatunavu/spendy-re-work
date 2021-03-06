library autocomplete_textfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';

typedef AutoCompleteOverlayItemBuilder<T> = Widget Function(
    BuildContext context, T suggestion);

typedef Filter<T> = bool Function(T suggestion, String query);

typedef InputEventCallback<T> = Function(T data);

typedef StringCallback = Function(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  final List<String>? suggestions;
  final Filter<T>? itemFilter;
  final Comparator<T>? itemSorter;
  final StringCallback? textChanged, textSubmitted;
  final ValueSetter<bool>? onFocusChanged;
  final InputEventCallback<String>? itemSubmitted;
  final AutoCompleteOverlayItemBuilder<String>? itemBuilder;
  final int? suggestionsAmount;
  @override
  final GlobalKey<AutoCompleteTextFieldState<T>>? key;
  final bool? submitOnSuggestionTap, clearOnSubmit;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLength;

  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final TextAlign? textAlign;
  final bool? autoFocus;
  final Color? cursorColor;

  AutoCompleteTextField(
      {required this.itemSubmitted, //Callback on item selected, this is the item selected of type <T>
      required this.key, //GlobalKey used to enable addSuggestion etc
      required this.suggestions, //Suggestions that will be displayed
      required this.itemBuilder, //Callback to build each item, return a Widget
      required this.itemSorter, //Callback to sort items in the form (a of type <T>, b of type <T>)
      required this.itemFilter, //Callback to filter item: return true or false depending on input text
      this.inputFormatters,
      this.cursorColor,
      this.textAlign,
      this.autoFocus,
      this.style,
      this.decoration: const InputDecoration(),
      this.textChanged, //Callback on input text changed, this is a string
      this.textSubmitted, //Callback on input text submitted, this is also a string
      this.onFocusChanged,
      this.keyboardType: TextInputType.text,
      this.suggestionsAmount:
          5, //The amount of suggestions to show, larger values may result in them going off screen
      this.submitOnSuggestionTap:
          true, //Call textSubmitted on suggestion tap, itemSubmitted will be called no matter what
      this.clearOnSubmit: true, //Clear autoCompleteTextfield on submit
      this.textInputAction: TextInputAction.done,
      this.textCapitalization: TextCapitalization.sentences,
      this.minLength = 1,
      this.controller,
      this.focusNode})
      : super(key: key);

  void clear() => key!.currentState?.clear();

  void addSuggestion(String suggestion) =>
      key!.currentState!.addSuggestion(suggestion);

  void removeSuggestion(String suggestion) =>
      key!.currentState!.removeSuggestion(suggestion);

  void updateSuggestions(List<String> suggestions) =>
      key!.currentState!.updateSuggestions(suggestions);

  void triggerSubmitted() => key!.currentState!.triggerSubmitted();

  void updateDecoration(
          {InputDecoration? decoration,
          List<TextInputFormatter>? inputFormatters,
          TextCapitalization? textCapitalization,
          TextStyle? style,
          TextInputType? keyboardType,
          TextInputAction? textInputAction}) =>
      key!.currentState!.updateDecoration(decoration!, inputFormatters!,
          textCapitalization!, style!, keyboardType!, textInputAction!);

  TextField get textField => key!.currentState!.textField;

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<T>(
      suggestions!,
      textChanged!,
      textSubmitted!,
      onFocusChanged!,
      itemSubmitted!,
      itemBuilder!,
      itemSorter!,
      itemFilter!,
      suggestionsAmount!,
      submitOnSuggestionTap!,
      clearOnSubmit!,
      minLength!,
      inputFormatters!,
      textCapitalization!,
      decoration!,
      style!,
      keyboardType!,
      textInputAction!,
      controller!,
      focusNode!,
      textAlign!,
      autoFocus!,
      cursorColor!);
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();

  late TextField textField;
  late List<String> suggestions;
  late StringCallback? textChanged, textSubmitted;
  late ValueSetter<bool>? onFocusChanged;
  late InputEventCallback<String> itemSubmitted;
  late AutoCompleteOverlayItemBuilder<String> itemBuilder;
  late Comparator<T> itemSorter;
  OverlayEntry? listSuggestionsEntry;
  late List<String> filteredSuggestions;
  late Filter<T> itemFilter;
  late int suggestionsAmount;
  late int minLength;
  late bool submitOnSuggestionTap, clearOnSubmit;
  late TextEditingController? controller;
  late FocusNode? focusNode;

  late InputDecoration decoration;
  late List<TextInputFormatter> inputFormatters;
  late TextCapitalization textCapitalization;
  late TextStyle style;
  late TextInputType keyboardType;
  late TextInputAction textInputAction;
  late TextAlign textAlign;
  late bool autoFocus;
  late Color cursorColor;

  AutoCompleteTextFieldState(
    this.suggestions,
    this.textChanged,
    this.textSubmitted,
    this.onFocusChanged,
    this.itemSubmitted,
    this.itemBuilder,
    this.itemSorter,
    this.itemFilter,
    this.suggestionsAmount,
    this.submitOnSuggestionTap,
    this.clearOnSubmit,
    this.minLength,
    this.inputFormatters,
    this.textCapitalization,
    this.decoration,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.textAlign,
    this.autoFocus,
    this.cursorColor,
  ) {
    textField = TextField(
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      decoration: decoration,
      textAlign: textAlign,
      autofocus: autoFocus,
      cursorColor: cursorColor,
      style: style,
      keyboardType: keyboardType,
      focusNode: focusNode ?? FocusNode(),
      controller: controller ?? TextEditingController(),
      textInputAction: textInputAction,
      onChanged: (newText) {
//        print('onChange - 1');
        updateOverlay(newText);

        if (textChanged != null) {
          textChanged!(newText);
        }
      },
      onTap: () {
//        print('onTap - 1');
        updateOverlay(controller!.text);
      },
      onSubmitted: (submittedText) =>
          triggerSubmitted(submittedText: submittedText),
    );

    textField.focusNode!.addListener(() {
      if (onFocusChanged != null) {
        onFocusChanged!(textField.focusNode!.hasFocus);
      }

      if (!textField.focusNode!.hasFocus) {
        filteredSuggestions = [];
        updateOverlay();
      } else if (!(controller!.text == '' || controller!.text.isEmpty)) {
        updateOverlay(controller!.text);
      }
    });
  }

  void updateDecoration(
      InputDecoration? decoration,
      List<TextInputFormatter>? inputFormatters,
      TextCapitalization? textCapitalization,
      TextStyle? style,
      TextInputType? keyboardType,
      TextInputAction? textInputAction) {
    if (decoration != null) {
      this.decoration = decoration;
    }

    if (inputFormatters != null) {
      this.inputFormatters = inputFormatters;
    }

    if (textCapitalization != null) {
      this.textCapitalization = textCapitalization;
    }

    if (style != null) {
      this.style = style;
    }

    if (keyboardType != null) {
      this.keyboardType = keyboardType;
    }

    if (textInputAction != null) {
      this.textInputAction = textInputAction;
    }

    setState(() {
      textField = TextField(
        inputFormatters: this.inputFormatters,
        textCapitalization: this.textCapitalization,
        decoration: this.decoration,
        cursorColor: AppColor.primaryColor,
        style: this.style,
        keyboardType: this.keyboardType,
        focusNode: focusNode ?? FocusNode(),
        controller: controller ?? TextEditingController(),
        textInputAction: this.textInputAction,
        onChanged: (newText) {
          updateOverlay(newText);

          if (textChanged != null) {
            textChanged!(newText);
          }
        },
        onTap: () {
          updateOverlay(controller!.text);
        },
        onSubmitted: (submittedText) =>
            triggerSubmitted(submittedText: submittedText),
      );
    });
  }

  void triggerSubmitted({String? submittedText}) {
    submittedText!.isEmpty
        ? textSubmitted!(controller!.text)
        : textSubmitted!(submittedText);

    if (clearOnSubmit) {
      clear();
    }
  }

  void clear() {
    textField.controller!.clear();
    updateOverlay();
  }

  void addSuggestion(String suggestion) {
    suggestions.add(suggestion);
    updateOverlay(controller!.text);
  }

  void removeSuggestion(String suggestion) {
    final Error error = ArgumentError(
        'List does not contain suggestion and therefore cannot be removed');
    suggestions.contains(suggestion)
        ? suggestions.remove(suggestion)
        : throw error;
    updateOverlay(controller!.text);
  }

  void updateSuggestions(List<String> suggestions) {
    this.suggestions = suggestions;
    updateOverlay(controller!.text);
  }

  void updateOverlay([String? query]) {
    if (listSuggestionsEntry == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      listSuggestionsEntry = OverlayEntry(builder: (context) {
        return Positioned(
            width: width,
            child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, height),
                child: SizedBox(
                    width: width,
                    child: Card(
                        child: Column(
                      children: filteredSuggestions.map((suggestion) {
                        return Row(children: [
                          Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (submitOnSuggestionTap) {
                                        final String newText =
                                            suggestion.toString();
                                        textField.controller!.text = newText;
                                        textField.focusNode!.unfocus();
                                        itemSubmitted(suggestion);
                                        if (clearOnSubmit) {
                                          clear();
                                        }
                                      } else {
                                        final String newText =
                                            suggestion.toString();
                                        textField.controller!.text = newText;
                                        textChanged!(newText);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Text(
                                      suggestion.toString(),
                                      style: ThemeText.getDefaultTextTheme()
                                          .bodyText1,
                                    ),
                                  )))
                        ]);
                      }).toList(),
                    )))));
      });
      Overlay.of(context)!.insert(listSuggestionsEntry!);
    }

    filteredSuggestions = getSuggestions(
        suggestions, itemSorter, itemFilter, suggestionsAmount, query!);

    listSuggestionsEntry!.markNeedsBuild();
  }

  List<String> getSuggestions(List<String> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String? query) {
    if (null == query || query.length < minLength) {
      return [];
    }

    // suggestions = suggestions.where((item) => filter(item, query)).toList();
    suggestions = fillSuggestions(suggestions: suggestions, keyWord: query)
      ..sort((a, b) => b.compareTo(a));
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  List<String> fillSuggestions({List<String>? suggestions, String? keyWord}) {
    if (keyWord == null || keyWord.isEmpty) {
      return suggestions!;
    }
    final List<String> suggestionCategoryList = [];
    for (final String categoryName in suggestions!) {
      if (categoryName.toLowerCase().contains(keyWord.toLowerCase())) {
        suggestionCategoryList.add(categoryName);
      }
    }
    return suggestionCategoryList;
  }

  @override
  void dispose() {
    // if we created our own focus node and controller, dispose of them
    // otherwise, let the caller dispose of their own instances
    if (focusNode == null) {
      textField.focusNode!.dispose();
    }
    if (controller == null) {
      textField.controller!.dispose();
    }
    listSuggestionsEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _layerLink, child: textField);
  }
}

class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  @override
  @override
  final StringCallback? textChanged, textSubmitted;
  @override
  final int? minLength;
  @override
  final ValueSetter<bool>? onFocusChanged;
  @override
  final TextEditingController? controller;
  @override
  final FocusNode? focusNode;

  SimpleAutoCompleteTextField({
    TextStyle? style,
    InputDecoration decoration: const InputDecoration(),
    this.onFocusChanged,
    this.textChanged,
    this.textSubmitted,
    this.minLength = 1,
    this.controller,
    this.focusNode,
    TextInputType keyboardType: TextInputType.text,
    GlobalKey<AutoCompleteTextFieldState<String>>? key,
    required List<String> suggestions,
    int suggestionsAmount: 5,
    bool submitOnSuggestionTap: true,
    bool clearOnSubmit: true,
    TextInputAction textInputAction: TextInputAction.done,
    TextCapitalization textCapitalization: TextCapitalization.sentences,
    TextAlign textAlign = TextAlign.center,
    bool autoFocus = true,
    Color cursorColor = AppColor.primaryColor,
  }) : super(
            style: style,
            textAlign: textAlign,
            cursorColor: cursorColor,
            autoFocus: autoFocus,
            decoration: decoration,
            textChanged: textChanged,
            textSubmitted: textSubmitted,
            itemSubmitted: textSubmitted,
            keyboardType: keyboardType,
            key: key,
            suggestions: suggestions,
            itemBuilder: null,
            itemSorter: null,
            itemFilter: null,
            suggestionsAmount: suggestionsAmount,
            submitOnSuggestionTap: submitOnSuggestionTap,
            clearOnSubmit: clearOnSubmit,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization);

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<String>(
          suggestions!,
          textChanged,
          textSubmitted,
          onFocusChanged,
          itemSubmitted!, (context, item) {
        return Padding(padding: const EdgeInsets.all(8.0), child: Text(item));
      }, (a, b) {
        return a.compareTo(b);
      }, (item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
          suggestionsAmount!,
          submitOnSuggestionTap!,
          clearOnSubmit!,
          minLength!,
          [],
          textCapitalization!,
          decoration!,
          style!,
          keyboardType!,
          textInputAction!,
          controller,
          focusNode,
          textAlign!,
          autoFocus!,
          cursorColor!);
}
