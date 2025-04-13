// import '../models/models.dart';

// import 'user_methods.dart';

// class UserDBRepositories {
//   static late UserMethods dbObject;

//   static Future<void> init({required String dbName}) async {
//     dbObject = UserMethods();
//     dbObject.openDb(dbName);
//     dbObject.init();
//   }

//   static Future<void> close() => dbObject.close();
//   static Future<int> delete(String id) => dbObject.delete(id);
//   static Future<void> add(UserModel user) => dbObject.add(user);
//   static Future<UserModel?> getCurrentUser() => dbObject.getCurrentUser();
//   static Future<void> clear() => dbObject.clear();
// }
