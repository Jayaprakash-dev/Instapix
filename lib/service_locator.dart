import 'dart:io';

import 'package:gallery/data/repos/local/authentication_datastore_impl.dart';
import 'package:gallery/data/repos/local/local_datastore_impl.dart';
import 'package:gallery/domain/repos/local/authentication_datastore.dart';
import 'package:gallery/domain/repos/local/local_datastore.dart';
import 'package:gallery/domain/usecases/authentication_usecases/login_user.dart';
import 'package:gallery/domain/usecases/authentication_usecases/logout_user.dart';
import 'package:gallery/domain/usecases/authentication_usecases/register_user.dart';
import 'package:gallery/domain/usecases/authentication_usecases/user_validator.dart';
import 'package:gallery/domain/usecases/data_usecases/add_post.dart';
import 'package:gallery/domain/usecases/data_usecases/get_all_post.dart';
import 'package:gallery/presentation/features/auth_screen/bloc/auth_bloc.dart';
import 'package:gallery/presentation/features/home_screen/bloc/home_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

GetIt services = GetIt.instance;

void loadDependencies() {

  // sqflite db
  services.registerSingletonAsync<Database>(
    () async {
      String dbPath = await getDatabasesPath();
      dbPath = path.join(dbPath, 'flutter_gallery_app_db.db');

      final File dbFile = File(dbPath);
      //await dbFile.delete();
      late final Database db;

      if (await dbFile.exists()) {
        db = await openDatabase(dbPath, version: 1);
      } else {
        db = await openDatabase(
          dbPath,
          version: 1,
          onCreate: (db, version) async {
            await db.execute(
              '''
                CREATE TABLE user (
                  user_id  INTEGER PRIMARY KEY AUTOINCREMENT,
                  user_name TEXT UNIQUE NOT NULL,
                  user_email TEXT UNIQUE NOT NULL,
                  user_password TEXT NOT NULL
                );

                CREATE TABLE posts (
                  image_id INTEGER PRIMARY KEY AUTOINCREMENT,
                  image TEXT NOT NULL,
                  title TEXT NOT NULL,
                  caption TEXT NOT NULL
                );
              '''
            );
          },
        );
      }

      return db; 
    },
    dispose: (db) => db.close(),
  );


  // shared preferences
  services.registerSingletonAsync<SharedPreferences>(
    () async {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if (sharedPreferences.getBool('userLoginStatus') == null) {
        await sharedPreferences.setBool('userLoginStatus', false);
      }

      return sharedPreferences;
    }
  );

  // repo objects
  // authentication  datastore repo
  services.registerSingletonWithDependencies<AuthenticationDatastore>(
    () => AuthenticationDatastoreImpl(db: services<Database>(), sharedPreferences: services<SharedPreferences>()),
    dependsOn: [ Database, SharedPreferences ]
  );

  services.registerSingletonWithDependencies<LocalDatastore>(
    () => LocalDatastoreImpl(db: services<Database>()),
    dependsOn: [ Database ]
  );

  //usecases
  services.registerSingletonWithDependencies<UserValidatorUseCase>(
    () => UserValidatorUseCase(authenticationDatastore: services<AuthenticationDatastore>()),
    dependsOn: [ AuthenticationDatastore ]
  );

  services.registerSingletonWithDependencies<RegisterUserUseCase>(
    () => RegisterUserUseCase(authenticationDatastore: services<AuthenticationDatastore>()),
    dependsOn: [ AuthenticationDatastore ]
  );

  services.registerSingletonWithDependencies<LoginUserUseCase>(
    () => LoginUserUseCase(authenticationDatastore: services<AuthenticationDatastore>()),
    dependsOn: [ AuthenticationDatastore ]
  );

  services.registerSingletonWithDependencies<LogoutUserUseCase>(
    () => LogoutUserUseCase(authenticationDatastore: services<AuthenticationDatastore>()),
    dependsOn: [ AuthenticationDatastore ]
  );

  services.registerSingletonWithDependencies<AddPostUseCase>(
    () => AddPostUseCase(localDatastore: services<LocalDatastore>()),
    dependsOn: [ LocalDatastore ]
  );

  services.registerSingletonWithDependencies<GetAllPostsUseCase>(
    () => GetAllPostsUseCase(localDatastore: services<LocalDatastore>()),
    dependsOn: [ LocalDatastore ]
  );


  // bloc objects
  services.registerSingletonWithDependencies<AuthBloc>(
    () => AuthBloc(
      registerUserUseCase: services<RegisterUserUseCase>(),
      loginUserUseCase: services<LoginUserUseCase>(),
      logoutUserUseCase: services<LogoutUserUseCase>()
    ),
    dependsOn: [ RegisterUserUseCase, LoginUserUseCase, LogoutUserUseCase ]
  );

  services.registerFactory<HomeBloc>(
    () => HomeBloc(
      addPostUseCase: services<AddPostUseCase>(),
      getAllPostsUseCase: services<GetAllPostsUseCase>(),
    ),
  );
}