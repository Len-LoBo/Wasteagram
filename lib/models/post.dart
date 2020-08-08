import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  DateTime date;
  String imageUrl;
  int quantity;
  double latitude;
  double longitute;

  Post();

  Post.fromSnapshot({DocumentSnapshot snapshot}){
    this.date = snapshot.data['date'].toDate();
    this.imageUrl = snapshot.data['url'];
    this.quantity = snapshot.data['quantity'];
    this.latitude = snapshot.data['latitude'];
    this.longitute = snapshot.data['longitude'];
  }
}

