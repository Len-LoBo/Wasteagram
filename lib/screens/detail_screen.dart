import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';


class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      body: Center(child: Text("Detail Page"))
    );
  }
}