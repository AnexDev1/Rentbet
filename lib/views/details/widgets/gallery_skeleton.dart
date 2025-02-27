// dart
import 'package:flutter/material.dart';

class GallerySkeleton extends StatelessWidget {
  final int itemCount;
  const GallerySkeleton({Key? key, this.itemCount = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Adjust height as needed
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,  // Adjust width as needed
            height: 80,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}