import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

import 'package:wasteagram/app.dart' as myApp;
import 'package:wasteagram/components/counter_state_container.dart';
import 'package:wasteagram/constants/reserved_constants.dart';

final SentryClient sentry = SentryClient(dsn: ReservedConstants.sentryDSN);

void main() {
  // From our lectures on Sentry and crash reporting
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned( () {
    runApp(CounterStateContainer(child: myApp.App()));
  }, onError: (error, stackTrace) {
    myApp.App.reportError(sentry, error, stackTrace);
  });
  
}