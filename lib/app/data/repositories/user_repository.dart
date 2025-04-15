part of 'repositories.dart';

abstract class UserBase {
  Future<bool> toggleNotify(bool val);
  Future<UserModel> getDetail();
  Future<UserModel> uploadAvatar(Uint8List bytes);
  Future<UserModel?> updateUser(Map<String, dynamic> data);
  Future<UserModel> updateUserProfile(Map<String, dynamic> data);
  Future<int?> uploadFile(File file, int folderId);
  Future<Dashboard> getDashboard();
  Future<UserModel> deleteRecipient();
  Future<UserModel> restoreRecipient();
  Future<bool> addAddress(String address, String apartment);
  Future<bool> verifyInformation(Map<String, dynamic> body);
}

class UserRepository extends BaseRepository implements UserBase {
  @override
  Future<UserModel> getDetail() {
    return handleCall(() => ApiProvider.getDetail());
  }

  @override
  Future<UserModel?> updateUser(Map<String, dynamic> data) {
    return handleCall(() => ApiProvider.updateUser(data));
  }

  @override
  Future<UserModel> updateUserProfile(Map<String, dynamic> data){
    return handleCall(() => ApiProvider.updateUserProfile(data));
  }

  @override
  Future<UserModel> uploadAvatar(Uint8List bytes) {
    return handleCall(() => ApiProvider.uploadAvatar(bytes));
  }
  @override
  Future<int?> uploadFile(File file, int folderId) {
    return handleCall(() => ApiProvider.uploadFile(file, folderId));
  }

  @override
  Future<bool> toggleNotify(bool val) {
    return handleCall(() => ApiProvider.toggleNotify(val));
  }

  @override
  Future<Dashboard> getDashboard() {
    return handleCall(() => ApiProvider.getDashboard());
  }
  
  @override
  Future<UserModel> deleteRecipient() {
    return handleCall(() => ApiProvider.deleteRecipient());
  }
  
  @override
  Future<UserModel> restoreRecipient() {
    return handleCall(() => ApiProvider.restoreRecipient());
  }
  
  @override
  Future<bool> addAddress(String address, String apartment) {
    return handleCall(() => ApiProvider.addAddress(address, apartment));
  }

  @override
  Future<bool> verifyInformation(Map<String, dynamic> body) {
    return handleCall(() => ApiProvider.verifyInformation(body));
  }
}
