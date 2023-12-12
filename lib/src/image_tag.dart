import 'package:flutter/material.dart';
import 'package:image_tag/src/tag_item.dart';

class ImageTag extends StatefulWidget {
  final Image image;
  final List<TagItem> tagItems;
  final double itemSize;
  final Widget? itemChild;
  final Decoration? itemDecoration;
  final Function(TagItem, double, double)? onAdd;
  final Function(List<TagItem>, double, double, int)? onUpdate;
  const ImageTag({
    super.key,
    required this.image,
    required this.tagItems,
    this.itemSize = 20,
    this.itemChild,
    this.itemDecoration,
    this.onAdd,
    this.onUpdate,
  });

  @override
  State<ImageTag> createState() => _ImageTagState();
}

class _ImageTagState extends State<ImageTag> {
  final GlobalKey widgetKey = GlobalKey();
  late Widget tagWidget;
  late Size imageSize;
  Size? widgetSize;

  ValueNotifier<List<TagItem>> tagItems = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _setTagWidget();
    _imageListener();
    _setTagItem();
  }

  @override
  void didUpdateWidget(covariant ImageTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTagWidget();
    _imageListener();
    _setTagItem();
  }

  void _setTagItem() => tagItems.value = widget.tagItems;

  void _setTagWidget() {
    tagWidget = Container(
      width: widget.itemSize,
      height: widget.itemSize,
      decoration: widget.itemDecoration ??
          BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.lightBlue),
      child: widget.itemChild,
    );
  }

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

  void _onShortTap(TapDownDetails details) {
    if (widgetSize != null) {
      double x = details.localPosition.dx / widgetSize!.width;
      double y = details.localPosition.dy / widgetSize!.height;
      final TagItem item = TagItem(x: x, y: y, child: tagWidget);
      if (widget.onAdd != null) {
        widget.onAdd!(item, x, y);
      }
    }
  }

  void _itemUpdate(DragUpdateDetails details, int index) {
    if (widgetSize != null) {
      List<TagItem> items = tagItems.value;
      TagItem item = items[index];
      double dx = (item.x * widgetSize!.width) + details.delta.dx;
      double dy = (item.y * widgetSize!.height) + details.delta.dy;
      double x = dx / widgetSize!.width;
      double y = dy / widgetSize!.height;
      items = List.from(items)
        ..removeAt(index)
        ..insert(index, item.copyWith(x: x, y: y));
      if (widget.onUpdate != null) {
        widget.onUpdate!(items, x, y, index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize != null ? widgetSize!.width : null,
      height: widgetSize != null ? widgetSize!.height : null,
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
                  onTapDown: (TapDownDetails details) => _onShortTap(details),
                  child: SizedBox(
                    width: widgetSize != null ? widgetSize!.width : null,
                    height: widgetSize != null ? widgetSize!.height : null,
                    child: widget.image,
                  ),
                ),
                if (widgetSize != null) ...[
                  ...List.generate(
                      items.length,
                      (index) => Positioned(
                          left: (widgetSize!.width * items[index].x) -
                              (widget.itemSize / 2),
                          top: (widgetSize!.height * items[index].y) -
                              (widget.itemSize / 2),
                          child: GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) =>
                                _itemUpdate(details, index),
                            child: items[index].child ?? tagWidget,
                          ))),
                ],
              ],
            );
          }),
    );
  }
}
