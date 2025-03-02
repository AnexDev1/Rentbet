// dart
import 'package:flutter/material.dart';
import 'dart:io';

class ImageStep extends StatelessWidget {
  final List<File> imageFiles;
  final VoidCallback pickImages;
  final VoidCallback takePhoto;
  final Function(int) removeImage;

  const ImageStep({
    super.key,
    required this.imageFiles,
    required this.pickImages,
    required this.takePhoto,
    required this.removeImage, required Color primaryColor, required Color secondaryColor, required Color accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Property Images',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.secondaryHeaderColor,
          ),
        ),
        const SizedBox(height: 16),
        imageFiles.isNotEmpty
            ? SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageFiles.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(imageFiles[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.remove_circle, color: theme.colorScheme.error),
                      onPressed: () => removeImage(index),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'MAIN',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        )
            : Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.hintColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.hintColor.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 48, color: theme.hintColor),
              const SizedBox(height: 12),
              Text(
                'No images selected',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 16, color: theme.hintColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: takePhoto,
                icon: Icon(Icons.camera_alt, color: theme.iconTheme.color),
                label: Text('Camera', style: theme.textTheme.labelLarge),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.hintColor,
                  side: BorderSide(color: theme.hintColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}