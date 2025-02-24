import 'package:flutter/material.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required super.builder});

  @override
  Duration get transitionDuration => Duration.zero; // No transition
  @override
  Duration get reverseTransitionDuration => Duration.zero; // No pop transition
}
