//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';
//
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:spendy_re_work/data/datasources/remote/auth_firebase_remote_datasource.dart';
//
//class MockFirebaseAuth extends Mock implements FirebaseAuth {}
//
//void main() {
//  FirebaseAuthRemoteDataSource firebaseAuthRemoteDataSource;
//
//  setUp(() async{
//    await Firebase.initializeApp();
//    firebaseAuthRemoteDataSource = FirebaseAuthRemoteDataSource();
//  });
//
//  group('Verify sign in', () {
//    final completed = (credential) {};
//    final failed = (error) {};
//    final codesent = (s, [i]) {};
//    final phone = '0123456789';
//
//    test('should call FirebaseAuth to verify Phone Number', () async {
//      await firebaseAuthRemoteDataSource.verifyPhoneNumber(
//          completed: any, failed: any, timeout: any, codeSent: any, phone: any);
//      verify(firebaseAuthRemoteDataSource.verifyPhoneNumber(
//          completed: completed,
//          failed: failed,
//          codeSent: codesent,
//          phone: phone));
//    });
//  });
//}
