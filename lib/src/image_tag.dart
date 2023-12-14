import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
import 'package:image_tag/src/tag_tooltip_options.dart';
import 'package:image_tag/src/tag_tooltip_widget.dart';

class ImageTag extends StatefulWidget {
  final bool debug;
  final Image image;
  final List<TagItem> tagItems;
  final TagTooltipOptions? options;
  final Function(TagItem)? onAdd;
  final Function(List<TagItem>, TagItem)? onTagUpdate;
  final Function(TagItem)? onTagTap;
  final Function(TagItem)? onTagLongTap;
  final Function(double, double)? customAdd;
  final Function(double, double, int)? customTagUpdate;
  final Function(double, double, int)? customTagTap;
  final Function(double, double, int)? customTagLongTap;
  const ImageTag({
    super.key,
    this.debug = false,
    required this.image,
    required this.tagItems,
    this.options,
    this.onAdd,
    this.onTagUpdate,
    this.onTagTap,
    this.onTagLongTap,
    this.customAdd,
    this.customTagUpdate,
    this.customTagTap,
    this.customTagLongTap,
  });

  @override
  State<ImageTag> createState() => _ImageTagState();
}

class _ImageTagState extends State<ImageTag> {
  final GlobalKey widgetKey = GlobalKey();
  late TagContainer tagWidget;
  late Size imageSize;
  TagTooltipOptions? options;
  Size? widgetSize;

  ValueNotifier<List<TagItem>> tagItems = ValueNotifier([]);

  TagItem? selected;

  @override
  void initState() {
    super.initState();
    _imageListener();
    _setTagWidget();
    _setTagItem();
    _setTooltipOptions();
  }

  @override
  void didUpdateWidget(covariant ImageTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _imageListener();
    _setTagWidget();
    _setTooltipOptions();
    _setTagItem();
  }

  void _setTooltipOptions() => options = widget.options;

  void _setTagItem() => tagItems.value = widget.tagItems;

  void _setTagWidget() => tagWidget = const TagContainer();

  void _imageListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.image.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo image, _) {
        imageSize =
            Size(image.image.width.toDouble(), image.image.height.toDouble());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widgetKey.currentContext != null) {
            RenderBox renderbox =
                widgetKey.currentContext!.findRenderObject() as RenderBox;
            widgetSize = Size(renderbox.size.width, renderbox.size.height);
          }
        });
      }));
    });
  }

  void _onAdd(TapDownDetails details) {
    if (widgetSize != null) {
      double x = details.localPosition.dx / widgetSize!.width;
      double y = details.localPosition.dy / widgetSize!.height;
      final TagItem item = TagItem(x: x, y: y, child: tagWidget);
      if (widget.onAdd != null) {
        widget.onAdd!(item);
        _log("[onAdd] $item");
      }
      if (widget.customAdd != null) {
        widget.customAdd!(x, y);
        _log("[onAdd] x : $x, y : $y");
      }
    }
  }

  void _onTagTap(int index) {
    TagItem item = tagItems.value[index];

    if (widget.onTagTap != null) {
      widget.onTagTap!(item);
      _log("[onTagTap] $item");
    }
    if (widget.customTagTap != null) {
      widget.customTagTap!(item.x, item.y, index);
      _log("[onTagTap] x : ${item.x}, y : ${item.y}, index : $index");
    }
    setState(() {
      selected = item.copyWith(child: item.child ?? tagWidget);
    });
  }

  void _onTagLongTap(int index) {
    TagItem item = tagItems.value[index];
    if (widget.onTagLongTap != null) {
      widget.onTagLongTap!(item);
      _log("[onTagLongTap] $item");
    }
    if (widget.customTagLongTap != null) {
      widget.customTagLongTap!(item.x, item.y, index);
      _log("[onTagLongTap] x : ${item.x}, y : ${item.y}, index : $index");
    }
  }

  void _onTagUpdate(DragUpdateDetails details, int index) {
    if (widgetSize != null) {
      List<TagItem> items = tagItems.value;
      TagItem item = items[index];
      double dx = (item.x * widgetSize!.width) + details.delta.dx;
      double dy = (item.y * widgetSize!.height) + details.delta.dy;
      double x = switch (dx / widgetSize!.width) {
        < 0 => 0,
        > 1 => 1,
        _ => dx / widgetSize!.width,
      };
      double y = switch (dy / widgetSize!.height) {
        < 0 => 0,
        > 1 => 1,
        _ => dy / widgetSize!.height,
      };
      item = item.copyWith(x: x, y: y, child: tagWidget);
      items = List.from(items)
        ..removeAt(index)
        ..insert(index, item);
      if (widget.onTagUpdate != null) {
        widget.onTagUpdate!(items, item);
        _log(
            "[onTagUpdate] items : ${items.length}, ${item.copyWith(x: x, y: y, child: tagWidget)}");
      }
      if (widget.customTagUpdate != null) {
        widget.customTagUpdate!(x, y, index);
        _log("[onTagUpdate] x : $x, y : $y, index : $index");
      }
    }
  }

  void _log(String log) {
    if (kDebugMode) {
      if (widget.debug) {
        print(log);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize?.width,
      height: widgetSize?.height,
      child: ValueListenableBuilder<List<TagItem>>(
          valueListenable: tagItems,
          builder: (
            BuildContext context,
            List<TagItem> items,
            Widget? child,
          ) {
            return Stack(
              children: [
                GestureDetector(
                  key: widgetKey,
                  onTapDown: widget.onAdd != null || widget.customAdd != null
                      ? (TapDownDetails details) => _onAdd(details)
                      : null,
                  child: SizedBox(
                    width: widgetSize?.width,
                    height: widgetSize?.height,
                    child: widget.image,
                  ),
                ),
                if (widgetSize != null) ...[
                  ...List.generate(
                      items.length,
                      (index) => Positioned(
                          left: (widgetSize!.width * items[index].x) -
                              ((items[index].child ?? tagWidget).getWidth(
                                      MediaQuery.of(context).size.width) /
                                  2),
                          top: (widgetSize!.height * items[index].y) -
                              ((items[index].child ?? tagWidget).getHeight(
                                      MediaQuery.of(context).size.width) /
                                  2),
                          child: GestureDetector(
                            onLongPress: widget.onTagLongTap != null ||
                                    widget.customTagLongTap != null
                                ? () => _onTagLongTap(index)
                                : null,
                            onTap: widget.onTagTap != null ||
                                    widget.customTagTap != null
                                ? () => _onTagTap(index)
                                : null,
                            onPanUpdate: widget.onTagUpdate != null ||
                                    widget.customTagUpdate != null
                                ? (DragUpdateDetails details) =>
                                    _onTagUpdate(details, index)
                                : null,
                            child: items[index].child ?? tagWidget,
                          ))),
                ],
                if (widgetSize != null) ...[
                  TagTooltipWidget(
                    selected: selected,
                    options: options,
                    size: widgetSize!,
                  ),
                  // CustomPaint(
                  //   child: Text("123213121"),
                  //   foregroundPainter: _TooltipPainter(
                  //     widgetSize: widgetSize,
                  //     item: selected,
                  //     width: MediaQuery.of(context).size.width,
                  //     options: options,
                  //   ),
                  // ),
                ],
              ],
            );
          }),
    );
  }
}

