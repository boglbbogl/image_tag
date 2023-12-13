import 'package:image_tag/image_tag.dart';

class TagItem {
  final double x;
  final double y;
  final TagContainer? child;

  const TagItem({
    required this.x,
    required this.y,
    this.child,
  });

  TagItem copyWith({
    final double? x,
    final double? y,
    final TagContainer? child,
  }) {
    return TagItem(
      x: x ?? this.x,
      y: y ?? this.y,
      child: child ?? this.child,
    );
  }

  @override
  String toString() => "TagItem(x : $x, y : $y, child : $child)";
}
