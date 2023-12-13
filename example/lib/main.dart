import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';

void main() {
  runApp(const MaterialApp(
    home: ExampleImageTag(),
  ));
}

class ExampleImageTag extends StatefulWidget {
  const ExampleImageTag({super.key});

  @override
  State<ExampleImageTag> createState() => _ExampleImageTagState();
}

class _ExampleImageTagState extends State<ExampleImageTag> {
  List<TagItem> items = [];

  void _add(TagItem item) {
    setState(() {
      items = List.from(items)..add(item);
    });
  }

  void _update(List<TagItem> items, TagItem item) {
    setState(() {
      this.items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ImageTag(
            debug: true,
            tagItems: items,
            image: Image.network(
              "https://velog.velcdn.com/images/tygerhwang/post/11512c89-ada4-47d3-a71e-286a37932d16/image.avif",
            ),
            onAdd: _add,
            onTagUpdate: _update,
            onTagTap: (_) {},
          ),
        ],
      ),
    );
  }
}
