
import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/models/helpers/db_helpers.dart';

class PostProcessingService{


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  Future<Map<String, dynamic>> presaveProcessing(PostDraft postDraft) async{
    final  Map<String, dynamic> record = {
      PostsTable.title: postDraft.title,
      PostsTable.body: postDraft.body,
    };

    if(postDraft.image != null) {
      record[PostsTable.image] = await _fileToBase64(postDraft.image);
      record[PostsTable.thumbnailLocation] =
          await createThumbnail(
              postDraft.image,
              generateFileName()
          );
    }

    return record;
  }

  Future<String> createThumbnail(File image, String fileName) async{
    final decodedImage = decodeImage(await image.readAsBytes());
    final thumbnail = copyResize(decodedImage, width: 75);
    return await saveImageAsJPG(thumbnail, fileName);
  }

  Future<String> _fileToBase64(File image) async{
    // Unit8List or  List<int>
    if(image == null)
      return null;

    final Uint8List imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Uint8List base64ToBytes(String base64){
    Uint8List bytes = base64Decode(base64);
    return bytes;
  }

  Future<String> saveImageAsJPG(Image image, String fileName) async{
    final filePath = await _localPath + fileName + 'jpg';
    await File(filePath).writeAsBytes(encodeJpg(image));
    return filePath;
  }

  String generateFileName(){
    return DateTime.now().millisecondsSinceEpoch.toString();
  }





}