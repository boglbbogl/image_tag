import 'package:flutter/material.dart';

class TagTooltipOptions {
  final bool tooltip;
  final double? width;
  final double? height;
  final double? margin;
  final double? radius;
  final Color? color;
  final Widget? child;
  final double? arrowSize;

  const TagTooltipOptions({
    this.tooltip = true,
    this.width,
    this.height,
    this.margin,
    this.radius,
    this.color,
    this.child,
    this.arrowSize,
  });
}
