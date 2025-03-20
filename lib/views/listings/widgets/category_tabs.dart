// dart
import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBgColor = theme.primaryColor;
    final selectedTextColor = theme.primaryTextTheme.labelLarge?.color ?? Colors.white;
    final unselectedTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final borderColor = theme.dividerColor;

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
                color: isSelected ? selectedBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                      color: isSelected ? selectedTextColor : unselectedTextColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}