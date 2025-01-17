
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'package:wasteagram/models/waste_post.dart';

class WasteagramDatabase {

  static const String collectionName = 'posts';

  // Get the stream for the posts collection.
  // This post pointed me to the orderBy method:
  // https://stackoverflow.com/questions/58044290/flutter-sort-data-firestore-with-streambuilder
  // And this documentation helped show more advanced queries:
  // https://firebase.flutter.dev/docs/firestore/usage/#querying
  static Stream<QuerySnapshot> get postsSnapshots {
    return Firestore.instance.collection(collectionName).orderBy('date', descending: true).snapshots();
  }

  // Saves the wasteagram to our database
  static void saveWasteagram(WastePost wasteagram) {
    // From lectures on Firebase/Firestore
    Firestore.instance.collection(collectionName).add({
      'date': wasteagram.date.toString(),
      'imageURL': wasteagram.imageURL,
      'latitude': wasteagram.latitude,
      'longitude': wasteagram.longitude,
      'quantity': wasteagram.quantity
    });
  }

  // Adapted from the lecture on Firestore
  // Accepts the image file to store in Firebase storage.  
  // Returns the string representing the url where the image may be accessed.
  static Future<String> storeImage(File image) async {
    // The timestamp was a suggestion to make sure the filename is unique.
    StorageReference storageReference = 
      FirebaseStorage.instance.ref().child(Path.basename(image.path) + '-' + DateTime.now().toString());
    
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();

    return url;
  }
}