import 'package:flutter_demo/src/models/helpers/db_helpers.dart';
import 'package:flutter_demo/src/models/services/post_processing_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_demo/src/models/post_model.dart';

class MockDatabase extends Mock implements Database{}
class MockPostProcessingService extends Mock implements PostProcessingService{}

void main(){
  
  group('Posts', (){


    final database = MockDatabase();
    final processingService = PostProcessingService();

    final Map<String, dynamic>postAsMap = {
      PostsTable.title: 'title one',
      PostsTable.body: 'body one',
      PostsTable.thumbnailLocation: 'thumbnail location one'
    };

    when(
        database.insert(PostsTable.tableName, postAsMap)
    ).thenAnswer((_) async => 14 );

    test('Insert Post', () async{

      final postModel = PostModel(database, processingService);
      final savedPost = await postModel.insertPost(postAsMap);
      expect(savedPost.title, postAsMap[PostsTable.title]);
      expect(savedPost.id, 14);
    });

  });

}

