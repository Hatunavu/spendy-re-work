abstract class BaseRemoteStorageDataSource<Model> {
  Future<Model?> getModel(String uid);

  Future<bool> addModel(String uid, Model model);

  Future<bool> updateModel(String uid, Model user);

  Future<bool> removeModel(String uid);
}
