import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/components/counter_state_container.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/database/wasteagram_database.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/style/custom_text_style.dart';
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
  static const String numberHintText = 'Number of Wasted Items';
  static const String uploadButtonLabel = 'Upload your post';
  static const String imageLabel = "Image from your gallery.";

  final formKey = GlobalKey<FormState>();
  WastePost post = WastePost();
  CounterState state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = CounterStateContainer.of(context);
  }

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
      body: _formBody(),
      floatingActionButton: _uploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _uploadButton() {
    final Widget iconBox = FractionallySizedBox(
      heightFactor: 0.3,
      widthFactor: 0.4,
      child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(Icons.cloud_upload, color: Colors.white)),
    );

    return SizedBox(
      height: getHeightFraction(context, 0.15),
      width: getMaxWidth(context),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: FloatingActionButton(
          onPressed: _savePost,
          shape: ContinuousRectangleBorder(),
          backgroundColor: Colors.blue,
          child: Semantics(
            label: uploadButtonLabel,
            button: true,
            enabled: true,
            hint: uploadButtonLabel,
            child: iconBox,
          ),
        ),
      ),
    );
  }

  Widget _formBody() {
    const double spaceBetweenFormFields = 10;

    final Widget numberFormField = Semantics(
      focused: true,
      focusable: true,
      hint: numberHintText,
      label: numberHintText,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: numberHintText,
          hintStyle: CustomTextStyle.numberForm,
        ),
        style: CustomTextStyle.numberForm,
        textAlign: TextAlign.center,
        autofocus: true,
        keyboardType: TextInputType.number,
        onSaved: (value) => post.quantity = int.parse(value),
        validator: (value) {
          int potentialNumber = int.tryParse(value);
          if (potentialNumber != null && potentialNumber > 0) {
            return null;
          } else {
            return quantityError;
          }
        },
      ),
    );

    // The sized boxes help separate the input fields.  It looks better when you go to type input in as well.
    // This is basically the same structure as shown in the lecture videos on forms.
    // Discussion on parsing numbers is discussed here
    // https://stackoverflow.com/questions/13167496/how-do-i-parse-a-string-into-a-number-with-dart
    // https://api.dart.dev/stable/2.9.0/dart-core/int/tryParse.html
    final columnChildren = [
      SizedBox(
        height: spaceBetweenFormFields,
      ),
      SizedBox(
        height: getHeightFraction(context, 0.3),
        width: getMaxWidth(context),
        child: Semantics(
          label: imageLabel,
          child: Image.file(
            widget.image,
            fit: BoxFit.fill,
          ),
        ),
      ),
      SizedBox(
        height: spaceBetweenFormFields,
      ),
      numberFormField
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

  void _savePost() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      post.date = DateTime.now();
      post.imageURL = await WasteagramDatabase.storeImage(widget.image);

      // https://stackoverflow.com/questions/58939437/return-type-of-void-async-function-in-dart
      await _getCurrentLocation();

      WasteagramDatabase.saveWasteagram(post);
      state.addToCounter(post.quantity);
      Navigator.of(context).pop();
    }
  }

  // The lecture video on location services was the base for this function.
  // The code to manually check for the Location Service status and Permission
  // status is from the location package documenation.
  // https://pub.dev/packages/location
  // (0, 0) coordinates will be my indication that location service
  // was not available/granted when trying to save the wasteagram.
  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permssionGranted;

    var locationService = Location();

    _serviceEnabled = await locationService.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();

      if (!_serviceEnabled) {
        post.latitude = 0;
        post.longitude = 0;
        return;
      }
    }

    _permssionGranted = await locationService.hasPermission();

    if (_permssionGranted == PermissionStatus.denied) {
      _permssionGranted = await locationService.requestPermission();

      if (_permssionGranted != PermissionStatus.granted) {
        post.latitude = 0;
        post.longitude = 0;
        return;
      }
    }

    var locationData = await locationService.getLocation();

    post.latitude = locationData.latitude;
    post.longitude = locationData.longitude;
  }
}
