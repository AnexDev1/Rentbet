// Dart
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, String> property;

  const DetailsPage({Key? key, required this.property}) : super(key: key);

  // Dummy gallery images
  final List<String> galleryImages = const [
    'assets/onboarding.jpg',
    'assets/onboarding2.jpg',
    'assets/onboarding3.jpg',
    'assets/onboarding4.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            // Add extra padding at the bottom to avoid overlap
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        property['imageUrl']!,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black26),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: _buildRoundedIconButton(
                          icon: Icons.arrow_back_outlined,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 16,
                        child: _buildRoundedIconButton(
                          icon: Icons.bookmark_border,
                          onPressed: () {
                            // Bookmark action.
                          },
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property['price'] ?? 'Property Title',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              property['location'] ?? 'Location',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description section.
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        property['desc'] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      // Owner information.
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage('assets/profile_placeholder.png'),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'John Doe',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Owner',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _buildRectangularButton(
                            icon: Icons.call,
                            onPressed: () {
                              // Call action.
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildRectangularButton(
                            icon: Icons.message,
                            onPressed: () {
                              // Message action.
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Gallery section.
                      const Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _buildGalleryRow(context),
                      ),
                      const SizedBox(height: 24),
                      // Map view container.
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Text('Map View: Location'),
                        ),
                      ),
                      // Extra space to allow scrolling beyond bottom bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Static bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        property['price'] ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Rent now action.
                      },
                      child: const Text(
                        'Rent Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGalleryRow(BuildContext context) {
    int total = galleryImages.length;
    int displayCount = total > 3 ? 3 : total;
    List<Widget> items = [];
    for (int i = 0; i < displayCount; i++) {
      bool isLast = i == displayCount - 1 && total > 3;
      Widget imageWidget = GestureDetector(
        onTap: () {
          if (isLast) {
            _showGallery(context);
          } else {
            _showFullScreenGallery(context, i);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          width: 80,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  galleryImages[i],
                  fit: BoxFit.cover,
                ),
                if (isLast)
                  Container(
                    color: Colors.black45,
                    child: Center(
                      child: Text(
                        '+${total - 3}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      items.add(imageWidget);
    }
    return items;
  }

  void _showGallery(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: galleryImages.asMap().entries.map((entry) {
              int index = entry.key;
              String img = entry.value;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  _showFullScreenGallery(context, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFullScreenGallery(BuildContext context, int initialIndex) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Gallery',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  galleryImages[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRoundedIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  static Widget _buildRectangularButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}