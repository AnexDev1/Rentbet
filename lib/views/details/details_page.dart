// dart
import 'package:flutter/material.dart';
import 'package:rentbet/views/details/widgets/gallery_skeleton.dart';
import '/common/widgets/rounded_icon_button.dart';
import '/views/details/widgets/user_profile_section.dart';
import '/views/details/widgets/gallery_section.dart';
import '/views/details/widgets/map_view.dart';
import '../../services/listings_service.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, String> property;
  const DetailsPage({Key? key, required this.property}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with AutomaticKeepAliveClientMixin {
  List<String>? _galleryImages;
  bool _isGalleryLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final images = await ListingsService().fetchGalleryImagesByCategory(
      widget.property['category'] ?? '',
    );
    if (mounted) {
      setState(() {
        _galleryImages = images;
        _isGalleryLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isRent = (widget.property['type']?.toLowerCase() == 'rrent');

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
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
                      Image.network(
                        widget.property['imageUrl']!,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black26),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: RoundedIconButton(
                          icon: Icons.arrow_back_outlined,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 16,
                        child: RoundedIconButton(
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
                              widget.property['price'] != null && isRent
                                  ? widget.property['price']! + '/month'
                                  : widget.property['price'] ?? 'Price not available',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.property['location'] ?? 'Location',
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
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.property['desc'] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      UserProfileSection(
                        onCall: () {
                          // Call action.
                        },
                        onMessage: () {
                          // Message action.
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _isGalleryLoading
                          ? const GallerySkeleton(itemCount: 3,)
                          : _galleryImages == null || _galleryImages!.isEmpty
                          ? const Center(child: Text('No gallery images available.'))
                          : GallerySection(
                        images: _galleryImages!,
                        onImageTap: (index, images) {
                          _showFullScreenGallery(context, index, images);
                        },
                        onGalleryTap: (images) {
                          _showGalleryBottomSheet(context, images);
                        },
                      ),
                      const SizedBox(height: 24),
                      const MapView(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                        widget.property['price'] != null && isRent
                            ? widget.property['price']! + '/month'
                            : widget.property['price'] ?? '',
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
                        // Button action.
                      },
                      child: Text(
                        isRent ? 'Rent Now' : 'Schedule a tour',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
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

  void _showFullScreenGallery(BuildContext context, int initialIndex, List<String> images) {
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

  void _showGalleryBottomSheet(BuildContext context, List<String> images) {
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
                  _showFullScreenGallery(context, index, images);
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
}