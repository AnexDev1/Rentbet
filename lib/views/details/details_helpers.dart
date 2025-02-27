// dart
import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: Colors.white,
      iconSize: 28,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const CircleBorder(),
        ),
        backgroundColor: WidgetStateProperty.all(
          Colors.black26
        ),
      ),
      splashRadius: 24,
    );
  }
}

void showFullScreenGallery(BuildContext context, int initialIndex, List<String> images) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Gallery',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Center(
              child: Image.network(
                images[index],
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      );
    },
  );
}

void showGalleryBottomSheet(BuildContext context, List<String> images) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showFullScreenGallery(context, index, images);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}