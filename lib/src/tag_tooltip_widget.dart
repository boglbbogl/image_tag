import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
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
  double arrow = 7;
  BorderRadius borderRadius = BorderRadius.circular(8);
  double radius = 8;

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

  void _setOptions() {
    options = TagTooltipOptions(
      width: widget.options?.width ?? widget.size.width * 0.3,
      height: widget.options?.height ?? widget.size.width * 0.15,
      margin: widget.options?.margin ?? 4,
      arrowSize: widget.options?.arrowSize ?? 7,
      radius: widget.options?.radius ?? 8,
      color: widget.options?.color ?? Colors.white70,
    );
    if (options.height! < options.width!) {
      arrow = options.arrowSize! > options.height! / 8
          ? options.height! / 8
          : options.arrowSize!;
      radius = options.radius! > options.height! / 4
          ? options.height! / 4
          : options.radius!;
    } else {
      arrow = options.arrowSize! > options.width! / 8
          ? options.width! / 8
          : options.arrowSize!;
      radius = options.arrowSize! > options.width! / 4
          ? options.width! / 4
          : options.arrowSize!;
    }
  }

  void _setPosition() {
    if (widget.selected != null) {
      final double width = options.width!;
      final double height = options.height!;
      final double posX = widget.size.width * widget.selected!.x;
      final double posY = widget.size.height * widget.selected!.y;
      final double tagWidth =
          widget.selected!.child!.getWidth(MediaQuery.of(context).size.width);
      final double tagHeight =
          widget.selected!.child!.getHeight(MediaQuery.of(context).size.width);
      double margin = options.margin!;
      if (tagWidth < tagHeight) {
        margin = margin > tagWidth / 2 ? tagWidth / 2 : margin;
      } else {
        margin = margin > tagHeight / 2 ? tagHeight / 2 : margin;
      }
      final double space = margin + arrow;

      if (posX < width / 2 &&
          posY > height / 2 &&
          posY + height / 2 < widget.size.height) {
        left = posX + tagWidth / 2 + space;
        top = posY - height / 2;
        mode = TooltipMode.left;
        _borderRadius();
      } else if (posX < width / 2 && posY < height / 2) {
        left = posX + tagWidth / 2 + space;
        top = posY - (tagHeight / 2) + (height / 4);
        mode = TooltipMode.leftTop;
        _borderRadius(topLeft: 0);
      } else if (posX < width / 2 && posY + height / 2 > widget.size.height) {
        left = posX + tagWidth / 2 + space;
        top = posY - height;
        mode = TooltipMode.leftBottom;
        _borderRadius(bottomLeft: 0);
      } else if (posX + width / 2 > widget.size.width &&
          posY > height / 2 &&
          posY + height / 2 < widget.size.height) {
        left = posX - width - tagWidth / 2 - space;
        top = posY - (height / 2);
        mode = TooltipMode.right;
        _borderRadius();
      } else if (posX + width / 2 > widget.size.width && posY < height / 2) {
        left = posX - width - tagWidth / 2 - space;
        top = posY - (tagHeight / 2) + (height / 4);
        mode = TooltipMode.rightTop;
        _borderRadius(topRight: 0);
      } else if (posX + width / 2 > widget.size.width &&
          posY + height / 2 > widget.size.height) {
        left = posX - width - tagWidth / 2 - space;
        top = posY - height;
        mode = TooltipMode.rightBottom;
        _borderRadius(bottomRight: 0);
      } else if (posY < height + space + tagHeight / 2) {
        left = posX - width / 2;
        top = posY + (tagHeight / 2) + space;
        mode = TooltipMode.top;
        _borderRadius();
      } else {
        left = posX - width / 2;
        top = posY - (tagHeight / 2) - height - space;
        mode = TooltipMode.nomal;
        _borderRadius();
      }
    } else {
      left = null;
      top = null;
      mode = TooltipMode.empty;
      _borderRadius();
    }
  }

  void _borderRadius({
    double? topLeft,
    double? bottomLeft,
    double? topRight,
    double? bottomRight,
  }) {
    borderRadius = BorderRadius.only(
      topLeft:
          topLeft != null ? Radius.circular(topLeft) : Radius.circular(radius),
      bottomLeft: bottomLeft != null
          ? Radius.circular(bottomLeft)
          : Radius.circular(radius),
      topRight: topRight != null
          ? Radius.circular(topRight)
          : Radius.circular(radius),
      bottomRight: bottomRight != null
          ? Radius.circular(bottomRight)
          : Radius.circular(radius),
    );
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
                decoration: BoxDecoration(
                  color: options.color!,
                  borderRadius: borderRadius,
                ),
                child: options.child,
              ),
              CustomPaint(
                painter: _ArrowPainter(
                  mode: mode,
                  options: options,
                  arrow: arrow,
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
  final double arrow;

  const _ArrowPainter({
    required this.mode,
    required this.options,
    required this.arrow,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = options.color ?? Colors.white70;
    Path? path = _drawArrow();
    if (path != null) {
      canvas.drawPath(path, paint);
    }
  }

  Path? _drawArrow() {
    Path path = Path();
    final double width = options.width!;
    final double height = options.height!;

    return switch (mode) {
      TooltipMode.left => path
        ..moveTo(0, height / 2 - arrow)
        ..lineTo(0, height / 2 + arrow)
        ..lineTo(-arrow, height / 2),
      TooltipMode.leftTop => path
        ..moveTo(0, 0)
        ..lineTo(-arrow, 0)
        ..lineTo(0, arrow),
      TooltipMode.leftBottom => path
        ..moveTo(0, height)
        ..lineTo(-arrow, height)
        ..lineTo(0, height - arrow),
      TooltipMode.right => path
        ..moveTo(width, height / 2 - arrow)
        ..lineTo(width, height / 2 + arrow)
        ..lineTo(width + arrow, height / 2),
      TooltipMode.rightTop => path
        ..moveTo(width, 0)
        ..lineTo(width + arrow, 0)
        ..lineTo(width, arrow),
      TooltipMode.rightBottom => path
        ..moveTo(width, height)
        ..lineTo(width + arrow, height)
        ..lineTo(width, height - arrow),
      TooltipMode.top => path
        ..moveTo(width / 2 - arrow, 0)
        ..lineTo(width / 2 + arrow, 0)
        ..lineTo(width / 2, -arrow),
      TooltipMode.nomal => path
        ..moveTo(width / 2 - arrow, height)
        ..lineTo(width / 2 + arrow, height)
        ..lineTo(width / 2, height + arrow),
      TooltipMode.empty => null,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
