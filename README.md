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
  height: 60.0,
  width: 100.0,
  child: Container(color: Colors.black),
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
```

## Example



### Simple

[Simple Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/simple)

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/85a78204-401f-4e5c-8c89-f716323f5ca8" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/f3594905-6227-4cfb-8c11-754b278bb825" /></td>
  <tr>
</table>

-------------------------

### PageView

[PageView Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/pageview)

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/568197e5-d9f2-4210-9911-d1bed9a12138" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/d696763e-ad28-4311-ba38-bc6dd71daab0" /></td>
  <tr>
</table>
<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/1993ba88-90b0-457d-9116-f21c127da32d" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/a024729b-725c-40b6-a175-2ccd91b64572" /></td>
  <tr>
</table>

-------------------------

### Custom

[Custom Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/custom)

-------------------------

Created by Tyger [Github](https://github.com/boglbbogl)
