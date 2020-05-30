
import 'package:flutter/material.dart';
import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/pages/insert_post_page.dart';
import 'package:flutter_demo/src/view_models/posts_view_model.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() {
    final vmFuture = initPostViewModel();
    return _PostsPageState(vmFuture);
  }
}

class _PostsPageState extends State<PostsPage> {
  final Future<PostsViewModel> _vmFuture;
  PostsViewModel _vm;
  List<Post> _posts;

  _PostsPageState(this._vmFuture);

  @override
  void initState() {
    _vmFuture.then((onValue) {
      _vm = onValue;
      _vm.retrieveAListOfPosts().then((onValue) {
        setState(() {
          _posts = onValue;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Posts'),
      ),
        body: _posts == null ? Container() : ListView.builder(
          itemCount: _posts?.length,
          itemBuilder: (context, index) {

            String reduceNumberOfChar(String body){
              return body.substring(0,
                  _posts[index].body.length < 69 ?
                  _posts[index].body.length : 70
              ) + ' ...';
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: _posts[index].thumbnail != null ?
                  Image.file(_posts[index].thumbnail)
                  : Container(),
                ),
                title: Text(_posts[index].title),
                // ignore: null_aware_before_operator
                subtitle: Text(reduceNumberOfChar(_posts[index].body)),
              ),
            );

          }),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var savedPost = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => InsertPostPage())
          );
          setState(() {
            _posts.insert(0,savedPost);
          });
        },
      ),
    );
  }

}
