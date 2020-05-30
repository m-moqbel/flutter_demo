import 'dart:io';
import 'package:flutter_demo/src/models/helpers/db_helpers.dart';
import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/models/services/post_processing_service.dart';
import 'package:sqflite/sqflite.dart';


class PostModel{

  final Database  _database;
  final PostProcessingService _postProcessingService;

  PostModel(this._database, this._postProcessingService);

  Future<Post> createPost(PostDraft postDraft) async{
    final postAsMap = await _postProcessingService.presaveProcessing(postDraft);
    return await insertPost(postAsMap);
  }
  
  Future<Post> insertPost(Map<String, dynamic> map ) async{
    final id =
      await _database.insert(PostsTable.tableName, map);
    final post = convertSavedPostDraftMapToPostWithoutImage(id, map);
    return post;
  }

  Future<Post> findById(int id) async{
    List<Map> maps = await _database.query(PostsTable.tableName,
      where: '${PostsTable.id} = ?',
      whereArgs: [id]
    );

    if(maps.length == 0)
      return null;
    else
      return dbRecordToPost(maps.first);
  }

  Future<Post> findByText(String query) async{
      List<Map> maps = await _database.query(PostsTable.tableName,
        columns: [PostsTable.id, PostsTable.title, PostsTable.body],
        where: '${PostsTable.title} LIKE %?% OR ${PostsTable.body} LIKE %?%',
        whereArgs: [query]
      );

      if(maps.length == 0)
        return null;
      else
        return dbRecordToPost(maps.first);
  }

  Future<List<Post>> retrieveThisAmountOfPostsWithoutImage({int amount = 10}) async{
    final maps = await _database.query(
        PostsTable.tableName,
        orderBy: PostsTable.id + ' DESC',
        columns: [
          PostsTable.id, PostsTable.title, 
          PostsTable.body, PostsTable.thumbnailLocation
        ],
        limit: amount
    );
    return maps.map((map) => dbRecordToPost(map)).toList();
  }


  Post dbRecordToPost(Map map){

    final image  = map.containsKey(PostsTable.image)
        && map[PostsTable.image] != null ?
    _postProcessingService.base64ToBytes(map[PostsTable.image])  :
        null;
    final thumbnail = map.containsKey(PostsTable.thumbnailLocation)
        && map[PostsTable.thumbnailLocation] != null ?
        File(map[PostsTable.thumbnailLocation]) : null;


    return Post(
      map[PostsTable.id],
      map[PostsTable.title],
      map[PostsTable.body],
      image,
      thumbnail
    );
  }

  Post convertSavedPostDraftMapToPostWithoutImage(int id, Map<String, dynamic> map){
    map[PostsTable.id] = id;
    map.remove(PostsTable.image);
    return dbRecordToPost(map);
  }
  
}

Future<PostModel> initPostModel() async{
  return PostModel(await DBHelper.database, PostProcessingService());
}