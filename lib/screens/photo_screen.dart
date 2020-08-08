import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/models/post.dart';



class PhotoScreen extends StatefulWidget {

  final File imageFile;

  PhotoScreen({Key key, this.imageFile}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  Post post;
  Image image;


  LocationData locationData;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
    image = Image.file(this.widget.imageFile);
    post = Post();
  }

  void retrieveLocation() async {
    var locationService = Location();
    _serviceEnabled = await locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }

  Future<StorageReference> uploadPhotoToStorage() async {
    StorageReference storageReference = 
      FirebaseStorage.instance.ref().child(basename(this.widget.imageFile.path));
    StorageUploadTask uploadTask = storageReference.putFile(this.widget.imageFile);
    await uploadTask.onComplete;
    return storageReference;
  }

  void storePostInFirestore(){
    Firestore.instance.collection('posts').add({
      'quantity': post.quantity,
      'date': Timestamp.fromDate(post.date),
      'latitude': post.latitude,
      'longitude': post.longitute,
      'url': post.imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1/1,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5,
                        spreadRadius: 2
                      )
                    ],
                    image: DecorationImage(
                      image: image.image,
                      fit: BoxFit.cover,
                      )

                  ),
                ),
              ),
            ),
              FractionallySizedBox(
                widthFactor: .3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Enter Quantity"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) { 
                            if (value.isEmpty) {
                              return "Enter a quantity";
                            } else if (int.parse(value) < 1) {
                              return "Must be greater than 0";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            post.quantity = int.parse(value); 

                          } 
                        ),
                        SizedBox(height:40),
                        RaisedButton(
                          child: Text('Post'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              StorageReference storageReference = await uploadPhotoToStorage();
                              final url = await storageReference.getDownloadURL();

                              post.imageUrl = url;
                              post.date = DateTime.now();
                              post.latitude = locationData?.latitude;
                              post.longitute = locationData.longitude;

                              storePostInFirestore();
                              Navigator.of(context).pop();
                            } 
                          }
                        )
                      ]
                    )
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}