import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';

class SetupFirebaseDatabase {
  FirebaseApp? app;
  FirebaseDatabase? database;
  CollectionReference? collectionRef;
  DocumentReference? categoriesDoc;
  DocumentReference? goalDoc;
  DocumentReference? profileDoc;
  DocumentReference? notifiDoc;

  Future init() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    await database!.setPersistenceEnabled(true);
    await database!.setPersistenceCacheSizeBytes(10000000);
    collectionRef = FirebaseFirestore.instance
        .collection(DefaultConfig.spendyCollection)
        .doc(DefaultConfig.environmentCollection)
        .collection(DefaultConfig.environment);
    categoriesDoc = collectionRef!.doc(DefaultConfig.categoriesDoc);
    goalDoc = collectionRef!.doc(DefaultConfig.goalDoc);
    profileDoc = collectionRef!.doc(DefaultConfig.profileDoc);
    notifiDoc = collectionRef!.doc(DefaultConfig.notifiCollection);
  }
}
