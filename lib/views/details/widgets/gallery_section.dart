import 'package:flutter/material.dart';

class GallerySection extends StatelessWidget {
  final List<String> images;
  final void Function(int index, List<String> images) onImageTap;
  final void Function(List<String> images) onGalleryTap;

  const GallerySection({
    Key? key,
    required this.images,
    required this.onImageTap,
    required this.onGalleryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int displayCount = images.length > 3 ? 3 : images.length;
    return Row(
      children: List.generate(displayCount, (index) {
        if (index == 2 && images.length > 3) {
          int remaining = images.length - 3;
          return GestureDetector(
            onTap: () => onGalleryTap(images),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => onImageTap(index, images),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}