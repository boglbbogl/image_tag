import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
import 'package:image_tag/src/tag_tooltip_widget.dart';
import 'dart:developer' as developer;

class ImageTag extends StatefulWidget {
  final bool debug;
  final Image image;
  final List<TagItem> tagItems;
  final TagTooltipOptions? options;
  final Function(TagItem)? onTap;
  final Function(TagItem)? onLongTap;
  final Function(List<TagItem>, TagItem)? onTagUpdate;
  final Function(TagItem)? onTagTap;
  final Function(TagItem)? onTagLongTap;
  final Function(double, double, Offset)? customTap;
  final Function(double, double, Offset)? customLongTap;
  final Function(double, double, int)? customTagUpdate;
  final Function(double, double, int)? customTagTap;
  final Function(double, double, int)? customTagLongTap;
  const ImageTag({
    super.key,
    this.debug = false,
    required this.image,
    required this.tagItems,
    this.options,
    this.onTap,
    this.onLongTap,
    this.onTagUpdate,
    this.onTagTap,
    this.onTagLongTap,
    this.customTap,
    this.customLongTap,
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

  ValueNotifier<TagItem?> selected = ValueNotifier(null);
  int? previousSelectNo;

  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    super.initState();
    _imageListener();
    _setTagWidget();
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
            _setTagItem();
          }
        });
      }));
    });
  }

  TagItem _addTag(Offset offset) {
    double x = offset.dx / widgetSize!.width;
    double y = offset.dy / widgetSize!.height;
    return TagItem(x: x, y: y, child: tagWidget);
  }

  void _onLongTap(LongPressStartDetails details) {
    if (widgetSize != null) {
      TagItem item = _addTag(details.localPosition);
      if (widget.onLongTap != null) {
        widget.onLongTap!(item);
        _log("[onLongTap] $item");
      }
      if (widget.customLongTap != null) {
        widget.customLongTap!(item.x, item.y, details.localPosition);
        _log("[onLongTap] x : ${item.x}, y : ${item.y}");
      }
    }
  }

  void _onTapDown(TapDownDetails details) => tapDownDetails = details;

  void _onTap() {
    if (widgetSize != null && tapDownDetails != null) {
      TagItem item = _addTag(tapDownDetails!.localPosition);
      if (widget.onTap != null) {
        widget.onTap!(item);
        _log("[onTap] $item");
      }
      if (widget.customTap != null) {
        widget.customTap!(item.x, item.y, tapDownDetails!.localPosition);
        _log("[onTap] x : ${item.x}, y : ${item.y}");
      }
      selected.value = null;
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
    if (!(widget.onTagLongTap != null || widget.customTagLongTap != null)) {
      selected.value = item.copyWith(child: item.child ?? tagWidget);
    }
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
    if (widget.onTagLongTap != null || widget.customTagLongTap != null) {
      selected.value = item.copyWith(child: item.child ?? tagWidget);
    }
  }

  void _onTagUpdate(DragUpdateDetails details, int index) {
    if (widgetSize != null) {
      List<TagItem> items = tagItems.value;
      TagItem item = items[index];
      final double dx = (item.x * widgetSize!.width) + (details.delta.dx * 1.5);
      final double dy =
          (item.y * widgetSize!.height) + (details.delta.dy * 1.5);

      final double x = switch (dx / widgetSize!.width) {
        < 0 => 0,
        > 1 => 1,
        _ => dx / widgetSize!.width,
      };
      final double y = switch (dy / widgetSize!.height) {
        < 0 => 0,
        > 1 => 1,
        _ => dy / widgetSize!.height,
      };
      item = item.copyWith(x: x, y: y, child: tagWidget);
      items = List.from(items)
        ..removeAt(index)
        ..insert(index, item);

      selected.value = null;

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

  void _onTagUpdateStart(int index) {
    if (selected.value != null) {
      previousSelectNo = index;
    } else {
      previousSelectNo = null;
    }
  }

  void _onTagUpdateEnd(
    DragEndDetails details,
  ) {
    if (previousSelectNo != null) {
      selected.value = tagItems.value[previousSelectNo!];
    }
    previousSelectNo = null;
  }

  void _log(String log) {
    if (kDebugMode) {
      if (widget.debug) {
        developer.log('\x1B[36m $log \x1B[0m');
      }
    }
    ;
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
                  onTap: _onTap,
                  onTapDown: _onTapDown,
                  onLongPressStart: _onLongTap,
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
                              ((items[index].child ?? tagWidget)
                                      .getSize(
                                          MediaQuery.of(context).size.width)
                                      .$1 /
                                  2),
                          top: (widgetSize!.height * items[index].y) -
                              ((items[index].child ?? tagWidget)
                                      .getSize(
                                          MediaQuery.of(context).size.width)
                                      .$2 /
                                  2),
                          child: GestureDetector(
                            onLongPress: () => _onTagLongTap(index),
                            onTap: () => _onTagTap(index),
                            onPanUpdate: (DragUpdateDetails details) =>
                                _onTagUpdate(details, index),
                            onPanEnd: _onTagUpdateEnd,
                            onPanStart: (_) => _onTagUpdateStart(index),
                            child: items[index].child ?? tagWidget,
                          ))),
                ],
                if (widgetSize != null) ...[
                  ValueListenableBuilder<TagItem?>(
                      valueListenable: selected,
                      builder: (
                        BuildContext context,
                        TagItem? tag,
                        Widget? child,
                      ) {
                        return TagTooltipWidget(
                          selected: tag,
                          options: options,
                          size: widgetSize!,
                        );
                      }),
                ],
              ],
            );
          }),
    );
  }
}
