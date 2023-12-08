import 'package:flutter/material.dart';

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
    return Scaffold();
  }
}
