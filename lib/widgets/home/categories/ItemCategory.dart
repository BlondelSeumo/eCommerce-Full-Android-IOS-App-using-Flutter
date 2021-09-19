import 'package:flutter/material.dart';

class ItemCategory extends StatelessWidget {
  final String image;
  final String type;
  
  ItemCategory({this.image,this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey)),
      child: type == 'url' ? Image.network(image) : Image.asset(image),
    );
  }
}