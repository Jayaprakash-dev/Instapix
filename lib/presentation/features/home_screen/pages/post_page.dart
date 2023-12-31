// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery/presentation/features/home_screen/bloc/home_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {

  final HomeBloc homeBloc;

  const PostPage({super.key, required this.homeBloc});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  File? _image;
  ImageSource? _imageSource;
  final picker = ImagePicker();
  
  late final TextEditingController _titleController;
  late final TextEditingController _captionController;

  @override
  initState() {
    super.initState();
    _titleController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  Future getImage() async {

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post from'),
          actions: [
            Column(
              children: [
                const Icon(
                  Icons.photo_rounded,
                  size: 40,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Gallery'),
                  onPressed: () {
                    setState(() {
                      _imageSource = ImageSource.gallery;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Camera'),
                  onPressed: () {
                    setState(() {
                      _imageSource = ImageSource.camera;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );

    if (_imageSource == null) return;

    final pickedFile = await picker.pickImage(source: _imageSource!);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  OutlineInputBorder _buildInputBorderStyle() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190), width: 1),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Create Post', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              onPressed: _handlePostReq,
              child: const Text(
                'Post',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                ),
              )
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: InkWell(
                  onTap: getImage,
                  child: _image != null
                    ? Image.file(_image!)
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.add_a_photo),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    controller: _titleController,
                    autocorrect: false,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      enabledBorder: _buildInputBorderStyle(),
                      focusedBorder: _buildInputBorderStyle(),
                      errorBorder: _buildInputBorderStyle(),
                      focusedErrorBorder: _buildInputBorderStyle(),
                      label: const Text(
                        'Post title',
                        style: TextStyle(
                          color: Color.fromARGB(255, 168, 170, 179),
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  // caption
                  TextField(
                    controller: _captionController,
                    autocorrect: false,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      enabledBorder: _buildInputBorderStyle(),
                      focusedBorder: _buildInputBorderStyle(),
                      errorBorder: _buildInputBorderStyle(),
                      focusedErrorBorder: _buildInputBorderStyle(),
                      label: const Text(
                        'Write a caption',
                        style: TextStyle(
                          color: Color.fromARGB(255, 168, 170, 179),
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                    maxLines: null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePostReq() async {
    if (_image == null) {
      const SnackBar snackBar = SnackBar(
        content: Text('Image filed is empty'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    final String _title = _titleController.text.trim();
    if (_title.isEmpty) {
      const SnackBar snackBar = SnackBar(
        content: Text('Post title is empty'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    final String _caption = _captionController.text.trim();
    if (_caption.isEmpty) {
      const SnackBar snackBar = SnackBar(
        content: Text('Post caption is empty'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }
    post(_image!, _title, _caption);
  }

  //void _handlePostCancelReq() {
  //  Navigator.pop(context);
  //}
  
  void post(File imageData, String title, String caption) {
    widget.homeBloc.add(
      AddPost(
        image: imageData,
        title: title,
        caption: caption
      )
    );
    Navigator.of(context).pop();
  }
}