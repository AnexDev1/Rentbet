// dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GallerySection extends StatelessWidget {
  final List<String> images;
  final Function(int, List<String>) onImageTap;
  final Function(List<String>) onGalleryTap;

  const GallerySection({
    super.key,
    required this.images,
    required this.onImageTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    final int totalImages = images.length;
    final int displayCount = totalImages > 3 ? 3 : totalImages;

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayCount,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          Widget imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: images[index],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          );

          if (index == 2 && totalImages > 3) {
            int extraCount = totalImages - displayCount;
            imageWidget = Stack(
              children: [
                imageWidget,
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+$extraCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return GestureDetector(
            onTap: () {
              if (index == 2 && totalImages > 3) {
                onGalleryTap(images);
              } else {
                onImageTap(index, images);
              }
            },
            child: imageWidget,
          );
        },
      ),
    );
  }
}