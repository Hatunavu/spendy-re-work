class NetWorkException implements Exception {
  final String error;
  final String? translateKey;

  const NetWorkException({required this.error, this.translateKey});
}

class NoInternetException extends NetWorkException {
  NoInternetException()
      : super(
          error: 'No internet',
        );
}
