import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {

  final double delay;
  final Widget child;

  final double begin;
  final double end;

  FadeAnimation(this.delay, this.begin, this.end, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
        Duration(milliseconds: 500), Tween(begin: this.begin, end: this.end),
        curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
          offset: Offset(0, animation["translateY"]), 
          child: child
        ),
      ),
    );
  }
}
