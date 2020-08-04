import 'package:flutter/material.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/util/format_date.dart';

// Same format as my previous JournalEntryTile
class WastePostTile extends StatelessWidget {

  final WastePost post;
  final void Function() onTap;

  WastePostTile({Key key, this.post, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fullWeekdayMonthDayYear(post.date), style: Theme.of(context).textTheme.headline6,),
      trailing: Text(post.quantity.toString(), style: Theme.of(context).textTheme.headline5,),
      onTap: onTap,
    );
  }
}