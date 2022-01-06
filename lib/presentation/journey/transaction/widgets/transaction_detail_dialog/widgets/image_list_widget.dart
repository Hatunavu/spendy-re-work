import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spendy_re_work/common/constants/image_data_state.dart';
import 'package:spendy_re_work/domain/entities/photo_entity.dart';
import 'package:spendy_re_work/presentation/journey/transaction/transaction_constants.dart';
import 'package:spendy_re_work/presentation/journey/transaction/widgets/transaction_detail_dialog/transaction_detail_dialog_constants.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/theme/theme_text.dart';
import 'package:spendy_re_work/presentation/widgets/circle_progress/linear_percent_indicator.dart';

class ImageListWidget extends StatelessWidget {
  final List<PhotoEntity>? imageList;
  final Function()? onShowMorePicture;
  final ImageDataState? state;

  const ImageListWidget({
    Key? key,
    this.imageList,
    this.onShowMorePicture,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: TransactionConstants.transactionDialogPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(flex: 1, child: _imageWidget(imageList![0].uri!)),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              flex: 1,
              child: imageList!.length >= 2
                  ? _imageWidget(imageList![1].uri!)
                  : const SizedBox()),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              flex: 1,
              child: imageList!.length >= 3
                  ? Stack(
                      children: [
                        _imageWidget(imageList![2].uri!),
                        _showMoreImage(),
                      ],
                    )
                  : const SizedBox()),
        ],
      ),
    );
  }

  Widget _imageWidget(String url) {
    if (state == ImageDataState.loading) {
      return Container(
        height: TransactionDetailDialogConstants.imageSize,
        width: TransactionDetailDialogConstants.imageSize,
        child: LinearPercentIndicator(
          percent: 0.3,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: TransactionDetailDialogConstants.imageSize,
      width: TransactionDetailDialogConstants.imageSize,
      fit: BoxFit.cover,
      placeholder: (context, url) => LinearPercentIndicator(
        percent: 0.8,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _showMoreImage() {
    return Visibility(
      visible: imageList!.length > 3,
      child: GestureDetector(
        onTap: onShowMorePicture,
        child: Container(
          height: TransactionDetailDialogConstants.imageSize,
          width: TransactionDetailDialogConstants.imageSize,
          color: Colors.black38,
          alignment: Alignment.center,
          child: Text(
            '+${imageList!.length - 3} more',
            style: ThemeText.getDefaultTextTheme()
                .caption
                ?.copyWith(color: AppColor.white),
          ),
        ),
      ),
    );
  }
}
