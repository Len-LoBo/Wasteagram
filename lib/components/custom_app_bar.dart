import 'package:flutter/material.dart';
import 'package:wasteagram/styles.dart';

class CustomAppBar extends StatelessWidget {

  final String title;

  CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: Styles.navBarTitle),
    );
  }
}