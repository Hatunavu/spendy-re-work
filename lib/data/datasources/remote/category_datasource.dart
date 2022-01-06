import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendy_re_work/common/constants/firebase_storage_constants.dart';
import 'package:spendy_re_work/common/firebase_setup.dart';
import 'package:spendy_re_work/data/model/catergory_model.dart';

class CategoryDataSource {
  final SetupFirebaseDatabase setupFirebase;

  CategoryDataSource({required this.setupFirebase});

  Future<List<CategoryModel>> getCategoryList(
      String uid, String typeValue) async {
    final categories = <CategoryModel>[];
    try {
      final categoryQuery = await setupFirebase.collectionRef!
          .doc(uid)
          .collection(FirebaseStorageConstants.categoryCollection)
          .where(FirebaseStorageConstants.categoryType, isEqualTo: typeValue)
          .orderBy(FirebaseStorageConstants.createAtField)
          .get();
      for (final doc in categoryQuery.docs) {
        final categoryModel = CategoryModel.fromJson(doc.data(), doc.id);
        categories.add(categoryModel);
      }
    } on Exception catch (e) {
      throw FirebaseException(
          plugin: 'Spendy',
          message:
              'CategoryDataSource - getCategoryList - error: ${e.toString()}');
    }
    return categories;
  }

  Future createDefaultCategory(
      String uid, List<CategoryModel> categories) async {
    final collectionRef = setupFirebase.collectionRef!
        .doc(uid)
        .collection(FirebaseStorageConstants.categoryCollection);
    final batch = FirebaseFirestore.instance.batch();
    for (final category in categories) {
      batch.set(collectionRef.doc(), category.toJson());
    }
    await batch.commit();
  }
}
