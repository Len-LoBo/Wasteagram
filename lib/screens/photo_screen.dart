import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';



class PhotoScreen extends StatefulWidget {

  final File image;

  PhotoScreen({Key key, this.image}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  int quantity;
  final picker = ImagePicker();

  LocationData locationData;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
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
            SizedBox(
              height: 300, 
              width: 400,
              child: Image.file(this.widget.image, fit: BoxFit.cover)),
              SizedBox(height:40),
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
                            quantity = int.parse(value); 

                          } 
                        ),
                        SizedBox(height:40),
                        RaisedButton(
                          child: Text('Post'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              StorageReference storageReference = 
                                FirebaseStorage.instance.ref().child(basename(this.widget.image.path));
                              StorageUploadTask uploadTask = storageReference.putFile(this.widget.image);
                              await uploadTask.onComplete;
                              final url = await storageReference.getDownloadURL();

                              Firestore.instance.collection('posts').add({
                                'quantity': quantity,
                                'date': Timestamp.now(),
                                'latitude': locationData?.latitude,
                                'longitude': locationData?.longitude,
                                'url': url
                              });
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