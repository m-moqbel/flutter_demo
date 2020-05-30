
import 'dart:async';

import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/models/loading_status.dart';
import 'package:flutter_demo/src/models/post_model.dart';

class InsertPostViewModel{
  
  
  final PostModel _postModel;
  final _loadingStatusSC = StreamController<LoadingStatus>.broadcast();

  PostDraft _postDraft = PostDraft();

  InsertPostViewModel(this._postModel);

  PostDraft get  postDraft{
    return _postDraft;
  }


  Stream<LoadingStatus> get loadingStatusStream => _loadingStatusSC.stream;

  Future<Post> savePost(){

    _loadingStatusSC.sink.add(LoadingStatus.loading);

    return this._postModel.createPost(postDraft).then((onValue){
      _loadingStatusSC.sink.add(LoadingStatus.success);
      return onValue;
    }, onError: (e){
      print('error during creating post');
      print(e.toString());
      _loadingStatusSC.sink.add(LoadingStatus.error);
    });
  }

  void dispose(){
    _loadingStatusSC.close();    
  }

}

Future<InsertPostViewModel> initInsertPostViewModel() async{
  final model = await initPostModel();
  return InsertPostViewModel(model);
}