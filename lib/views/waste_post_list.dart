import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wasteagram/components/counter_state_container.dart';
import 'package:wasteagram/components/waste_post_tile.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/database/wasteagram_database.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/views/waste_post_details.dart';
import 'package:wasteagram/views/waste_post_form.dart';

class WastePostList extends StatefulWidget {
  final FirebaseAnalytics analytics;

  WastePostList({Key key, this.analytics}) : super(key: key);

  @override
  _WastePostListState createState() => _WastePostListState();
}

class _WastePostListState extends State<WastePostList> {
  CounterState state;
  bool initialCountCompleted = false;

  @override
  void didChangeDependencies() {
    state = CounterStateContainer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: WasteagramDatabase.postsSnapshots,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage;
        } else if (!snapshot.hasData) {
          return _loadingPage;
        } else {
          return _listPage(snapshot);
        }
      },
    );
  }

  Widget _buildWastePostTile(BuildContext context, DocumentSnapshot document) {
    const String tileLabel = 'Post creation date and number of wasted items.';
    const String hint = 'Tap to get the full post details.';
    WastePost post = WastePost.fromDatabaseMap(map: document.data);

    return Semantics(
      button: true,
      label: tileLabel,
      hint: hint,
      child: WastePostTile(
        post: post,
        onTap: () => _pushWastePostDetails(context, post),
      ),
    );
  }

  void _pushWastePostDetails(BuildContext context, WastePost post) async {
    // I'll send a report to Firebase Analytics
    await _logPageView(post);

    // The settings parameter is necessary to deal with an odd issue.
    // https://github.com/FirebaseExtended/flutterfire/issues/2488
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WastePostDetails(post: post),
      settings: RouteSettings(name: WastePostDetails.pageName),
    ));
  }

  Widget _listPage(AsyncSnapshot<dynamic> snapshot) {
    int numberOfPosts = snapshot.data.documents.length;

    if (initialCountCompleted == false) {
      int counter = 0;

      snapshot.data.documents.forEach((doc) => counter += doc['quantity']);
      state.initializeCounter(counter);
      initialCountCompleted = true;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.appName + ' - ' + state.counter.toString()),
      ),
      body: numberOfPosts == 0
          ? _noEntryBody
          : ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _buildWastePostTile(
                    context, snapshot.data.documents[index]);
              },
            ),
      floatingActionButton: _MyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget get _noEntryBody {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get _loadingPage {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.loading),
      ),
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }

  Widget get _errorPage {
    const String error =
        "An error occurred when trying to access the database.";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.appName),
      ),
      body: Center(
        child: Text(error),
      ),
    );
  }

  // Analytics functions
  Future<void> _logPageView(WastePost post) async {
    // One strategy to get unique identifiers is to mix different keys.
    // The date object could probably be considered sufficiently unique since
    // it is unlikely that a given user would be able to create two posts at
    // the same time.
    String identifier = post.date.toString() + post.quantity.toString();

    await widget.analytics.logSelectContent(
      contentType: "Detailed Post View",
      itemId: identifier,
    );
  }
}

class _MyFloatingActionButton extends StatelessWidget {
  static const String label = 'Photo icon button.';
  static const String onTapHint = 'Takes you to the post creation form.';

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _pushWastePostForm(context),
      child: Semantics(
        container: true,
        button: true,
        label: label,
        onTapHint: onTapHint,
        child: const Icon(Icons.photo_camera),
      ),
    );
  }

  void _pushWastePostForm(BuildContext context) async {
    File image = await _pickImage();

    if (image != null) {
      // The settings parameter is necessary to deal with an odd issue.
      // https://github.com/FirebaseExtended/flutterfire/issues/2488
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WastePostForm(image: image),
        settings: RouteSettings(name: WastePostForm.pageName),
      ));
    }
  }

  // From the documentation
  // https://pub.dev/packages/image_picker
  Future<File> _pickImage() async {
    PermissionStatus _permissionStatus = await Permission.storage.request();

    if (_permissionStatus.isDenied) {
      return null;
    }

    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    // If the user doesn't pick an image, then pickedFile will be null.  It looks like the exception
    // is caught and handled by the operating system, but I should handle it explicitly.
    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }
}
