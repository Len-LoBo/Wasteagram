import 'package:flutter/material.dart';

BoxDecoration photoBoxDecoration(ImageProvider imageProvider) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 5,
        spreadRadius: 2)],
    image: DecorationImage(
      image: imageProvider,
      fit: BoxFit.cover
    )
  );
}
