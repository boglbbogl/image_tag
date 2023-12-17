import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';

class CustomTagItem extends TagItem {
  final String content;

  const CustomTagItem({
    required super.x,
    required super.y,
    super.child,
    required this.content,
  });
}

class ExamplePageviewImageTag extends StatefulWidget {
  const ExamplePageviewImageTag({super.key});

  @override
  State<ExamplePageviewImageTag> createState() =>
      _ExamplePageviewImageTagState();
}

class _ExamplePageviewImageTagState extends State<ExamplePageviewImageTag> {
  final List<String> verticalImages = [
    "https://github.com/boglbbogl/image_tag/assets/75574246/6e31e6e7-2b4d-41d3-86c2-b4fd79d4ac70",
    "https://github.com/boglbbogl/image_tag/assets/75574246/a8600cf1-f856-44ce-a64a-3da7651f5165",
    "https://github.com/boglbbogl/image_tag/assets/75574246/a538f288-3bfb-45a9-8550-6bc1cfa449f7",
    "https://github.com/boglbbogl/image_tag/assets/75574246/61b82114-6686-440f-b508-cbebaeccea98",
  ];

  int verticalIndex = 0;

  void _onVerticalChanged(int index) => setState(() => verticalIndex = index);
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
                    itemCount: verticalImages.length,
                    onPageChanged: _onVerticalChanged,
                    itemBuilder: (context, index) {
                      return ImageTag(
                        onTap: (_) =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => _ExampleVerticalTagWidget(
                            image: verticalImages[index],
                          ),
                        )),
                        image: Image.network(
                          verticalImages[index],
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                        tagItems: [],
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
}

class _ExampleVerticalTagWidget extends StatefulWidget {
  final String image;
  const _ExampleVerticalTagWidget({
    required this.image,
  });

  @override
  State<_ExampleVerticalTagWidget> createState() =>
      __ExampleVerticalTagWidgetState();
}

class __ExampleVerticalTagWidgetState extends State<_ExampleVerticalTagWidget> {
  List<CustomTagItem> items = [];

  void _onAdd(TagItem item, String content) =>
      setState(() => items = List.from(items)
        ..add(
          CustomTagItem(
              x: item.x, y: item.y, child: item.child, content: content),
        ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageTag(
              image: Image.network(widget.image),
              onLongTap: (TagItem item) => showModalBottomSheet(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                  }),
              tagItems: items,
            )
          ],
        ));
  }
}
