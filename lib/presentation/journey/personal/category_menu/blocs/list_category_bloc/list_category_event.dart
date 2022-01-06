part of 'list_category_bloc.dart';

abstract class ListCategoryEvent extends Equatable {
  const ListCategoryEvent();
}

class FetchListCategory extends ListCategoryEvent {
  final String? categoryType;

  FetchListCategory({this.categoryType});

  @override
  List<Object> get props => [];
}
