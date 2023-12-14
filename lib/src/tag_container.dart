import 'package:flutter/material.dart';

class TagContainer extends StatefulWidget {
  final double? height;
  final double? width;
  final Widget? child;
  const TagContainer({
    super.key,
    this.height,
    this.width,
    this.child,
  });

  @override
  State<TagContainer> createState() => _TagContainerState();

  double getWidth(double width) {
    if (this.width != null) {
      return this.width!;
    } else if (this.width == null && height != null) {
      return height!;
    } else {
      return width * 0.085;
    }
  }

  double getHeight(double width) {
    if (height != null) {
      return height!;
    } else if (height == null && this.width != null) {
      return this.width!;
    } else {
      return width * 0.085;
    }
  }
}

class _TagContainerState extends State<TagContainer> {
  Size? size;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updated();
  }

  void _updated() {
    if (widget.width != null && widget.height != null) {
      size = Size(widget.width!, widget.height!);
    } else if (widget.width != null && widget.height == null) {
      size = Size(widget.width!, widget.width!);
    } else if (widget.width == null && widget.height != null) {
      size = Size(widget.height!, widget.height!);
    } else {
      double width = MediaQuery.of(context).size.width * 0.085;
      size = Size(width, width);
    }
  }

  @override
  void didUpdateWidget(covariant TagContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updated();
  }

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size!.height,
          maxWidth: size!.width,
          minHeight: 0,
          minWidth: 0,
        ),
        child: widget.child ??
            Container(
              width: size!.width,
              height: size!.height,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(size!.width),
              ),
              child: Icon(
                Icons.add,
                size: size!.width * 0.85,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
      );
    } else {
      return Container();
    }
  }
}
