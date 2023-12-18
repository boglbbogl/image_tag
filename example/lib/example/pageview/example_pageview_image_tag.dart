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
    "https://velog.velcdn.com/images/tygerhwang/post/c29aefe4-4b98-48d2-a56b-b524ffed6a1c/image.png",
    "https://velog.velcdn.com/images/tygerhwang/post/5d58feb1-9fa7-41e1-b771-82aa47b3c7b1/image.png",
    "https://velog.velcdn.com/images/tygerhwang/post/2601abf9-7dee-48a8-ac1f-75b962b61be7/image.png",
    "https://velog.velcdn.com/images/tygerhwang/post/5b6785bc-bdf5-4914-875b-fbd25c70fc1b/image.png",
    "https://velog.velcdn.com/images/tygerhwang/post/01071f02-54d7-4ab4-882e-19d717e0a030/image.png",
    "https://velog.velcdn.com/images/tygerhwang/post/ec1d9fa4-1834-4b7b-8820-fafb1591c780/image.webp",
  ];
  int verticalIndex = 0;

  final List<String> horizontalImages = [
    "https://velog.velcdn.com/images/tygerhwang/post/05d8017e-417e-4d53-941b-4aacd852b6fc/image.jpg",
    "https://velog.velcdn.com/images/tygerhwang/post/3f7b9416-c520-469a-8fc0-83ed39f9ba9b/image.avif",
    "https://velog.velcdn.com/images/tygerhwang/post/5670560a-397d-4bdd-bc05-6201b24aac39/image.jpg",
    "https://velog.velcdn.com/images/tygerhwang/post/f48221ea-a8f2-4646-92b6-09311fe7a375/image.avif",
  ];
  List<CustomTagItem> horizontalData = [];
  int horizontalIndex = 0;

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
    for (final url in horizontalImages) {
      horizontalData = List.from(horizontalData)
        ..add(CustomTagItem(url: url, items: []));
    }
  }

  void _updateVerticalItems(Object? object, int index) {
    List<dynamic> values = object as List<dynamic>;
    List<TagItem> items = values.map((e) => e as TagItem).toList();

    setState(() {
      verticalData[index] = verticalData[index].copyWith(items: items);
      verticalCurrent = null;
    });
  }

  void _onVerticalListener(TagItem? item) =>
      setState(() => verticalCurrent = item);

  void _onVerticalChanged(int index) => setState(() {
        verticalIndex = index;
        verticalCurrent = null;
      });

  void _onHorizontalChanged(int index) =>
      setState(() => horizontalIndex = index);

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
                            .then(
                                (value) => _updateVerticalItems(value, index)),
                        onListener: _onVerticalListener,
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
          Container(
              width: MediaQuery.of(context).size.width,
              height: 4,
              color: Colors.amber),
          Container(
            color: Colors.black87,
            height: MediaQuery.of(context).size.height -
                (kToolbarHeight +
                    MediaQuery.of(context).padding.bottom +
                    MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                PageView.builder(
                    onPageChanged: _onHorizontalChanged,
                    itemCount: horizontalData.length,
                    itemBuilder: (context, index) {
                      return ImageTag(
                        image: Image.network(horizontalImages[index]),
                        onTap: (_) =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => _ExampleHorizontalTagWidget(
                                      items: horizontalData,
                                      index: horizontalIndex,
                                    ))),
                        tagItems: horizontalData[index].items,
                      );
                    }),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${horizontalIndex + 1}/${horizontalData.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 60,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          )
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

class _ExampleHorizontalTagWidget extends StatefulWidget {
  final List<CustomTagItem> items;
  final int index;
  const _ExampleHorizontalTagWidget({
    required this.items,
    required this.index,
  });

  @override
  State<_ExampleHorizontalTagWidget> createState() =>
      __ExampleHorizontalTagWidgetState();
}

class __ExampleHorizontalTagWidgetState
    extends State<_ExampleHorizontalTagWidget> {
  late PageController controller;
  List<CustomTagItem> items = [];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    controller = PageController(initialPage: widget.index);
  }

  void _onColorChanged(int index) => setState(() => colorIndex = index);

  void _onAdd(TagItem item, int index) => setState(() {
        CustomTagItem tag = items[index];
        items[index] = items[index].copyWith(
          items: [
            ...tag.items,
            item.copyWith(
                child: TagContainer(
              width: 50,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black87,
                ),
                child: Image.asset(
                  "assets/images/tag_icon.png",
                  width: 46,
                  height: 46,
                  color: Colors.accents[colorIndex],
                ),
              ),
            ))
          ],
        );
      });

  void _onUpdated(List<TagItem> items, int index) => setState(
      () => this.items[index] = this.items[index].copyWith(items: items));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      body: Stack(
        children: [
          PageView.builder(
              controller: controller,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ImageTag(
                  onDoubleTap: (TagItem item) => _onAdd(item, index),
                  onTagUpdate: (List<TagItem> items, _) =>
                      _onUpdated(items, index),
                  image: Image.network(widget.items[index].url),
                  tagItems: items[index].items,
                );
              }),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      ...List.generate(
                        15,
                        (index) => GestureDetector(
                          onTap: () => _onColorChanged(index),
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: colorIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: Image.asset(
                              "assets/images/tag_icon.png",
                              color: Colors.accents[index],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                )),
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
