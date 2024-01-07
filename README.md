# 🗨️ Image Tag

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/3f2ed9e4-20ff-4937-8dc0-e0076363aa7b" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/2333d3e8-3c52-4667-b5aa-e930386bde55" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/2a27c87b-cb34-4ac8-b99f-f43b54e9cb15" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/c6e89ab7-313b-4508-ad0c-28690a5a549b" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/b452ac5c-a6b3-4249-9d34-5444e7bf95ad" /></td>
  <tr>
</table>

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/7ce7748e-8d81-4071-973e-73ef78904e77" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/48185ac8-20bd-4d82-9e64-2373777a9ce9" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/df808d90-fa59-4531-abe9-793465291c7a" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/34699ff6-831d-4dc8-afd2-bd34c9ab17e0" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/dc403a91-d38b-4d7d-ae02-8aeede3b75d8" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/3bc4aea6-3a30-4786-b8df-9da30aac858b" /></td>

  <tr>
</table>

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


### Custom

[Custom Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/custom)

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/65f78969-eab4-4d2b-86c9-7cb90c5f319e" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/5a89d537-9cdb-46a0-b7c2-f8cb8730ddbe" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/f1dd14c0-78af-4235-97ef-e17ffbd39a61" /></td>
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
<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/8844ae48-d71d-4753-9591-0e468fa0ded2" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/feb09752-7219-4d90-9859-237472e5d87e" /></td>
  <tr>
</table>

-------------------------

### Simple

[Simple Example](https://github.com/boglbbogl/image_tag/tree/main/example/lib/example/simple)

<table>
  <tr>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/85a78204-401f-4e5c-8c89-f716323f5ca8" /></td>
    <td><img alt="" src="https://github.com/boglbbogl/image_tag/assets/75574246/f3594905-6227-4cfb-8c11-754b278bb825" /></td>
  <tr>
</table>

-------------------------

Created by Tyger [Github](https://github.com/boglbbogl)
