import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
import 'package:image_tag/src/tag_tooltip_options.dart';

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
        decoration: widget.options?.decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
      );

  void _setPosition() {
    if (widget.selected != null) {
      double posX = widget.size.width * widget.selected!.x;
      double posY = widget.size.height * widget.selected!.y;
      double width = options.width!;
      double height = options.height!;
      double tagWidth =
          widget.selected!.child!.getWidth(MediaQuery.of(context).size.width);
      double tagHeight =
          widget.selected!.child!.getHeight(MediaQuery.of(context).size.width);
      left = posX - width / 2;
      top = posY - (tagHeight / 2) - height;
      //
    } else {
      left = null;
      top = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selected == null) {
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
          child: Container(
            width: options.width!,
            height: options.height!,
            color: Colors.red,
            child: options.child,
          ),
        ),
      );
    }
  }
}
