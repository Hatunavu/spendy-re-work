import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/presentation/bloc/loader_bloc/bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/loader/loading_flare_widget.dart';

class LoadingWidget extends StatelessWidget {
  @override
  final Key? key;
  final Widget? child;
  final GlobalKey<NavigatorState>? navigator;

  const LoadingWidget(
      {required this.key, required this.navigator, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          child!,
          BlocBuilder<LoaderBloc, LoaderState>(builder: (context, state) {
            return Visibility(
                visible: state.loading ?? false,
                child: FlareLoadingWidget(
                  textColor: AppColor.white,
                ));
          }),
        ],
      ),
    );
  }
}
