import 'package:flutter/material.dart';
import 'package:frontend/src/components/input/search_field.dart';

/*
  A page to contain the component SearchField
*/
class SearchFieldPage extends StatelessWidget {
  const SearchFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Center(
        child: SearchField(name: "search"),
      ),
    );
  }
}
