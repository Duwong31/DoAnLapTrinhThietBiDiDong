// import 'dart:io';

// import '../models/models.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

// class UserMethods {
//   Database? _db;

//   String databaseName = "";

//   String tableName = "Call_Logs";

//   final String id = 'id';
//   final String email = 'email';
//   final String firstName = 'first_name';
//   final String lastName = 'last_name';
//   final String accessToken = 'access_token';
//   final String phoneNumber = 'phone_number';
//   final String refreshToken = 'refresh_token';
//   final String expiredAt = 'expired_at';

//   Future<Database> get db async {
//     if (_db != null) {
//       return _db!;
//     }
//     _db = await init();
//     return _db!;
//   }

//   void openDb(dbName) => (databaseName = dbName);

//   Future<Database> init() async {
//     final Directory dir = await getApplicationDocumentsDirectory();
//     final String path = join(dir.path, databaseName);
//     final db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     final String createTableQuery =
//         "CREATE TABLE $tableName ($id TEXT, $email TEXT, $firstName TEXT, $lastName TEXT, $accessToken TEXT, $phoneNumber TEXT, $refreshToken TEXT, $expiredAt TEXT)";

//     await db.execute(createTableQuery);
//   }

//   Future<void> add(UserModel user) async {
//     final dbClient = await db;
//     await dbClient.insert(tableName, user.toMap());
//   }

//   Future<void> update(UserModel userModel) async {
//     final dbClient = await db;

//     await dbClient.update(
//       tableName,
//       userModel.toMap(),
//       where: '$id = ?',
//       whereArgs: [userModel.id],
//     );
//   }

//   Future<UserModel?> getCurrentUser() async {
//     final dbClient = await db;

//     List<Map> maps = await dbClient.query(
//       tableName,
//       columns: [
//         id,
//         email,
//         firstName,
//         lastName,
//         accessToken,
//         phoneNumber,
//         refreshToken,
//         expiredAt,
//       ],
//     );
//     if (maps.isNotEmpty) {
//       return UserModel.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> delete(String id) async {
//     final client = await db;
//     return await client.delete(tableName, where: '$id = ?', whereArgs: [id]);
//   }

//   Future<void> close() async {
//     final dbClient = await db;
//     dbClient.close();
//   }

//   Future<void> clear() async {
//     final dbClient = await db;
//     dbClient.delete(tableName);
//   }
// }
