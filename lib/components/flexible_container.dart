import 'package:flutter/material.dart';

// Container housed within a flexible widget.  Allows you to change alignment and padding of the container.
class FlexibleContainer extends StatelessWidget {

  final Widget child;
  final EdgeInsets padding;
  final Alignment alignment;

  FlexibleContainer(
    {Key key, this.child, this.padding = const EdgeInsets.all(10), this.alignment}
  ) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Flexible(
      child: Container(
        alignment: alignment,
        padding: padding,
        child: child
      ),
    );
  }
}