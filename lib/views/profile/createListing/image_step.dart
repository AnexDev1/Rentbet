import 'package:flutter/material.dart';
import 'dart:io';

class ImageStep extends StatelessWidget {
  final List<File> imageFiles;
  final VoidCallback pickImages;
  final VoidCallback takePhoto;
  final Function(int) removeImage;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const ImageStep({
    super.key,
    required this.imageFiles,
    required this.pickImages,
    required this.takePhoto,
    required this.removeImage,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Property Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
        ),
        SizedBox(height: 16),
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
                    margin: EdgeInsets.only(right: 8),
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
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => removeImage(index),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'MAIN',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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
            color: secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: secondaryColor.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 48, color: secondaryColor),
              SizedBox(height: 12),
              Text(
                'No images selected',
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: pickImages,
                icon: Icon(Icons.photo_library,color: Colors.white,),
                label: Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: takePhoto,
                icon: Icon(Icons.camera_alt, color: Colors.black87,),
                label: Text('Camera'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: secondaryColor,
                  side: BorderSide(color: secondaryColor),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}