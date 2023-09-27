// ignore_for_file: avoid_print

import 'package:gallery/core/data_state/auth_state.dart';
import 'package:gallery/domain/repos/local/authentication_datastore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AuthenticationDatastoreImpl implements AuthenticationDatastore {

  final Database _db;
  final SharedPreferences _sharedPreferences;

  AuthenticationDatastoreImpl({
    required Database db,
    required SharedPreferences sharedPreferences,
  }) : _db = db, _sharedPreferences = sharedPreferences;

  @override
  Future<AuthDataState> register({required String name, required String emailId, required String password}) async {
    try {

      final Map<String, Object?> data = {
        'user_name': name,
        'user_email': emailId,
        'user_password': password,
      };

      if (await isUsernameExists(name)) return UserNameAlreadyExistsException(Exception('Unique contraint error - `user_name` coulmn'));

      if (await isUserMailExists(emailId)) return UserMailAlreadyExistsException(Exception('Unique contraint error - `user_email` coulmn'));

      await _db.insert(
        'user',
        data,
        conflictAlgorithm: ConflictAlgorithm.fail
      );

      final List<Map<String, Object?>> users = await _db.query('user');
      for (Map<String, Object?> user in users) {
        print('registered users:');
        print(user);
      }

      await _sharedPreferences.setBool('userLoginStatus', true);

      return AuthDataSuccessState();

    } on DatabaseException catch (e) {
      return AuthDataExceptionState(e);
    } on Exception catch (e) {
      return AuthDataExceptionState(e);
    }
  }

  @override
  Future<AuthDataState> logIn({String? name, String? emailId, required String password}) async {
    try {

      final List<Map<String, Object?>> res = await _db.query(
        'user',
        columns: [ 'user_name', 'user_email', 'user_password' ],
        where: name != null ? 'user_name = ?' : 'user_email = ?',
        whereArgs: [ name ?? emailId ]
      );

      if (res.isEmpty) return UserNotFoundException(Exception('User data not found'));

      if (res[0]['user_password'] != password) return UserCredentialsException(Exception('Incorrect credentials'));

      await _sharedPreferences.setBool('userLoginStatus', true);

      return AuthDataSuccessState();

    } on DatabaseException catch (e) {
      return AuthDataExceptionState(e);
    } on Exception catch (e) {
      return AuthDataExceptionState(e);
    }
  }

  @override
  Future<bool> logOut() async {
    return await _sharedPreferences.setBool('userLoginStatus', false);
  }

  @override
  Future<bool> isUsernameExists(String username) async {
    final List<Map<String, Object?>> res = await _db.query(
      'user',
      columns: ['user_name'],
      where: 'user_name = ?',
      whereArgs: [ username ]
    );

    if (res.isNotEmpty) return true;

    return false;
  }

  @override
  Future<bool> isUserMailExists(String mailId) async {
    final List<Map<String, Object?>> res = await _db.query(
      'user',
      columns: ['user_email'],
      where: 'user_email = ?',
      whereArgs: [ mailId ]
    );

    if (res.isNotEmpty) return true;

    return false;
  }
}