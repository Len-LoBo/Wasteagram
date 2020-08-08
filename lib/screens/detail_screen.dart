import 'package:wasteagram/models/post.dart';
import 'package:wasteagram/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:wasteagram/dateFormat.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DetailScreen extends StatefulWidget {

  DocumentSnapshot snapshot;

  DetailScreen({Key key, this.snapshot}): super(key:key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Post post;

  @override
  void initState() {
    super.initState();
    post = Post.fromSnapshot(snapshot: this.widget.snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                dateTimeToString(post.date),
                style: Styles.headerLarge
              ),
            ),
            AspectRatio(
              aspectRatio: 1/1,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
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
                    ),
                  ),
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
                
            Text(
              'Items: ${post.quantity}',
              style: Styles.headerLarge  
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                '( ${post.latitude},  ${post.longitute} )',
                style: Styles.textDefault  
              ),
            ),
          ],
        ),
      )
    );
  } 
}