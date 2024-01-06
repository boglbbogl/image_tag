# 🗨️ Image Tag


## Features
- ImageTag
- TagContainer
- TagItem
- TagTooltipOptions

-----------

## Support Platforms

- Flutter Android
- Flutter iOS
- Flutter Web
- Flutter Desktop



## Usage

**_Add the package to pubspec.yaml_**

```
dependencies:
  image_tag: ^<latest-version>
```

**_After that import the package_**

```
import 'package:image_tag/image_tag.dart';
```

### ImageTag

```dart
ImageTag(
  debug: true,
  image: _imageUrl,
  tagItems: _items.
  current: _item,
  options: _options,
  alignment: Alignment.center,
  onTap: (TagItem item) => null,
  onLongTap: (TagItem item) => null,
  onDoubleTap: (TagItem item) => null,
  onTagUpdate: (List<TagItem> items, TagItem item) => null,
  onTagTap: (TagItem item) => null,
  onTagLongTap: (TagItem item) => null,
  customTap: (double x, double y, Offset position) => null,
  customLongTap: (double x, double y, Offset position) => null,
  customDoubleTap: (double x, double y, Offset position) => null,
  customTagUpdate: (double x, double y, int itemIndex) => null,
  customTagTap: (double x, double y, int itemIndex) => null,
  customTagLongTap: (double x, double y, int itemIndex) => null,
  onListener: (TagItem? item) => null,
);
```

### TagItem

```dart
TagItem(
  x: _x,
  y: _y,
  child: _child,
  arguments: _data, 
);
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
}
```

### TagTooltipOptions

```dart
TagTooltipOptions(
  tooltip: true,
  width: _width,
  height: _height,
  margin: 4.0,
  radius: 8.0,
  color: _color,
  arrowSize: 8.0,
  duration: 100,
  child: null,
  transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(scale: animation, child: child),
);
```

### TagContainer

```dart
TagContainer(
  height: _height,
  width: _width,
  child: _child,
);
```

## Example

### Simple

[Simple Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/simple)

### PageView

[PageView Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/pageview)

### Custom

[Custom Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/custom)

Created by Tyger [Github](https://github.com/boglbbogl)
