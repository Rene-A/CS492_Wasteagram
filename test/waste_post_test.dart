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
    test('The model correctly stores arguments provided using the fromDatabaseMap constructor.', () {

      final WastePost post = WastePost.fromDatabaseMap(map: {
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

    test('The fromDatabaseMap constructor converts ints to doubles for latitude and longitude.', () {

      final WastePost post = WastePost.fromDatabaseMap(map: {
        'date': date,
        'imageURL': url,
        'latitude': 3,
        'longitude': 65,
        'quantity': quantity
      });
      expect(post.latitude, 3.0);
      expect(post.longitude, 65.0);

      expect(post.latitude, TypeMatcher<double>());
      expect(post.longitude, TypeMatcher<double>());
    });

    test('The fromDatabaseMap constructor can parse a String to create a DateTime object.', () {

      final WastePost post = WastePost.fromDatabaseMap(map: {
        'date': '2020-08-04',
        'imageURL': url,
        'latitude': latitude,
        'longitude': longitude,
        'quantity': quantity
      });

      expect(post.date, TypeMatcher<DateTime>());
    });
  });
}