// class _TooltipPainter extends CustomPainter {
//   final double width;
//   final Size? widgetSize;
//   final TagItem? item;
//   final TagTooltipOptions? options;

//   const _TooltipPainter({
//     required this.widgetSize,
//     required this.item,
//     required this.width,
//     required this.options,
//   });
//   @override
//   void paint(Canvas canvas, _) {
//     if (item != null && widgetSize != null) {
//       TagTooltipOptions options = TagTooltipOptions(
//         width: this.options?.width ?? widgetSize!.width * 0.3,
//         height: this.options?.height ?? widgetSize!.width * 0.15,
//         radius: this.options?.radius ?? 8,
//       );
//       Paint paint = Paint()..color = Colors.red;

//       int arrowSize = 15;

//       // RRect fullRect = RRect.fromRectAndRadius(
//       //   Rect.fromCenter(center: Offset(posX, posY), width: 100, height: 30),
//       //   Radius.circular(8),
//       // );
//       // (Path, TooltipMode) settings =
//       //     _drawArrow(arrowSize, posX, posY, tagWidth, tagHeight);
//       // canvas.drawPath(settings.$1, paint);
//       // _drawBox();
//       // canvas.drawRRect(_drawBox(options), paint);
//     }
//   }

//   RRect _drawBox(TagTooltipOptions options) {
//     double posX = widgetSize!.width * item!.x;
//     double posY = widgetSize!.height * item!.y;
//     double tagWidth = item!.child!.getWidth(width);
//     double tagHeight = item!.child!.getHeight(width);
//     // if (posX)
//     return RRect.fromRectAndRadius(
//       Rect.fromCenter(
//           center: Offset(posX, posY),
//           width: options.width!,
//           height: options.height!),
//       Radius.circular(options.radius!),
//     );
//   }

//   (Path, TooltipMode) _drawArrow(int arrowSize, double posX, double posY,
//       double tagWidth, double tagHeight) {
//     Path path = Path();

//     if (posX < arrowSize && posY > arrowSize) {
//       path.moveTo(posX, posY);
//       path.lineTo(posX, posY - arrowSize);
//       path.lineTo(posX + arrowSize + (tagWidth / 2), posY - arrowSize);
//       return (path, TooltipMode.left);
//     } else if (posX + arrowSize > width && posY > arrowSize) {
//       path.moveTo(posX, posY);
//       path.lineTo(posX - arrowSize - (tagWidth / 2), posY - arrowSize);
//       path.lineTo(posX, posY - arrowSize);
//       return (path, TooltipMode.right);
//     } else if (posY < arrowSize) {
//       if (posX < arrowSize) {
//         path.moveTo(posX, posY + (tagHeight / 2));
//         path.lineTo(posX, posY);
//         path.lineTo(posX + arrowSize + (tagWidth / 2), posY + (tagHeight / 2));
//         return (path, TooltipMode.topLeft);
//       } else if (posX + arrowSize > width) {
//         path.moveTo(posX, posY + (tagHeight / 2));
//         path.lineTo(posX - arrowSize - (tagWidth / 2), posY + (tagHeight / 2));
//         path.lineTo(posX, posY);
//         return (path, TooltipMode.topRight);
//       } else {
//         path.moveTo(posX, posY);
//         path.lineTo(posX - arrowSize, posY + arrowSize);
//         path.lineTo(posX + arrowSize, posY + arrowSize);
//         return (path, TooltipMode.top);
//       }
//     } else {
//       path.moveTo(posX, posY);
//       path.lineTo(posX - arrowSize, posY - arrowSize);
//       path.lineTo(posX + arrowSize, posY - arrowSize);
//       return (path, TooltipMode.nomal);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
