import 'package:flutter/material.dart';

class SubCatalogContainerWidget extends StatefulWidget {
  final String title;
  final Widget child;
  const SubCatalogContainerWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  State<SubCatalogContainerWidget> createState() =>
      _SubCatalogContainerWidgetState();
}

class _SubCatalogContainerWidgetState extends State<SubCatalogContainerWidget> {
  late double _heightEmailContainer = 0;
  bool emailExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                toogle();
              },
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                toogle();
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: AnimatedContainer(
            child: widget.child,
            width: double.infinity,
            height: _heightEmailContainer,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(
              milliseconds: 400,
            ),
          ),
        ),
      ],
    );
  }

  void toogle() {
    if (emailExpanded) {
      _heightEmailContainer = 0;
      emailExpanded = false;
    } else {
      _heightEmailContainer = 200;
      emailExpanded = true;
    }
    setState(() {});
  }
}
