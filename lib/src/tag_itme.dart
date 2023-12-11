import 'package:flutter/material.dart';

class TagItem {
  final double x;
  final double y;
  final Widget? child;

  const TagItem({
    required this.x,
    required this.y,
    this.child,
  });

  TagItem copyWith({
    final double? x,
    final double? y,
    final Widget? child,
  }) {
    return TagItem(
      x: x ?? this.x,
      y: y ?? this.y,
      child: child ?? this.child,
    );
  }
}
