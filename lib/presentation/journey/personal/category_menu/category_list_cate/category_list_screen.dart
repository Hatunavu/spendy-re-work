import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendy_re_work/common/constants/category_icon_map.dart';
import 'package:spendy_re_work/common/constants/category_name_map.dart';
import 'package:spendy_re_work/common/constants/icon_constants.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/presentation/journey/personal/category_menu/blocs/list_category_bloc/list_category_bloc.dart';
import 'package:spendy_re_work/presentation/theme/theme_color.dart';
import 'package:spendy_re_work/presentation/widgets/appbar/primary_appbar.dart';
import 'package:spendy_re_work/presentation/widgets/flare_widgets/alert_flare_widgets/error_flare_widget.dart';
import 'package:spendy_re_work/presentation/widgets/skeleton_widget/category_skeleton_widget.dart';

import '../category_menu_screen_constants.dart';
import '../item_category.dart';

class CategoryListScreen extends StatelessWidget {
  final String? title;

  const CategoryListScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarNormalWidget(
        title: title,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            IconConstants.backIcon,
            color: AppColor.iconColor,
          ),
        ),
      ),
      body: BlocConsumer<ListCategoryBloc, ListCategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ListCategoryLoading) {
            return CategorySkeletonWidget();
          }
          if (state is ListCategoryFailure) {
            return FailedFlareWidget(
              marginBottom: true,
              callback: () {
                BlocProvider.of<ListCategoryBloc>(context)
                    .add(FetchListCategory());
              },
            );
          } else if (state is ListCategoryLoaded) {
            return _buildListExpenseBody(context, state.expenseCates);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildListExpenseBody(
      BuildContext context, List<CategoryEntity> expenseCates) {
    return Padding(
      padding: EdgeInsets.only(
        left: CategoriesMenuScreenConstant.paddingLeft,
        top: CategoriesMenuScreenConstant.paddingTop,
      ),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: expenseCates.length + 1,
          itemBuilder: (context, index) {
            return index == expenseCates.length
                ? SizedBox(
                    height: CategoriesMenuScreenConstant.paddingBottom,
                  )
                : ItemCateGory(
                    iconPath: categoryIconMap[expenseCates[index].name]!,
                    showLineBottom: index < expenseCates.length - 1,
                    title: CategoryCommon
                        .categoryNameMap[expenseCates[index].name]!,
                  );
          }),
    );
  }
}
