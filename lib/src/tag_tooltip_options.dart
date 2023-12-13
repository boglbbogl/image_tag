import 'package:flutter/material.dart';

class TagTooltipOptions {
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? child;

  const TagTooltipOptions({
    this.width,
    this.height,
    this.decoration,
    this.child,
  });
}

enum TooltipType {
  top,
  left,
  right,
  bottom;
}
