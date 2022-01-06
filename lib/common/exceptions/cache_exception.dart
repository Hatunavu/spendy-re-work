class CacheException implements Exception {
  final List<String> errors;

  CacheException([this.errors = const []]);
}
