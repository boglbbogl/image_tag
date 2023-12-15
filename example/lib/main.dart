import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    HapticFeedback.mediumImpact();
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
              "https://velog.velcdn.com/images/tygerhwang/post/ff4112ae-3b2e-4e88-82a3-1f37e026863a/image.png",
              // "https://velog.velcdn.com/images/tygerhwang/post/11512c89-ada4-47d3-a71e-286a37932d16/image.avif",
            ),
            // onTagLongTap: _add,
            // onTap: _add,
            onLongTap: _add,
            onTagUpdate: _update,
            // onTagLongTap: (_) {},
            // onTagTap: (_) {},
            options: TagTooltipOptions(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
