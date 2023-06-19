import 'package:flutter/material.dart';

/*
  A navigation widget where user can go back to the previous page.

  @param text, the text to be displayed for the current page.

  @param withBackIcon, whether to display the icon that navigates to previous page.

  @param onTap, optional function and this is called when user tapped the widget
  
*/
class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    super.key,
    required this.text,
    this.withBackIcon = true,
    this.onTap,
  });

  final String text;
  final bool withBackIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Stack(
        children: [
          Visibility(
            visible: withBackIcon,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.arrow_back,
                  size: 29,
                  color: Color(0xFF6D7881),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
