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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ImageTag(
            image: Image.network(
              "https://velog.velcdn.com/images/tygerhwang/post/11512c89-ada4-47d3-a71e-286a37932d16/image.avif",
            ),
          ),
        ],
      ),
    );
  }
}
