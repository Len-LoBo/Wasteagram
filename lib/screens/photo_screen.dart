import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class PhotoScreen extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Wasteagram')
      ),
      body: PhotoScreenBody()
    );
  }
}

class PhotoScreenBody extends StatefulWidget {
  @override
  _PhotoScreenBodyState createState() => _PhotoScreenBodyState();
}

class _PhotoScreenBodyState extends State<PhotoScreenBody> {

  File image;
  int quantity;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();


  void getPhoto() async {
    final pickedFile = await picker.getImage(source:ImageSource.camera);
    setState((){
      image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Center(
        child: RaisedButton(
          child: Text('Select Photo'),
          onPressed: () {
            getPhoto();

          }
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300, 
                width: 300,
                child: Image.file(image, fit: BoxFit.cover)),
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Firestore.instance.collection('posts').add({
                                  'quantity': quantity,
                                  'date': Timestamp.now(),
                                });
                              }
                              Navigator.of(context).pop();
                            }
                          )
                        ]
                      )
                    )
                )
              ],
            ),
        ),
      );
    }
  }
}