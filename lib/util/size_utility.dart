import 'package:flutter/material.dart';

double getMaxHeight(BuildContext context) {

  return MediaQuery.of(context).size.height;
}

double getMaxWidth(BuildContext context) {

  return MediaQuery.of(context).size.width;
}

double getHalfWidth(BuildContext context) {

  return getMaxWidth(context) * 0.5;
}

double getHalfHeight(BuildContext context) {

  return getMaxHeight(context) * 0.5;
}

double getHeightFraction(BuildContext context, double fraction) {

  return getMaxHeight(context) * fraction;
}

double getWidthFraction(BuildContext context, double fraction) {

  return getMaxWidth(context) * fraction;
}

