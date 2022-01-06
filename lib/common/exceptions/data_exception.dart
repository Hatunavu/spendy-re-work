class DataException implements Exception {
  final String error;
  final String? translateKey;

  const DataException({required this.error, this.translateKey});
}

class DataEmptyException extends DataException {
  DataEmptyException() : super(error: 'Data is empty');
}
