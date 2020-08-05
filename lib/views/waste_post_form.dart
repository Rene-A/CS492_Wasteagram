import 'dart:io';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/database/wasteagram_database.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/util/size_utility.dart';

// Similar structure to my project 4 form page.
class WastePostForm extends StatefulWidget {
  final File image;

  WastePostForm({Key key, this.image}) : super(key: key);

  @override
  _WastePostFormState createState() => _WastePostFormState();
}

class _WastePostFormState extends State<WastePostForm> {

  static const String quantityError = 'Please provide a positive number.';

  final formKey = GlobalKey<FormState>();
  WastePost post = WastePost();

  // Information on preventing the resize of widgets because of the keyboard
  // https://stackoverflow.com/questions/46551268/when-the-keyboard-appears-the-flutter-widgets-resize-how-to-prevent-this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.newPost),
      ),
      body: _getFormBody(),
      floatingActionButton: Container(
        height: getHeightFraction(context, 0.2),
        width: getMaxWidth(context),
        color: Colors.blue,
        child: FittedBox(
          child: IconButton(
            onPressed: _savePost, 
            icon: Icon(Icons.cloud_upload),
            
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }


  Widget _getFormBody() {
    // The sized boxes help separate the input fields.  It looks better when you go to type input in as well.
    // This is basically the same structure as shown in the lecture videos on forms.
    // Discussion on parsing numbers is discussed here
    // https://stackoverflow.com/questions/13167496/how-do-i-parse-a-string-into-a-number-with-dart
    // https://api.dart.dev/stable/2.9.0/dart-core/int/tryParse.html
    final columnChildren = [
      SizedBox(height: 10,),
      SizedBox(
        height: getHeightFraction(context, 0.3),
        width: getMaxWidth(context),
        child: Image.file(
          widget.image, 
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(height: 10,),
      TextFormField(
        decoration: InputDecoration(
          hintText: "Number of Wasted Items",
          hintStyle: TextStyle(fontSize: 24),
        ),
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
        autofocus: true,
        keyboardType: TextInputType.number,
        onSaved: (value) => post.quantity = int.parse(value),
        validator: (value) {
          int potentialNumber = int.tryParse(value);
          if (potentialNumber != null && potentialNumber > 0) {
            return null;
          }
          else {
            return quantityError;
          }
        },
      ),
    ];

    // https://medium.com/zipper-studios/the-keyboard-causes-the-bottom-overflowed-error-5da150a1c660
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: columnChildren, 
          ),
        ),
      ),
    );
  }

  void _savePost() async{
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      post.date = DateTime.now();
      post.imageURL = await WasteagramDatabase.storeImage(widget.image);

      // https://stackoverflow.com/questions/58939437/return-type-of-void-async-function-in-dart
      await _getCurrentLocation();

      WasteagramDatabase.saveWasteagram(post);
      Navigator.of(context).pop();
    }
  }

  // The lecture video on location services was the base for this function.
  Future<void> _getCurrentLocation() async { 
    var locationService = Location();
    var locationData = await locationService.getLocation();

    post.latitude = locationData.latitude;
    post.longitude = locationData.longitude;
  }
}


