import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/common/constants/key_constants.dart';
import 'package:spendy_re_work/common/constants/layout_constants.dart';
import 'package:spendy_re_work/common/constants/route_constants.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_bloc.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_expense_image_bloc/show_expense_image_state.dart';
import 'package:spendy_re_work/presentation/journey/transaction/show_image/show_image_constants.dart';
import 'package:spendy_re_work/presentation/widgets/base_scaffold/base_scaffold.dart';
import 'package:spendy_re_work/presentation/widgets/circle_progress/linear_percent_indicator.dart';
import 'package:spendy_re_work/presentation/widgets/state_widget/empty_data_widget.dart';

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context,
      appBarTitle: ShowImageConstants.imageTitle,
      leading: true,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<ShowExpenseImageBloc, ShowExpenseImageState>(
        builder: (context, state) {
      if (state is ShowExpenseImageInitialState) {
        return Padding(
          padding: const EdgeInsets.symmetric(
                  horizontal: LayoutConstants.paddingHorizontal)
              .copyWith(top: LayoutConstants.dimen_10),
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (gridContext, index) {
                    return _imageWidget(
                        context, state.expense.photos[index], state);
                  },
                  childCount: state.expense.photos.length,
                ),
              )
            ],
          ),
        );
      }
      return const EmptyDataWidget();
    });
  }

  Widget _imageWidget(BuildContext context, PhotoEntity photo,
      ShowExpenseImageInitialState state) {
    if (state.imageDataState == ImageDataState.loading) {
      return Container(
        width: ShowImageConstants.imageSize,
        height: ShowImageConstants.imageSize,
        child: LinearPercentIndicator(
          percent: 0.3,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteList.showItemImage,
            arguments: {KeyConstants.imageUrlKey: photo.uri});
      },
      child: CachedNetworkImage(
        imageUrl: photo.uri!,
        width: ShowImageConstants.imageSize,
        height: ShowImageConstants.imageSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => LinearPercentIndicator(
          percent: 0.8,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
