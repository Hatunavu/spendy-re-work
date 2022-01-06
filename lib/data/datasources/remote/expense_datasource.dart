import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/configs/default_env.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/datasources/remote/base_remote_storage_datasource.dart';
import 'package:spendy_re_work/data/model/expense/expense_model.dart';

class ExpenseDataSource extends BaseRemoteStorageDataSource<ExpenseModel> {
  final SetupFirebaseDatabase setupFirebase;

  ExpenseDataSource({required this.setupFirebase});

  @override
  Future<bool> addModel(String uid, ExpenseModel model) async {
    final CollectionReference expenseCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(DefaultConfig.expenseCollection);
    await expenseCollectionRef.add(model.toJson());
    return false;
  }

  @override
  Future<ExpenseModel> getModel(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<bool> removeModel(String uid, {String? removeModel}) async {
    final CollectionReference expenseCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(DefaultConfig.expenseCollection);
    await expenseCollectionRef.doc(removeModel).delete();
    return false;
  }

  @override
  Future<bool> updateModel(String uid, ExpenseModel expense) async {
    final CollectionReference expenseCollectionRef =
        setupFirebase.collectionRef!.doc(uid).collection(DefaultConfig.expenseCollection);
    await expenseCollectionRef.doc(expense.id).update(expense.toJson());
    return false;
  }
}
