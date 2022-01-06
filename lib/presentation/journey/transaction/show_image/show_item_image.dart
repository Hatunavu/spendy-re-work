import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';

class ShowItemImage extends StatelessWidget {
  final String? url;

  const ShowItemImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      appBarTitle: '',
      leading: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: LayoutConstants.paddingHorizontal),
        child: Center(
          child: Image.network(
            url!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
