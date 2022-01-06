import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spendy_re_work/domain/entities/category_entity.dart';
import 'package:spendy_re_work/domain/usecases/categories_usecase.dart';
import 'package:spendy_re_work/presentation/bloc/authentication_bloc/authentication_bloc.dart';

part 'list_category_event.dart';

part 'list_category_state.dart';

class ListCategoryBloc extends Bloc<ListCategoryEvent, ListCategoryState> {
  final CategoriesUseCase categoriesUseCase;
  final AuthenticationBloc auth;

  ListCategoryBloc(this.categoriesUseCase, this.auth)
      : super(ListCategoryInitial());

  @override
  Stream<ListCategoryState> mapEventToState(
    ListCategoryEvent event,
  ) async* {
    if (event is FetchListCategory) {
      yield* _mapFetchListCategoryToState(event);
    }
  }

  Stream<ListCategoryState> _mapFetchListCategoryToState(
      FetchListCategory event) async* {
    yield ListCategoryLoading();
    try {
      final expenseList = await categoriesUseCase.getCategoryListCate(
          auth.userEntity.uid!, event.categoryType!);
      yield ListCategoryLoaded(expenseList);
    } catch (e) {
      yield ListCategoryFailure();
    }
  }
}
