import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/accessibility/semantics.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/components/photo_box_decoration.dart';
import 'package:wasteagram/models/post.dart';
import 'package:wasteagram/styles.dart';



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
      'longitude': post.longitude,
      'imageUrl': post.imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      bottomNavigationBar: uploadButton(context),
      body: SingleChildScrollView(
        child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 500 ? 
                VerticalLayout(image: image, formKey: _formKey, post: post) : 
                  HorizontalLayout(image: image, formKey: _formKey, post: post);  
            }
          ),
      )
    );
  }

  Widget uploadButton(BuildContext context) {
    return semanticUploadButton(
      child: GestureDetector(
        child: Container(
          height: 70,
          color: Colors.blue,
          child: Icon(
            Icons.cloud_upload,
            size: 48)
        ),
        onTap: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            StorageReference storageReference = await uploadPhotoToStorage();
            final url = await storageReference.getDownloadURL();

            post.imageUrl = url;
            post.date = DateTime.now();
            post.latitude = locationData?.latitude;
            post.longitude = locationData.longitude;

            storePostInFirestore();

            Navigator.of(context).pop();
          }
        } 
      ),
    );
  }
}

class VerticalLayout extends StatelessWidget {
  const VerticalLayout({
    Key key,
    @required this.image,
    @required GlobalKey<FormState> formKey,
    @required this.post,
  }) : _formKey = formKey, super(key: key);

  final Image image;
  final GlobalKey<FormState> _formKey;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageFrame(image: image),
          QuantityForm(formKey: _formKey, post: post)
          ],
        ),
      );
  }
}

class HorizontalLayout extends StatelessWidget {
  
  const HorizontalLayout({
    Key key,
    @required this.image,
    @required GlobalKey<FormState> formKey,
    @required this.post,
  }) : _formKey = formKey, super(key: key);

  final Image image;
  final GlobalKey<FormState> _formKey;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ImageFrame(image: image)
        ),
        Expanded(
          flex: 1,
          child: QuantityForm(formKey: _formKey, post: post),
        )
      ],
    );
  }
}

class QuantityForm extends StatelessWidget {
  const QuantityForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.post,
  }) : _formKey = formKey, super(key: key);

  final GlobalKey<FormState> _formKey;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      child: Form(
        key: _formKey,
        child: semanticQuantityForm(
          child: TextFormField(
            textAlign: TextAlign.center,
            style: Styles.headerLarge,
            decoration: InputDecoration(
              hintStyle: Styles.textFaint, 
              hintText: "Enter Quantity"
            ),
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
        )
      ),
    );
  }
}

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    Key key,
    @required this.image,
  }) : super(key: key);

  final Image image;

  @override
  Widget build(BuildContext context) {
    return semanticWasteImage(
      child: AspectRatio(
        aspectRatio: 1/1,
        child: Container(
          margin: const EdgeInsets.all(40),
          decoration: photoBoxDecoration(image.image)
        ),
      ),
    );
  }
}