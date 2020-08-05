import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'components/custom_app_bar.dart';
import 'screens/post_list_screen.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:  PostListScreen(),
    );
  }
}