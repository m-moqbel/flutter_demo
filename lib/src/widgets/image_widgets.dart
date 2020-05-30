
import 'dart:io';

import 'package:flutter/material.dart';

List<Widget> imagePickerWidgets
    ({
  @required double imgHeight, @required Function onCamera,
  @required Function onGallery }) {

  return [
    Container(
      height: imgHeight,
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        ),
      ),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      top: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                onCamera();
              },
              iconSize: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                onGallery();
              },
              iconSize: 50,
            ),
          )
        ],
      ),
    ),

  ];
}



List<Widget> postImageWidget({
  @required double imgHeight,
  @required File imgFile,
  @required BuildContext context,
  @required Function onEditPressed

}) {
  return [
    Container(
      child: FittedBox(
        child: Image.file(imgFile),
        fit: BoxFit.cover,
      ),
      height: imgHeight,
      width: MediaQuery.of(context).size.width,
    ),
    Positioned(
      top: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              onEditPressed();
            },
          ),
        ),
      ),
    ),
  ];
}
