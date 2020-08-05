import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:wasteagram/styles.dart';
import 'package:flutter/material.dart';
import '../dateFormat.dart';
import 'package:wasteagram/screens/photo_screen.dart';

import 'detail_screen.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {

  final picker = ImagePicker();

  Future<File> getPhoto() async {
    final pickedFile = await picker.getImage(source:ImageSource.camera);
      return File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: fab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: StreamBuilder(
        stream: Firestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
        builder: (content, snapshot) {    
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                var post = snapshot.data.documents[index];
                return ListTile(
                  dense: true,
                  title: 
                    Text(dateTimeToString(DateTime.parse(post['date'].toDate().toString())), 
                    style: Styles.textDefault),
                  trailing: Text(post['quantity'].toString(), style: Styles.largeDisplayNumber),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen())
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
          
        }
      )
    );
  }

  Widget fab() {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      onPressed: () async {
        File image = await getPhoto();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoScreen(image: image))
        );
      }
    );
  }
  
}


