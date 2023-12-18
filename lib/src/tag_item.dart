import 'package:image_tag/image_tag.dart';

class TagItem {
  final double x;
  final double y;
  final TagContainer? child;
  final Object? arguments;

  const TagItem({
    required this.x,
    required this.y,
    this.child,
    this.arguments,
  });

  TagItem copyWith({
    final double? x,
    final double? y,
    final TagContainer? child,
    final Object? arguments,
  }) {
    return TagItem(
      x: x ?? this.x,
      y: y ?? this.y,
      child: child ?? this.child,
      arguments: arguments ?? this.arguments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagItem &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          child == other.child &&
          arguments == other.arguments;

  @override
  String toString() =>
      "TagItem(x : $x, y : $y, child : $child. arguments : $arguments)";

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ child.hashCode ^ child.hashCode;
}
