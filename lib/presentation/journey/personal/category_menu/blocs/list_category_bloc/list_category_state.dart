part of 'list_category_bloc.dart';

abstract class ListCategoryState extends Equatable {
  const ListCategoryState();
}

class ListCategoryInitial extends ListCategoryState {
  @override
  List<Object> get props => [];
}

class ListCategoryLoading extends ListCategoryState {
  @override
  List<Object> get props => [];
}

class ListCategoryLoaded extends ListCategoryState {
  final List<CategoryEntity> expenseCates;

  ListCategoryLoaded(this.expenseCates);

  @override
  List<Object> get props => [];
}

class ListCategoryFailure extends ListCategoryState {
  @override
  List<Object> get props => [];
}
