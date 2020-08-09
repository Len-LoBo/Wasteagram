import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  DateTime date;
  String imageUrl;
  int quantity;
  double latitude;
  double longitude;

  Post();

  Post.fromMap(Map<String,dynamic> map) {
    this.date = map['date'];
    this.imageUrl = map['imageUrl'];
    this.quantity = map['quantity'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
  }

  Post.fromSnapshot({DocumentSnapshot snapshot}){
    this.date = snapshot.data['date'].toDate();
    this.imageUrl = snapshot.data['imageUrl'];
    this.quantity = snapshot.data['quantity'];
    this.latitude = snapshot.data['latitude'];
    this.longitude = snapshot.data['longitude'];
  }
}

