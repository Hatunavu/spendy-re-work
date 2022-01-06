// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:spendy_re_work/common/utils/currency_text_input_formatter.dart';
// import 'package:spendy_re_work/common/extensions/string_extensions.dart';
// import 'package:spendy_re_work/domain/entities/currency_entity.dart';
// import 'package:spendy_re_work/domain/entities/participant_in_transaction_entity.dart';
// import 'package:spendy_re_work/presentation/theme/theme_color.dart';
// import 'package:spendy_re_work/presentation/theme/theme_text.dart';

// import '../../new_expense_constants.dart';

// class MoneyFormWidget extends StatefulWidget {
//   final ParticipantInTransactionEntity? participant;
//   final FocusNode? focusNode;

//   final Function(String)? onSubmitted;
//   final Function(String)? onChange;
//   final Function(bool, String)? listenerFocusNode;
//   final CurrencyEntity? currencyEntity;

//   final int maxLength;

//   MoneyFormWidget(
//       {Key? key,
//       this.currencyEntity,
//       this.onSubmitted,
//       this.participant,
//       this.onChange,
//       this.maxLength = 15,
//       this.focusNode,
//       this.listenerFocusNode})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _MoneyFormWidgetState();
// }

// class _MoneyFormWidgetState extends State<MoneyFormWidget> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _listenerFocusNode();
//   }

//   void _listenerFocusNode() {
//     widget.focusNode!.addListener(() {
//       if (mounted) {
//         widget.listenerFocusNode!(widget.focusNode!.hasFocus, _controller.text);
//       }
//     });

//     // moving the cursor -> ez delete in keyboard
//     _controller.addListener(() {
//       final text = _controller.text.toLowerCase();
//       _controller.value = _controller.value.copyWith(
//         text: text,
//         selection:
//             TextSelection(baseOffset: text.length, extentOffset: text.length),
//         composing: TextRange.empty,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _controller.text =
//         widget.participant!.amount.toString().formatStringToCurrency();
//     return Visibility(
//       visible: widget.participant!.isPaid ?? false,
//       child: TextFormField(
//         controller: _controller,
//         enableInteractiveSelection: false,
//         focusNode: widget.focusNode,
//         textAlign: TextAlign.right,
//         style: widget.participant!.isEdit ?? false
//             ? ThemeText.getDefaultTextTheme().captionSemiBold
//             : ThemeText.getDefaultTextTheme()
//                 .caption
//                 ?.copyWith(fontSize: NewExpenseConstants.fzHintText),
//         keyboardType: TextInputType.number,
//         inputFormatters: [
//           CurrencyTextInputFormatter(
//             locale: widget.currencyEntity?.locale,
//             decimalDigits: 0,
//             symbol: widget.currencyEntity!.code!,
//           ),
//           LengthLimitingTextInputFormatter(widget.maxLength),
//         ],
//         decoration: InputDecoration(
//             hintText: '0'.formatStringToCurrency(),
//             isDense: true,
//             contentPadding: EdgeInsets.zero,
//             hintStyle: ThemeText.getDefaultTextTheme().hint,
//             focusedBorder: InputBorder.none,
//             border: InputBorder.none),
//         onChanged: widget.onChange,
//         onFieldSubmitted: widget.onSubmitted,
//         cursorColor: AppColor.primaryColor,
//       ),
//     );
//   }
// }
