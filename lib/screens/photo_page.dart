import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wastegram')
      ),
      body: Center(child: Text("Photo Page"))
    );
  }
}