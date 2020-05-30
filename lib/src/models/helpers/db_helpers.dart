import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  static final String _dbName = 'safe_garden_database.db';

  static Future<void> _createPostsTableV2(Database db){
    return db.execute(
        """
          CREATE TABLE ${PostsTable.tableName}(
            ${PostsTable.id}  INTEGER PRIMARY KEY,
            ${PostsTable.title} TEXT   NOT NULL ,
            ${PostsTable.body}  TEXT   NOT NULL ,
            ${PostsTable.image}  TEXT  NOT NULL,
            ${PostsTable.thumbnailLocation}  TEXT
          )
          """
    );
  }

  static Future<void> _updatePostsTableV1ToV2(Database db){
    return 
      db.execute(
          "ALTER TABLE ${PostsTable.tableName} ADD  ${PostsTable.thumbnailLocation} TEXT"
      );
  }

  static final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(join(path, _dbName),
      onCreate: (db, version) async {
        await _createPostsTableV2(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async{
        if(oldVersion == 1)
          await _updatePostsTableV1ToV2(db);
      },
      version: 2,
    );
  });

}

class PostsTable {
  static final String tableName = "posts";
  static final String id = "id";
  static final String title = "title";
  static final String body = "body";
  static final String image = "image";
  static final String thumbnailLocation = "thumbnail_location";
}
