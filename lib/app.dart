import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/views/waste_post_list.dart';

class App extends StatelessWidget {
  App({Key key}) : super(key: key) {
    _logStartUp();
  }

  // Firebase analytics code taken from lectures which looks to have taken the
  // logic from the documentation:
  // https://pub.dev/packages/firebase_analytics/example
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // Sentry function logic is directly from the lecture on Sentry and crash reporting.
  static Future<void> reportError(
      SentryClient sentry, dynamic error, dynamic stackTrace) async {
    // Perform the default action in debug mode.
    if (Foundation.kDebugMode) {
      print(stackTrace);
      return;
    }

    final SentryResponse response =
        await sentry.captureException(exception: error, stackTrace: stackTrace);

    if (response.isSuccessful) {
      print('Sentry ID: ${response.eventId}');
    } else {
      print('Failed to report to Sentry: ${response.error}');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showSemanticsDebugger: true,
      title: Constants.appName,
      theme: ThemeData(
        brightness: Brightness.dark,

        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: WastePostList(
        analytics: analytics,
      ),
    );
  }

  Future<void> _logStartUp() async {
    await analytics.logAppOpen();
  }
}
