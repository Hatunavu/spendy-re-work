import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MockLocalPreferences extends Mock implements LocalPreferences {}

class LocalPreferences {
  SharedPreferences? sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> set(String key, dynamic value) {
    assert(
      value is bool ||
          value is double ||
          value is int ||
          value is String ||
          value is List<String>,
      'Unsupported type',
    );

    final Map<Type, Function> typeResolvers = {
      bool: sharedPreferences!.setBool,
      double: sharedPreferences!.setDouble,
      int: sharedPreferences!.setInt,
      String: sharedPreferences!.setString,
      List: sharedPreferences!.setStringList
    };

    return typeResolvers[value.runtimeType]!(key, value);
  }

  dynamic get(String key) => sharedPreferences!.get(key);

  Future<bool> remove(String key) => sharedPreferences!.remove(key);
}
