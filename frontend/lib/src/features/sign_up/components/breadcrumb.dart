import 'package:flutter/material.dart';
import 'package:frontend/src/features/sign_up/sign_up_flow.dart';
import 'package:flow_builder/flow_builder.dart';

/*
  A navigation widget where user can go back to the previous page.
  @param text, the text to be displayed for the current page.
*/
class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    super.key,
    required this.text,
    this.page,
  });

  final String text;
  final int? page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Stack(
        children: [
          if (page != null) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () {
                  context.flow<UserFormData>().update(
                        (data) => data.copyWith(page: page),
                      );
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 29,
                  color: Color(0xFF6D7881),
                ),
              ),
            ),
          ],
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6D7881),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
