import 'package:flutter/material.dart';

class TagTooltipOptions {
  final double? width;
  final double? height;
  final double? margin;
  final double? radius;
  final Color? color;
  final Widget? child;
  final double? arrowSize;

  const TagTooltipOptions({
    this.width,
    this.height,
    this.margin,
    this.radius,
    this.color,
    this.child,
    this.arrowSize,
  });
}

enum TooltipType {
  top,
  left,
  right,
  bottom;
}
