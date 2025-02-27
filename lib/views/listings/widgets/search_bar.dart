// dart
import 'package:flutter/material.dart';
import '../search_result_page.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onFilter;
  const SearchBarWidget({Key? key, required this.onFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(searchQuery: value),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search_outlined, size: 30),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded, size: 30),
            onSelected: (value) {
              onFilter(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'default',
                child: Text('Default'),
              ),
              PopupMenuItem(
                value: 'rent',
                child: Text('Rent'),
              ),
              PopupMenuItem(
                value: 'sell',
                child: Text('Sell'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}