
class WastePost {

  // Mirrors the database.
  DateTime date;
  String imageURL;
  double latitude;
  double longitude;
  int quantity;

  WastePost({this.date, this.imageURL, this.latitude, this.longitude, this.quantity});

  // The idea for this came from the lecture videos.  
  WastePost.fromDatabaseMap({Map<String, dynamic> map}) {
    date = map['date'] is DateTime ? map['date'] : DateTime.parse(map['date']);
    imageURL = map['imageURL'];
    latitude = map['latitude'] is double ? map['latitude'] : map['latitude'].toDouble();
    longitude = map['longitude'] is double ? map['longitude'] : map['longitude'].toDouble();
    quantity = map['quantity'];
  }
}