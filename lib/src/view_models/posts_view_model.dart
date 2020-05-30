
import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/models/post_model.dart';

class PostsViewModel{

  final PostModel _postModel;

  List<Post> _postsList;

  PostsViewModel(this._postModel);

  get postsList{
    return this._postsList;
  }

  Future<List<Post>> retrieveAListOfPosts(){
    return _postModel.retrieveThisAmountOfPostsWithoutImage(amount: 10).then((onValue){
      _postsList = onValue;
      return onValue;
    });
  }


}

Future<PostsViewModel> initPostViewModel() async{
  final model = await initPostModel();
  return PostsViewModel(model);
}