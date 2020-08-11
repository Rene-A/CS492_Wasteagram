import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/util/format_date.dart';
import 'package:wasteagram/util/size_utility.dart';

class WastePostDetails extends StatelessWidget {

  static const imageLabel = "Image of the wasted item(s).";
  final WastePost post;

  WastePostDetails({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      _ColumnCell(
        child: Text(shortWeekdayFullMonthDayYear(post.date),
            style: Theme.of(context).textTheme.headline5),
      ),
      _ImageColumnCell(
        child: Semantics(
          container: true,
          image: true,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage, 
            image: post.imageURL,
            imageSemanticLabel: imageLabel,
          ),
        )
      ),
      _ColumnCell(
        child: Text(
          'Items: ${post.quantity}',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      _ColumnCell(
        child: Text('Location: (${post.latitude}, ${post.longitude})'),
      )
    ];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Constants.appName),
        ),
        body: Column(
          children: children,
        ));
  }
}

class _ColumnCell extends StatelessWidget {
  final Widget child;

  _ColumnCell({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: FittedBox(fit: BoxFit.fitWidth, child: child),
      ),
    );
  }
}

class _ImageColumnCell extends StatelessWidget {
  final Widget child;

  _ImageColumnCell({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
          height: getHeightFraction(context, 0.3),
          width: getMaxWidth(context),
          child: child),
    );
  }
}
