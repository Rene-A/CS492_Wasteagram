
import 'package:flutter/material.dart';

// This is my attempt to implement an inherited widget as show in Flutter In Action chapter 8
// https://livebook.manning.com/book/flutter-in-action/chapter-8/84
class CounterStateContainer extends StatefulWidget {
  final Widget child;

  CounterStateContainer({Key key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterState();

  static _CounterState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType(aspect: _CounterStorageContainer) as _CounterStorageContainer).appData;
  }
}

class _CounterState extends State<CounterStateContainer> {

  int counter = 0;

  void updateCounter(int newCount) {
    setState(() => counter = newCount);
  }

  void addToCounter(int amountToAdd) {
    setState( () => counter += amountToAdd);
  }

  void subtractFromCounter(int amountToSubtract) {
    setState( () => counter -= amountToSubtract);
  }

  @override
  Widget build(BuildContext context) {
    return _CounterStorageContainer(
      appData: this,
      child: widget.child
    );
  }
}

class _CounterStorageContainer extends InheritedWidget {
  final _CounterState appData;

  _CounterStorageContainer({Key key, @required this.appData, @required child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CounterStorageContainer oldWidget) => oldWidget.appData != this.appData;
}

