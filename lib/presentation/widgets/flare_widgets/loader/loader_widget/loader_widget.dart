import 'dart:developer';

import 'package:flutter/material.dart';

import '../loading_flare_widget.dart';
import 'loader_constants.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('loader widget');
    return Container(
        height: LoaderConstants.loadingHeight, child: FlareLoadingWidget());
  }
}
