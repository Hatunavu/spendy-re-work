import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';

class ExpenseLocalDataSource {
  final SetupFirebaseDatabase setupFirebase;

  ExpenseLocalDataSource({required this.setupFirebase});

  bool addModel(String uid, ExpenseModel model) {
    final CollectionReference expenseCollectionRef = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    expenseCollectionRef.doc().set(model.toJson());
    return false;
  }

  bool removeModel(String uid, {String? removeModel}) {
    final CollectionReference expenseCollectionRef = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    expenseCollectionRef.doc(removeModel).delete();
    return false;
  }

  bool updateModel(String uid, ExpenseModel expense) {
    final CollectionReference expenseCollectionRef = setupFirebase
        .collectionRef!
        .doc(uid)
        .collection(DefaultConfig.expenseCollection);
    expenseCollectionRef.doc(expense.id).set(expense.toJson());
    return false;
  }
}
