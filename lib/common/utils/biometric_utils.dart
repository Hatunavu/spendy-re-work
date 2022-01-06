import 'package:local_auth/local_auth.dart';

class BioMetricUtils {
  LocalAuthentication localAuth = LocalAuthentication();

  Future<BiometricType?> getBiometricType() async {
    final List<BiometricType> bios = await localAuth.getAvailableBiometrics();
    if ( //bios != null &&
        bios.isNotEmpty) {
      return bios[0];
    } else {
      return null;
    }
  }
}
