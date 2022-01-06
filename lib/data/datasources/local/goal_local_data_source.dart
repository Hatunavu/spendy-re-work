import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/goal_model.dart';

class GoalLocalDataSource {
  final SetupFirebaseDatabase setupFirebase;

  GoalLocalDataSource({required this.setupFirebase});

  bool createGoal({String? uid, GoalModel? goal}) {
    final CollectionReference goalCollectionRef =
        setupFirebase.goalDoc!.collection(uid!);
    goalCollectionRef.doc().set(goal!.toJson());
    return false;
  }

  bool updateGoal({String? uid, GoalModel? goal}) {
    final CollectionReference goalCollectionRef =
        setupFirebase.goalDoc!.collection(uid!);
    goalCollectionRef.doc(goal!.id).set(goal.toJson());
    return false;
  }
}
