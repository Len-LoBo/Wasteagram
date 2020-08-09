import 'package:wasteagram/components/photo_box_decoration.dart';
import 'package:wasteagram/models/post.dart';
import 'package:wasteagram/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:wasteagram/dateFormat.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DetailScreen extends StatefulWidget {

  final DocumentSnapshot snapshot;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth < 500 ? 
              VerticalLayout(post: post) : HorizontalLayout(post: post);  
          }
        )
      )
    );
  } 
}

class HorizontalLayout extends StatelessWidget {
  const HorizontalLayout({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DetailPageFrame(post: post, padding: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DateHeading(post: post),
            ItemQuantity(post: post),
            LocationDisplay(post: post),
          ],
        ),
      ],
    );
  }
}

class VerticalLayout extends StatelessWidget {
  const VerticalLayout({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DateHeading(post: post),
        DetailPageFrame(post: post),
        ItemQuantity(post:post),
        LocationDisplay(post: post)
      ],
    );
  }
}

class DetailPageFrame extends StatelessWidget {
  const DetailPageFrame({
    Key key,
    @required this.post,
    this.padding = 40.0,
  }) : super(key: key);

  final Post post;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1/1,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: CachedNetworkImage(
          imageUrl: post.imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: photoBoxDecoration(imageProvider)
          ),
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(100.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class DateHeading extends StatelessWidget {
  const DateHeading({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        dateTimeToString(post.date),
        style: Styles.headerLarge
      ),
    );
  }
}


class LocationDisplay extends StatelessWidget {
  const LocationDisplay({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Text(
        '( ${post.latitude},  ${post.longitute} )',
        style: Styles.textDefault  
      ),
    );
  }
}

class ItemQuantity extends StatelessWidget {
  const ItemQuantity({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Items: ${post.quantity}',
      style: Styles.headerLarge  
    );
  }
}