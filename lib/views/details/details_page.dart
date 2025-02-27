// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/controllers/details_controller.dart';
import 'package:rentbet/views/details/widgets/gallery_skeleton.dart';
import '../../models/listing_model.dart';
import '../../providers/wishlist_provider.dart';
import 'details_helpers.dart'; // Import the new file
import '/views/details/widgets/user_profile_section.dart';
import '/views/details/widgets/gallery_section.dart';
import '/views/details/widgets/map_view.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, String> property;
  const DetailsPage({Key? key, required this.property}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with AutomaticKeepAliveClientMixin {
  late DetailsController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = DetailsController();

    final category = widget.property['category'] ?? '';
    _controller.loadGalleryImages(category);

    final id = widget.property['id'];
    if (id != null && id.isNotEmpty) {
      _controller.loadBookmarkState(id);
    } else {
      // Handle a missing id, for example, log a message or set a default behavior.
      print('Property id is missing.');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isRent = (widget.property['type']?.toLowerCase() == 'rent');

    return ChangeNotifierProvider<DetailsController>(
      create: (_) => _controller,
      child: Consumer<DetailsController>(
        builder: (context, controller, child) {
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
                                icon: controller.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                onPressed: () async {
                                  await controller.toggleBookmarkState(widget.property['id']!);
                                  await controller.updateWishlist(context, widget.property);
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
                                        ? '${widget.property['price']!}/month'
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
                            controller.isGalleryLoading
                                ? const GallerySkeleton(itemCount: 3,)
                                : controller.galleryImages == null || controller.galleryImages!.isEmpty
                                ? const Center(child: Text('No gallery images available.'))
                                : GallerySection(
                              images: controller.galleryImages!,
                              onImageTap: (index, images) {
                                showFullScreenGallery(context, index, images);
                              },
                              onGalleryTap: (images) {
                                showGalleryBottomSheet(context, images);
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
        },
      ),
    );
  }
}