import 'package:example/example/pageview/example_pageview_image_tag.dart';
import 'package:example/example/simple/example_simple_image_tag.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ExampleImageTag(),
  ));
}

class ExampleImageTag extends StatelessWidget {
  const ExampleImageTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
        title: const Text(
          "Image Tag",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.amber,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          _button(
            context,
            "Simple",
            const ExampleSimpleImageTag(),
          ),
          _button(
            context,
            "PageView",
            const ExamplePageviewImageTag(),
          ),
          _button(
            context,
            "Custom",
            const ExampleSimpleImageTag(),
          ),
        ],
      ),
    );
  }

  GestureDetector _button(
    BuildContext context,
    String title,
    Widget widget,
  ) =>
      GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => widget)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromRGBO(45, 45, 45, 1),
          ),
          padding: const EdgeInsets.only(left: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
}
