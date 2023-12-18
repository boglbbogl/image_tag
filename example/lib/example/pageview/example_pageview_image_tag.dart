import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';

class CustomTagItem {
  final String url;
  final List<TagItem> items;

  const CustomTagItem({required this.url, required this.items});

  CustomTagItem copyWith({
    final String? url,
    final List<TagItem>? items,
  }) =>
      CustomTagItem(url: url ?? this.url, items: items ?? this.items);
}

class ExamplePageviewImageTag extends StatefulWidget {
  const ExamplePageviewImageTag({super.key});

  @override
  State<ExamplePageviewImageTag> createState() =>
      _ExamplePageviewImageTagState();
}

class _ExamplePageviewImageTagState extends State<ExamplePageviewImageTag> {
  List<CustomTagItem> verticalData = [];
  TagItem? verticalCurrent;
  final List<String> verticalImages = [
    "https://github.com/boglbbogl/image_tag/assets/75574246/6e31e6e7-2b4d-41d3-86c2-b4fd79d4ac70",
    "https://github.com/boglbbogl/image_tag/assets/75574246/a8600cf1-f856-44ce-a64a-3da7651f5165",
    "https://github.com/boglbbogl/image_tag/assets/75574246/a538f288-3bfb-45a9-8550-6bc1cfa449f7",
    "https://github.com/boglbbogl/image_tag/assets/75574246/61b82114-6686-440f-b508-cbebaeccea98",
  ];

  int verticalIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    for (final url in verticalImages) {
      verticalData = List.from(verticalData)
        ..add(CustomTagItem(url: url, items: []));
    }
  }

  void _updateItems(Object? object, int index) {
    List<dynamic> values = object as List<dynamic>;
    List<TagItem> items = values.map((e) => e as TagItem).toList();

    setState(() {
      verticalData[index] = verticalData[index].copyWith(items: items);
      verticalCurrent = null;
    });
  }

  void _onListener(TagItem? item) => setState(() => verticalCurrent = item);

  void _onVerticalChanged(int index) => setState(() {
        verticalIndex = index;
        verticalCurrent = null;
      });

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
          "Pageview",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                color: const Color.fromRGBO(85, 85, 85, 1),
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: verticalData.length,
                    onPageChanged: _onVerticalChanged,
                    itemBuilder: (context, index) {
                      return ImageTag(
                        onTap: (_) => Navigator.of(context)
                            .push(MaterialPageRoute(
                              builder: (_) => _ExampleVerticalTagWidget(
                                item: verticalData[index],
                                child: child,
                              ),
                            ))
                            .then((value) => _updateItems(value, index)),
                        onListener: _onListener,
                        image: Image.network(
                          verticalData[index].url,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        current: verticalCurrent,
                        tagItems: verticalData[index].items,
                        options: _options(verticalCurrent),
                      );
                    }),
              ),
              Positioned(
                right: 8,
                top: 12,
                child: Column(
                  children: [
                    ...List.generate(
                      verticalImages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: verticalIndex == index
                              ? Colors.white
                              : const Color.fromRGBO(155, 155, 155, 1),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  TagTooltipOptions _options(TagItem? current) {
    return TagTooltipOptions(
        width: 100,
        height: 40,
        arrowSize: 12,
        color: Colors.orange.withOpacity(0.9),
        child: current != null
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  (current.arguments as Map<String, dynamic>)["content"],
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            : null);
  }

  TagContainer child = TagContainer(
      width: 40,
      height: 40,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.withOpacity(0.8), width: 3),
          color: Colors.black.withOpacity(0.8),
        ),
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.amber.withOpacity(0.8),
        ),
      ));
}

class _ExampleVerticalTagWidget extends StatefulWidget {
  final CustomTagItem item;
  final TagContainer child;
  const _ExampleVerticalTagWidget({
    required this.item,
    required this.child,
  });

  @override
  State<_ExampleVerticalTagWidget> createState() =>
      __ExampleVerticalTagWidgetState();
}

class __ExampleVerticalTagWidgetState extends State<_ExampleVerticalTagWidget> {
  List<TagItem> items = [];
  TagItem? current;

  @override
  void initState() {
    super.initState();
    setState(() {
      items = widget.item.items;
    });
  }

  void _onAdd(TagItem item, String content) =>
      setState(() => items = List.from(items)
        ..add(
          TagItem(
            x: item.x,
            y: item.y,
            child: widget.child,
            arguments: {"content": content},
          ),
        ));

  void _onUpdated(List<TagItem> items) => setState(() => this.items = items);

  void _onListener(TagItem? item) => setState(() => current = item);

  void _onCanceled() => setState(() => current = null);

  void _onDeleted(TagItem item) {
    setState(() {
      items = List.from(items)..remove(item);
      current = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageTag(
                  image: Image.network(widget.item.url),
                  onTap: (_) => _onCanceled(),
                  onLongTap: _bottomSheet,
                  onListener: _onListener,
                  onTagUpdate: (List<TagItem> items, _) => _onUpdated(items),
                  tagItems: items,
                  current: current,
                  options: options(current),
                )
              ],
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
        ));
  }

  TagTooltipOptions options(TagItem? current) {
    return TagTooltipOptions(
        width: 100,
        height: 40,
        arrowSize: 12,
        color: Colors.orange.withOpacity(0.9),
        child: current != null
            ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      (current.arguments as Map<String, dynamic>)["content"],
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: () => _onDeleted(current),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ))
                ],
              )
            : null);
  }

  void _bottomSheet(TagItem item) => showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Options",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            ...[
              "Color",
              "Wheel",
              "Roof",
              "Break",
              "Door",
            ].map((e) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _onAdd(item, e);
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        );
      });
}
