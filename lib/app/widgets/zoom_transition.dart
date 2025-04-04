import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoomTransitions extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _ZoomEnterTransition(
          animation: animation,
          child: child,
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _ZoomExitTransition(
          animation: animation,
          reverse: true,
          child: child,
        );
      },
      child: DualTransitionBuilder(
        animation: ReverseAnimation(secondaryAnimation),
        forwardBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _ZoomEnterTransition(
            animation: animation,
            reverse: true,
            child: child,
          );
        },
        reverseBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _ZoomExitTransition(
            animation: animation,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  static final List<TweenSequenceItem<double>>
      fastOutExtraSlowInTweenSequenceItems = <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: const Cubic(0.05, 0.0, 0.133333, 0.06))),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0))),
      weight: 1.0 - 0.166666,
    ),
  ];
  static final TweenSequence<double> _scaleCurveSequence =
      TweenSequence<double>(fastOutExtraSlowInTweenSequenceItems);
}

class _ZoomEnterTransition extends StatelessWidget {
  const _ZoomEnterTransition({
    required this.animation,
    this.reverse = false,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;
  final bool reverse;

  static final Animatable<double> _fadeInTransition = Tween<double>(
    begin: 0.0,
    end: 1.00,
  ).chain(CurveTween(curve: const Interval(0.125, 0.250)));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.10,
    end: 1.00,
  ).chain(ZoomTransitions._scaleCurveSequence);

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.85,
    end: 1.00,
  ).chain(ZoomTransitions._scaleCurveSequence);

  static final Animatable<double?> _scrimOpacityTween = Tween<double?>(
    begin: 0.0,
    end: 0.60,
  ).chain(CurveTween(curve: const Interval(0.2075, 0.4175)));

  @override
  Widget build(BuildContext context) {
    double opacity = 0;

    if (!reverse && animation.status != AnimationStatus.completed) {
      opacity = _scrimOpacityTween.evaluate(animation)!;
    }

    final Animation<double> fadeTransition = reverse
        ? kAlwaysCompleteAnimation
        : _fadeInTransition.animate(animation);

    final Animation<double> scaleTransition =
        (reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(animation);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          color: Colors.black.withOpacity(opacity),
          child: child,
        );
      },
      child: FadeTransition(
        opacity: fadeTransition,
        child: ScaleTransition(
          scale: scaleTransition,
          child: child,
        ),
      ),
    );
  }
}

class _ZoomExitTransition extends StatelessWidget {
  const _ZoomExitTransition({
    required this.animation,
    this.reverse = false,
    this.child,
  });

  final Animation<double> animation;
  final bool reverse;
  final Widget? child;

  static final Animatable<double> _fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).chain(CurveTween(curve: const Interval(0.0825, 0.2075)));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 1.00,
    end: 1.05,
  ).chain(ZoomTransitions._scaleCurveSequence);

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.00,
    end: 0.90,
  ).chain(ZoomTransitions._scaleCurveSequence);

  @override
  Widget build(BuildContext context) {
    final Animation<double> fadeTransition = reverse
        ? _fadeOutTransition.animate(animation)
        : kAlwaysCompleteAnimation;
    final Animation<double> scaleTransition =
        (reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(animation);

    return FadeTransition(
      opacity: fadeTransition,
      child: ScaleTransition(
        scale: scaleTransition,
        child: child,
      ),
    );
  }
}
