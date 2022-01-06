import 'package:spendy_re_work/domain/entities/photo_entity.dart';

class PhotoModel extends PhotoEntity {
  PhotoModel({String? path, String uri = ''}) : super(path: path!, uri: uri);

  factory PhotoModel.createPath({String? path}) {
    return PhotoModel(path: path);
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(path: json['path'], uri: json['uri']);
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'uri': uri,
      };
}
