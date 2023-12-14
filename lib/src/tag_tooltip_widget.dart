import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
import 'package:image_tag/src/tag_tooltip_options.dart';
import 'package:image_tag/src/tooltip_mode.dart';

class TagTooltipWidget extends StatefulWidget {
  final TagItem? selected;
  final TagTooltipOptions? options;
  final Size size;
  const TagTooltipWidget({
    super.key,
    required this.selected,
    required this.options,
    required this.size,
  });

  @override
  State<TagTooltipWidget> createState() => _TagTooltipWidgetState();
}

class _TagTooltipWidgetState extends State<TagTooltipWidget> {
  TooltipMode mode = TooltipMode.empty;
  late TagTooltipOptions options;
  double? left;
  double? top;
  @override
  void initState() {
    super.initState();
    _setOptions();
  }

  @override
  void didUpdateWidget(covariant TagTooltipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setOptions();
    _setPosition();
  }

  void _setOptions() => options = TagTooltipOptions(
        width: widget.options?.width ?? widget.size.width * 0.3,
        height: widget.options?.height ?? widget.size.width * 0.15,
        margin: widget.options?.margin ?? 4,
        arrowSize: widget.options?.arrowSize ?? 10,
        decoration: widget.options?.decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
      );

  void _setPosition() {
    if (widget.selected != null) {
      final double space = options.margin! + options.arrowSize!;
      final double posX = widget.size.width * widget.selected!.x;
      final double posY = widget.size.height * widget.selected!.y;
      final double width = options.width!;
      final double height = options.height!;
      final double tagWidth =
          widget.selected!.child!.getWidth(MediaQuery.of(context).size.width);
      final double tagHeight =
          widget.selected!.child!.getHeight(MediaQuery.of(context).size.width);
      if (posX < width / 2 &&
          posY > height / 2 &&
          posY + height / 2 < widget.size.height) {
        // left
        left = posX + tagWidth / 2 + space;
        top = posY - (tagHeight / 2) - (height / 4);
        mode = TooltipMode.left;
      } else if (posX < width / 2 && posY < height / 2) {
        // leftTop,
        left = posX + tagWidth / 2 + space;
        top = posY - (tagHeight / 2) + (height / 4);
        // }
        mode = TooltipMode.leftTop;
      } else if (posX < width / 2 && posY + height / 2 > widget.size.height) {
        // leftBottom
        left = posX + tagWidth / 2 + space;
        top = posY - height;
        mode = TooltipMode.leftBottom;
      } else if (posX + width / 2 > widget.size.width &&
          posY > height / 2 &&
          posY + height / 2 < widget.size.height) {
        // right
        left = posX - width - tagWidth / 2 - space;
        top = posY - (tagHeight / 2) - (height / 4);
        mode = TooltipMode.right;
      } else if (posX + width / 2 > widget.size.width && posY < height / 2) {
        // rightTop
        left = posX - width - tagWidth / 2 - space;
        top = posY - (tagHeight / 2) + (height / 4);
        mode = TooltipMode.rightTop;
      } else if (posX + width / 2 > widget.size.width &&
          posY + height / 2 > widget.size.height) {
        // rightBottom
        left = posX - width - tagWidth / 2 - space;
        top = posY - height;
        mode = TooltipMode.rightBottom;
      } else if (posY < height + space + tagHeight / 2) {
        // top
        left = posX - width / 2;
        top = posY + (tagHeight / 2) + space;
        mode = TooltipMode.top;
      } else {
        left = posX - width / 2;
        top = posY - (tagHeight / 2) - height - space;
        mode = TooltipMode.nomal;
      }
    } else {
      left = null;
      top = null;
      mode = TooltipMode.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected == null || left == null || top == null) {
      return Container();
    } else {
      return Positioned(
        left: left,
        top: top,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: options.width!,
            maxHeight: options.height!,
            minHeight: 0,
            minWidth: 0,
          ),
          child: Stack(
            children: [
              Container(
                width: options.width!,
                height: options.height!,
                decoration: options.decoration,
                child: options.child,
              ),
              CustomPaint(
                painter: _ArrowPainter(
                  mode: mode,
                  options: options,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _ArrowPainter extends CustomPainter {
  final TooltipMode mode;
  final TagTooltipOptions options;

  const _ArrowPainter({
    required this.mode,
    required this.options,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.yellow;
    Path? path = _drawArrow();
    if (path != null) {
      canvas.drawPath(path, paint);
    }
  }

  Path? _drawArrow() {
    Path path = Path();
    final double arrow = options.arrowSize!;
    final double width = options.width!;
    final double height = options.height!;

    return switch (mode) {
      TooltipMode.left => path
        ..moveTo(0, height / 2 - arrow)
        ..lineTo(0, height / 2 + arrow)
        ..lineTo(-arrow, height / 2),
      TooltipMode.leftTop => path
        ..moveTo(width, 0)
        ..lineTo(-arrow, 0)
        ..lineTo(0, arrow),
      TooltipMode.leftBottom => null,
      TooltipMode.right => null,
      TooltipMode.rightTop => null,
      TooltipMode.rightBottom => null,
      TooltipMode.top => null,
      TooltipMode.nomal => null,
      TooltipMode.empty => null,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
