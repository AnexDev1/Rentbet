// dart
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilter;

  const SearchBarWidget({Key? key, required this.onFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search_outlined, size: 30),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list_rounded, size: 30),
            onPressed: onFilter,
          ),
        ),
      ],
    );
  }
}