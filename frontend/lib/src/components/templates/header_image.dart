import 'package:flutter/material.dart';

/* HeaderImage is used as a design template for the image at the top left of all screens*/
class HeaderImage extends StatelessWidget {
  const HeaderImage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 100, 25),
          child: Image.asset(
            'assets/images/corner.png',
          ),
        ),
        child,
      ],
    );
  }
}
