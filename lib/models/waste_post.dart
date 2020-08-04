
class WastePost {

  // Mirrors the database.
  DateTime date;
  String imageURL;
  double latitude;
  double longitude;
  int quantity;

  WastePost({this.date, this.imageURL, this.latitude, this.longitude, this.quantity});

  // The idea for this came from the lecture videos.  
  WastePost.fromMap({Map<String, dynamic> map}) {
    date = map['date'];
    imageURL = map['imageURL'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    quantity = map['quantity'];
  }
}