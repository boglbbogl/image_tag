import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';

class ExampleSimpleImageTag extends StatefulWidget {
  const ExampleSimpleImageTag({super.key});

  @override
  State<ExampleSimpleImageTag> createState() => _ExampleSimpleImageTagState();
}

class _ExampleSimpleImageTagState extends State<ExampleSimpleImageTag> {
  final String url =
      "https://github.com/boglbbogl/image_tag/assets/75574246/9746d95a-07b6-4cfe-b471-d7971802c81d";
  List<TagItem> items = [];
  TagItem? current;

  @override
  void initState() {
    super.initState();
  }

  void _updateItems(Object? object) {
    List<dynamic> values = object as List<dynamic>;
    List<TagItem> items = values.map((e) => e as TagItem).toList();
    setState(() => this.items = items);
  }

  void _onListener(TagItem? item) => setState(() => current = item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.amber,
          ),
        ),
        title: const Text(
          "Simple",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
      ),
      body: ListView(
        children: [
          ImageTag(
            image: Image.network(
              url,
            ),
            onTap: (_) => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (_) => ExampleSimpleTagWidget(
                          url: url,
                          tags: items,
                        )))
                .then(_updateItems),
            onListener: _onListener,
            tagItems: items,
            current: current,
            options: TagTooltipOptions(
                width: 60,
                height: 40,
                color: Colors.amber.withOpacity(0.8),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Item",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class ExampleSimpleTagWidget extends StatefulWidget {
  final String url;
  final List<TagItem> tags;
  const ExampleSimpleTagWidget({
    super.key,
    required this.url,
    required this.tags,
  });

  @override
  State<ExampleSimpleTagWidget> createState() => _ExampleSimpleTagWidgetState();
}

class _ExampleSimpleTagWidgetState extends State<ExampleSimpleTagWidget> {
  List<TagItem> items = [];

  @override
  void initState() {
    super.initState();
    setState(() => items = widget.tags);
  }

  void _addTag(TagItem item) =>
      setState(() => items = List.from(items)..add(item.copyWith()));

  void _updateTag(List<TagItem> items) => setState(() => this.items = items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      body: Stack(
        children: [
          Center(
            child: ImageTag(
              image: Image.network(
                widget.url,
              ),
              tagItems: items,
              onTap: _addTag,
              onTagUpdate: (List<TagItem> items, _) => _updateTag(items),
              options: TagTooltipOptions(
                  width: 60,
                  height: 40,
                  color: Colors.amber.withOpacity(0.8),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Item",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).padding.top,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(items),
              child: const Text(
                "Done",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
