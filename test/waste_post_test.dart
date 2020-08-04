import 'package:test/test.dart';
import 'package:wasteagram/models/waste_post.dart';

void main() {

  group('Constructors properly store information.', () {

    final DateTime date = DateTime.parse('2020-08-04');
    const String url = 'TEST_URL';
    const double latitude = 5.0;
    const double longitude = -1.0;
    const int quantity = 5;

    test('The default constructor stores arguments correctly.', () {

      final WastePost post = WastePost(date: date, imageURL: url, latitude: latitude, longitude: longitude, quantity: quantity);

      expect(post.date, date);
      expect(post.imageURL, url);
      expect(post.latitude, latitude);
      expect(post.longitude, longitude);
      expect(post.quantity, quantity);
    });

    // These tests are from the lecture videos
    test('The model correctly stores arguments provided using the fromMap constructor.', () {

      final WastePost post = WastePost.fromMap(map: {
        'date': date,
        'imageURL': url,
        'latitude': latitude,
        'longitude': longitude,
        'quantity': quantity
      });

      expect(post.date, date);
      expect(post.imageURL, url);
      expect(post.latitude, latitude);
      expect(post.longitude, longitude);
      expect(post.quantity, quantity);
    });
  });
}