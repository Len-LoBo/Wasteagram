import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Post created from snapshot', () async {

    final instance = MockFirestoreInstance();
    await instance.collection('posts').add({
      'date': Timestamp.now(),
      'quantity': 2,
      'imageUrl': "imageurl.jpg",
      'latitude': 100.2,
      'longitude': 55.5
    });

    final querySnapshot = await instance.collection('posts').getDocuments();
    final snapshot = querySnapshot.documents[0];
    final post = Post.fromSnapshot(snapshot:snapshot);

    expect(post.date, DateTime.parse(snapshot.data['date'].toDate().toString()));
    expect(post.imageUrl, snapshot.data['imageUrl']);
    expect(post.quantity, snapshot.data['quantity']);
    expect(post.latitude, snapshot.data['latitude']);
    expect(post.longitude, snapshot.data['longitude']);

  });

    test('Post created from map', () async {

      final date = DateTime.now();
      const imageUrl = "image.jpeg";
      const quantity = 2;
      const latitude = 100.1;
      const longitude = 99.2;
    
      final post = Post.fromMap({
        'date': date,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'latitude': latitude,
        'longitude': longitude
      });

      expect(post.date, date);
      expect(post.imageUrl, imageUrl);
      expect(post.quantity, quantity);
      expect(post.latitude, latitude);
      expect(post.longitude, longitude);
  });
}
