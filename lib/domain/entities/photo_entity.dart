import 'package:spendy_re_work/data/model/photo_model.dart';

class PhotoEntity {
  String? path;
  String? uri;

  PhotoEntity({this.path, this.uri});

  PhotoModel toModel() => PhotoModel(path: path);

  factory PhotoEntity.normal() => PhotoEntity(path: '', uri: '');
}
