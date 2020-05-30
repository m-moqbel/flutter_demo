import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_demo/src/models/entities/post.dart';
import 'package:flutter_demo/src/models/loading_status.dart';
import 'package:flutter_demo/src/view_models/insert_post_view_model.dart';
import 'package:flutter_demo/src/widgets/image_widgets.dart';

class InsertPostPage extends StatefulWidget {
  @override
  _InsertPostPageState createState() {
    final vmFuture = initInsertPostViewModel();
    final state = _InsertPostPageState(vmFuture);
    return state;
  }
}

class _InsertPostPageState extends State<InsertPostPage> {
  final Future<InsertPostViewModel> _vmFuture;
  InsertPostViewModel _vm;
  final double _imgHeight = 350.0;
  bool _isCamera = false;

  PostDraft get _postDraft {
    return this._vm?.postDraft;
  }

  @override
  void initState() {
    _vmFuture.then((onValue) {
      _vm = onValue;
    });
    super.initState();
  }

  _InsertPostPageState(this._vmFuture);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New post'),
        actions:  [StreamBuilder<LoadingStatus>(
          stream: _vm?.loadingStatusStream,
          initialData: LoadingStatus.idle,
          builder: (BuildContext context, AsyncSnapshot<LoadingStatus> snapshot) {
            return iconAccordingToLoadingStatus(snapshot.data);
          },
        )],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _imageOrImagePickerAndTitleWidget(),
            bodyWidget(),
          ],
        ),
      ),
    );
  }

  Widget iconAccordingToLoadingStatus(LoadingStatus status) {
    var widget;
    if (status == LoadingStatus.idle)
      widget = IconButton(
        icon: Icon(Icons.save),
        onPressed: () async{
          final savedPost = await _vm.savePost();
          Navigator.pop(context, savedPost);
        },
      );
    else if(status == LoadingStatus.error)
      widget = IconButton(
        icon: Icon(Icons.error),
        onPressed: () async {
          final savedPost = await _vm.savePost();
          Navigator.pop(context, savedPost);
        },
      );
    else if(status == LoadingStatus.loading)
      widget = IconButton(
        icon: Icon(Icons.sync),
      );
    else
      widget = Container();
    return widget;
  }

  // Image and title widget part

  Widget _imageOrImagePickerAndTitleWidget() {
    List<Widget> childrenWidgets = [];

    var titleTextField = Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.8),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 3.0, right: 3.0),
            border: InputBorder.none,
            hintText: 'Title here',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          onChanged: (String value) {
            _postDraft.title = value;
          },
        ),
      ),
    );

    childrenWidgets = _imageOrImagePickerWidgets();
    childrenWidgets.add(titleTextField);

    return Stack(children: childrenWidgets);
  }

  List<Widget> _imageOrImagePickerWidgets() {
    return _postDraft?.image != null
        ? _createImageWidgets()
        : _createImagePickerWidgets();
  }

  List<Widget> _createImagePickerWidgets() {
    final Function onCameraPressed = () {
      markCameraFlag();
      assignImageThenRebuild();
    };

    final Function onGalleryPressed = () {
      markGalleryFlag();
      assignImageThenRebuild();
    };

    return imagePickerWidgets(
        imgHeight: _imgHeight,
        onCamera: onCameraPressed,
        onGallery: onGalleryPressed);
  }

  List<Widget> _createImageWidgets() {
    return postImageWidget(
        imgHeight: _imgHeight,
        imgFile: _vm?.postDraft?.image,
        context: context,
        onEditPressed: () {
          setState(() {
            _postDraft.image = null;
          });
        });
  }

  void assignImageThenRebuild() async {
    var image = await launchImagePicker();
    setState(() {
      this._postDraft?.image = image;
    });
  }

  Future<File> launchImagePicker() async {
    var source = _isCamera ? ImageSource.camera : ImageSource.gallery;
    var image = await ImagePicker.pickImage(source: source);
    return image;
  }

  void markCameraFlag() {
    this._isCamera = true;
  }

  void markGalleryFlag() {
    this._isCamera = false;
  }

  // Body widget and note

  Widget bodyWidget() {
    return Container(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Start typing',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 5.0, right: 5.0, top: 7.0, bottom: 7.0),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          onChanged: (value){
            _postDraft?.body = value;
          },
        )
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }
}
