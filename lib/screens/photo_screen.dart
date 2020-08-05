import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/components/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';


class PhotoScreen extends StatefulWidget {

  final File image;

  PhotoScreen({Key key, this.image}) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  int quantity;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();


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
              width: 300,
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
      )
    );
  }
}