import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductPhotoView extends StatefulWidget {
  final image;
  ProductPhotoView({Key key, this.image}) : super(key: key);

  @override
  _ProductPhotoViewState createState() => _ProductPhotoViewState();
}

class _ProductPhotoViewState extends State<ProductPhotoView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: PhotoView(
                imageProvider: NetworkImage(widget.image),
              )
          ),
          Positioned(
            top: 25,
            left: 15,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.cancel, color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}