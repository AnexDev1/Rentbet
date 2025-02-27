// dart
import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CategoryTabs({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}