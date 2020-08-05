import 'package:flutter/material.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/util/format_date.dart';

class WastePostDetails extends StatelessWidget {
  final WastePost post;

  WastePostDetails({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final children = [
      _ColumnCell(
        child: Text(fullWeekdayMonthDayYear(post.date), style: Theme.of(context).textTheme.headline4),
      ),
      _ColumnCell(
        child: Image.network(post.imageURL),
      ),
      _ColumnCell(
        child: Text('Items: ${post.quantity}'),
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
      )
    );
  }
}

class _ColumnCell extends StatelessWidget {

  final Widget child;

  _ColumnCell({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: child,
    );
  }
}