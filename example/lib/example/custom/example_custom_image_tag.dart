import 'package:flutter/material.dart';
import 'package:image_tag/image_tag.dart';

class ProductModel {
  final int no;
  final String name;
  final String brand;
  final int price;

  const ProductModel({
    required this.no,
    required this.name,
    required this.brand,
    required this.price,
  });
}

class ExampleCustomImageTag extends StatefulWidget {
  const ExampleCustomImageTag({super.key});

  @override
  State<ExampleCustomImageTag> createState() => _ExampleCustomImageTagState();
}

class _ExampleCustomImageTagState extends State<ExampleCustomImageTag>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  late List<ProductModel> products;
  bool isOpen = false;

  List<TagItem> items = [];
  TagItem? current;

  ProductModel? currentProduct;

  TagItem? selectTagItem;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    animation = Tween(begin: -0.8, end: 0.8).animate(controller);
    controller.repeat();

    _init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onLongTap(TagItem item) => setState(() {
        selectTagItem = item;
        isOpen = true;
        current = null;
      });

  void _onTap() => setState(() {
        isOpen = false;
        current = null;
      });

  void _onTagTap(TagItem item) => setState(() {
        current = item;
        currentProduct = item.arguments as ProductModel;
      });

  void _onTagUpdate(List<TagItem> items, TagItem item) =>
      setState(() => this.items = items);

  void _onListener(TagItem? item) => setState(() => current = item);

  void _itemSelected(int index) {
    if (selectTagItem != null) {
      TagItem item = selectTagItem!;
      item = item.copyWith(arguments: products[index], child: _child());
      setState(() {
        items = List.from(items)..add(item);
        isOpen = false;
      });
    }
  }

  void _itemRemoved(int index) => setState(() {
        items = List.from(items)..removeAt(index);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 65, 65, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ImageTag(
                  image: Image.asset("assets/images/fashion_image.jpg"),
                  onTap: (_) => _onTap(),
                  onTagTap: _onTagTap,
                  onLongTap: _onLongTap,
                  onTagUpdate: _onTagUpdate,
                  onListener: _onListener,
                  tagItems: items,
                  current: current,
                  options: TagTooltipOptions(
                    arrowSize: 30,
                    width: 140,
                    height: 80,
                    duration: 1000,
                    radius: 20,
                    color: Colors.cyan.withOpacity(0.8),
                    child: _tooltipChild(),
                  ),
                ),
              ],
            ),
          ),
          _appBar(),
          _productItem(),
          _selectItem(),
        ],
      ),
    );
  }

  Positioned _selectItem() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top,
      left: 12,
      child: Container(
        width: 50,
        height: MediaQuery.of(context).size.height / 2,
        color: Colors.transparent,
        child: ListView(
          children: [
            ...List.generate(
              items.length,
              (index) => Stack(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        (items[index].arguments as ProductModel).name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 6,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _itemRemoved(index),
                        child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.amber,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 10,
                              color: Colors.black,
                            )),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _tooltipChild() {
    if (currentProduct == null) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Name : ${currentProduct!.name} "),
              Text("Price : \$${currentProduct!.price} "),
              Text("Brand : \$${currentProduct!.brand} "),
            ],
          ),
        ),
      );
    }
  }

  AnimatedPositioned _productItem() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: isOpen ? 200 : 150),
      right: isOpen ? 12 : -80,
      top: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Container(
        width: 80,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.5),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 12),
            ...List.generate(
              products.length,
              (index) => GestureDetector(
                onTap: () => _itemSelected(index),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.9),
                  ),
                  child: Center(
                    child: Text(
                      products[index].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Positioned _appBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      child: Container(
        height: kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 24),
            Text(
              "Custom",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
                fontSize: 28,
              ),
            )
          ],
        ),
      ),
    );
  }

  TagContainer _child() {
    return TagContainer(
        width: 60,
        height: 60,
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(60, 60),
                painter: _TagPainter(
                  value: animation.value,
                ),
              );
            }));
  }

  void _init() {
    products = const [
      ProductModel(no: 0, name: "Outer", brand: "Brand 1", price: 400),
      ProductModel(no: 1, name: "T-shirt", brand: "Brand 1", price: 60),
      ProductModel(no: 2, name: "Long\nsleeve", brand: "Brand 2", price: 100),
      ProductModel(no: 3, name: "Pants", brand: "Brand 2", price: 75),
      ProductModel(no: 4, name: "Slacks", brand: "Brand 5", price: 80),
      ProductModel(no: 5, name: "Backpack", brand: "Brand 1", price: 300),
      ProductModel(no: 6, name: "Shoes", brand: "Brand 3", price: 200),
      ProductModel(no: 7, name: "Hat", brand: "Brand 5", price: 80),
      ProductModel(no: 8, name: "Sunglasses", brand: "Brand 3", price: 200),
      ProductModel(no: 9, name: "Camera", brand: "Brand 4", price: 1500),
      ProductModel(no: 10, name: "Accessory", brand: "Brand 3", price: 5)
    ];
  }
}

class _TagPainter extends CustomPainter {
  final double value;

  _TagPainter({required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.width / 2),
            width: 48,
            height: 48),
        0,
        7,
        true,
        paint);
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.width / 2), width: 53, height: 53);

    paint.color = Colors.white.withOpacity(value.abs());
    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.width / 2),
          width: 53,
          height: 53,
        ),
        0,
        7,
        true,
        paint);

    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = value.abs() * 5
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Colors.lightBlueAccent,
          Colors.purple,
          Colors.blue,
        ],
      ).createShader(rect);
    canvas.drawArc(rect, 0, 7, false, paint);
    Rect placeRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.width / 2 - 5),
      width: 30,
      height: 30,
    );
    paint
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.lightBlueAccent,
          Colors.purple,
        ],
      ).createShader(placeRect);
    ;
    canvas.drawArc(placeRect, 0, 7, true, paint);

    Path path = Path();
    path
      ..moveTo(size.width / 2 - 14.3, size.width / 2)
      ..lineTo(size.width / 2, size.width / 2 + 20)
      ..lineTo(size.width / 2 + 14.3, size.width / 2);
    canvas.drawPath(path, paint);

    paint
      ..color = Colors.white.withOpacity(0.8)
      ..shader = null;

    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.width / 2 - 5),
          width: 10,
          height: 10,
        ),
        0,
        7,
        true,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
