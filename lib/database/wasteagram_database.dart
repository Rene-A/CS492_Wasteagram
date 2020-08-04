
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/wasteagram.dart';

class WasteagramDatabase {

  static const String collectionName = 'posts';

  // Get the stream for the posts collection.
  Stream<QuerySnapshot> get postsSnapshots {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  // Saves the wasteagram to our database
  void saveWasteagram(Wasteagram wasteagram) {
    // From lectures on Firebase/Firestore
    Firestore.instance.collection(collectionName).add({
      'date': wasteagram.date.toString(),
      'imageURL': wasteagram.imageURL,
      'latitude': wasteagram.latitude,
      'longitude': wasteagram.longitude,
      'quantity': wasteagram.quantity
    });
  }
}