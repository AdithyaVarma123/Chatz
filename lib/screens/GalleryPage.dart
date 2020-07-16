import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  String imagePath;
  GalleryPage({this.imagePath});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Container(
          color: Colors.black,
        child: Center(
          child: Image.network(
          imagePath
          ),
        ),
      ),
    );
  }
}
