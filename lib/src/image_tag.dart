import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';
import 'package:image_tag/src/tag_tooltip_widget.dart';
import 'dart:developer' as developer;

class ImageTag extends StatefulWidget {
  final bool debug;
  final Image image;
  final List<TagItem> tagItems;
  final TagItem? current;
  final TagTooltipOptions? options;
  final Alignment alignment;
  final Function(TagItem)? onTap;
  final Function(TagItem)? onLongTap;
  final Function(TagItem)? onDoubleTap;
  final Function(List<TagItem>, TagItem)? onTagUpdate;
  final Function(TagItem)? onTagTap;
  final Function(TagItem)? onTagLongTap;
  final Function(double, double, Offset)? customTap;
  final Function(double, double, Offset)? customLongTap;
  final Function(double, double, Offset)? customDoubleTap;
  final Function(double, double, int)? customTagUpdate;
  final Function(double, double, int)? customTagTap;
  final Function(double, double, int)? customTagLongTap;
  final Function(TagItem?)? onListener;
  const ImageTag({
    super.key,
    this.debug = true,
    required this.image,
    required this.tagItems,
    this.current,
    this.options,
    this.alignment = Alignment.center,
    this.onTap,
    this.onLongTap,
    this.onDoubleTap,
    this.onTagUpdate,
    this.onTagTap,
    this.onTagLongTap,
    this.customTap,
    this.customLongTap,
    this.customDoubleTap,
    this.customTagUpdate,
    this.customTagTap,
    this.customTagLongTap,
    this.onListener,
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
    _setCurrentItem();
    _setTagWidget();
    _setTooltipOptions();
  }

  @override
  void didUpdateWidget(covariant ImageTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _imageListener();
    _setCurrentItem();
    _setTagWidget();
    _setTooltipOptions();
    _setTagItem();
  }

  void _setTooltipOptions() => options = widget.options;

  void _setTagItem() => tagItems.value = widget.tagItems;

  void _setTagWidget() => tagWidget = const TagContainer();

  void _setCurrentItem() => selected.value = widget.current;

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

  void _onTapDown(TapDownDetails details) => tapDownDetails = details;

  void _onDoubleTapDown(TapDownDetails details) => tapDownDetails = details;

  void _onDoubleTap() {
    if (widgetSize != null && tapDownDetails != null) {
      TagItem item = _addTag(tapDownDetails!.localPosition);
      if (widget.onDoubleTap != null) {
        widget.onDoubleTap!(item);
        _log("[onDoubleTap] $item");
      }
      if (widget.customDoubleTap != null) {
        widget.customDoubleTap!(item.x, item.y, tapDownDetails!.localPosition);
        _log("[customDoubleTap] x : ${item.x}, y : ${item.y}");
      }
    }
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
        _log("[customLongTap] x : ${item.x}, y : ${item.y}");
      }
    }
  }

  void _onTap() {
    if (widgetSize != null && tapDownDetails != null) {
      TagItem item = _addTag(tapDownDetails!.localPosition);
      if (widget.onTap != null) {
        widget.onTap!(item);
        _log("[onTap] $item");
      }
      if (widget.customTap != null) {
        widget.customTap!(item.x, item.y, tapDownDetails!.localPosition);
        _log("[customTap] x : ${item.x}, y : ${item.y}");
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
      _log("[customTagTap] x : ${item.x}, y : ${item.y}, index : $index");
    }
    _onListener(item);
  }

  void _onTagLongTap(int index) {
    TagItem item = tagItems.value[index];
    if (widget.onTagLongTap != null) {
      widget.onTagLongTap!(item);
      _log("[onTagLongTap] $item");
    }
    if (widget.customTagLongTap != null) {
      widget.customTagLongTap!(item.x, item.y, index);
      _log("[customTagLongTap] x : ${item.x}, y : ${item.y}, index : $index");
    }
    _onListener(item);
  }

  void _onTagUpdate(DragUpdateDetails details, int index) {
    if (widgetSize != null) {
      double speed = options != null ? options!.speed : 2.0;
      List<TagItem> items = tagItems.value;
      TagItem item = items[index];
      final double dx =
          (item.x * widgetSize!.width) + (details.delta.dx * speed);
      final double dy =
          (item.y * widgetSize!.height) + (details.delta.dy * speed);

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
      item = item.copyWith(x: x, y: y, child: item.child ?? tagWidget);
      items = List.from(items)
        ..removeAt(index)
        ..insert(index, item);

      if (widget.onTagUpdate != null) {
        widget.onTagUpdate!(items, item);
        _log(
            "[onTagUpdate] items : ${items.length}, ${item.copyWith(x: x, y: y, child: item.child ?? tagWidget)}");
      }
      if (widget.customTagUpdate != null) {
        widget.customTagUpdate!(x, y, index);
        _log("[customTagUpdate] x : $x, y : $y, index : $index");
      }
      if (!(widget.onTagUpdate == null && widget.customTagUpdate == null)) {
        _onListener(null);
      }
    }
  }

  void _onTagUpdateStart(int index) {
    if (selected.value != null) {
      previousSelectNo = index;
    } else {
      previousSelectNo = null;
    }
    if (!(widget.onTagUpdate == null && widget.customTagUpdate == null)) {
      _onListener(null);
    }
  }

  void _onTagUpdateEnd(
    DragEndDetails details,
  ) {
    if (previousSelectNo != null) {
      selected.value = tagItems.value[previousSelectNo!];
    }
    previousSelectNo = null;
    _onListener(selected.value);
  }

  void _onListener(TagItem? item) {
    if (widget.onListener != null) {
      widget.onListener!(item);
    }
  }

  void _log(String log) {
    if (kDebugMode) {
      if (widget.debug) {
        developer.log('\x1B[36m $log \x1B[0m');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: SizedBox(
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
                    onDoubleTap: _onDoubleTap,
                    onDoubleTapDown: _onDoubleTapDown,
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
      ),
    );
  }
}
