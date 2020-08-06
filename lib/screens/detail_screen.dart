import 'package:wasteagram/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:wasteagram/dateFormat.dart';


class DetailScreen extends StatefulWidget {

  DocumentSnapshot snapshot;

  DetailScreen({Key key, this.snapshot}): super(key:key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

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
                dateTimeToString(
                  DateTime.parse(widget.snapshot.data['date'].toDate().toString())
                ),
                style: Styles.headerLarge
              ),
            ),
            AspectRatio(
              aspectRatio: 1/1,
              child: Container(
                
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10.0,
                    spreadRadius: .5
                  ),],

                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.topCenter,
                    image: NetworkImage(widget.snapshot.data['url'])
                  )
                )
              ),
            ),
            Text(
              'Items: ${widget.snapshot.data['quantity']}',
              style: Styles.headerLarge  
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                '( ${widget.snapshot.data['latitude']},  ${widget.snapshot.data['longitude']} )',
                style: Styles.textDefault  
              ),
            ),
          ],
        ),
      )
    );
  }
}