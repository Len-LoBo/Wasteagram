import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:wasteagram/styles.dart';
import 'package:flutter/material.dart';
import '../dateFormat.dart';
import 'package:wasteagram/screens/photo_page.dart';

import 'detail_page.dart';

class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wastegram')
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Fab(),
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
                      MaterialPageRoute(builder: (context) => DetailPage())
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
}

class Fab extends StatelessWidget {
  const Fab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoPage())
        );
      }
    );
  }
}