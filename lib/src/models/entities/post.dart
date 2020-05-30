

import 'dart:io';
import 'dart:typed_data';


class PostDraft{

  String title;
  String body;
  File image;

  PostDraft({this.title, this.body, this.image});



}

class Post{

  final int id;
  final String title;
  final String body;
  final Uint8List image;
  final File thumbnail;

  Post(this.id, this.title, this.body, this.image, this.thumbnail);


}