import 'package:flutter/material.dart';

class MarvelListAnimation extends StatelessWidget {
  MarvelListAnimation({@required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children.length,
      padding: EdgeInsets.zero,
      itemBuilder: (_, int index) {
        return ListItem(
          child: children[index],
          position: index,
          duration: Duration(milliseconds: 300 + index),
          // set duration
        );
      },
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({this.position, this.child, this.duration});

  final int position;
  final Widget child;
  final Duration duration;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_controller);

    Future<void>.delayed(widget.duration, () => _controller.forward());
  }

  @override
  void didUpdateWidget(ListItem oldWidget) {
    if(oldWidget.child != widget.child) {
      Future<void>.delayed(widget.duration, () => _controller.forward());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
